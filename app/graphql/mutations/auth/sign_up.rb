
module Mutations::Auth
  class SignUp < GraphqlDevise::Mutations::Register
    argument :email,                 String, required: true
    argument :password,              String, required: true
    argument :password_confirmation, String, required: true
    argument :restaurant_name,       String, required: false

    field :credentials,
          GraphqlDevise::Types::CredentialType,
          null:        true,
          description: 'Authentication credentials. Null if after signUp resource is not active for authentication (e.g. Email confirmation required).'
    field :authenticatable, Types::UserType, null: true

    def resolve(confirm_url: nil, **attrs)
      return raise_user_error_list("Passwords do not match", errors: []) if attrs[:password] != attrs[:password_confirmation]
      
      ActiveRecord::Base.transaction do
        resource = build_resource(attrs.except(:restaurant_name).merge(provider: provider, confirmation_token: rand(100000...999999).to_s))
  
        resource.save!

        yield resource if block_given?

        Restaurant.create!(name: attrs[:restaurant_name]) if attrs[:restaurant_name].present?
        
        unless resource.confirmed?
          resource.send_confirmation_instructions(
            confirmation_code:  resource.confirmation_token,
            template_path: ['graphql_devise/mailer']
          )
        end

        response_payload = { authenticatable: resource }

        response_payload[:credentials] = generate_auth_headers(resource) if resource.active_for_authentication?

        response_payload 
      end
    rescue => e
      return raise_user_error_list(e.message, errors: [])
    end
    private

    def build_resource(attrs)
      User.new(attrs)
    end
  end
end
