
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
      ActiveRecord::Base.transaction do
        resource = build_resource(attrs.except(:restaurant_name).merge(provider: provider, confirmation_token: rand(100000...999999).to_s))
        raise_user_error(I18n.t('graphql_devise.resource_build_failed')) if resource.blank?
        
        Restaurant.create!(name: attrs[:restaurant_name]) if attrs[:restaurant_name].present?

          if resource.save
            yield resource if block_given?

            unless resource.confirmed?
              resource.send_confirmation_instructions(
                confirmation_code:  resource.confirmation_token,
                template_path: ['graphql_devise/mailer']
              )
            end

            response_payload = { authenticatable: resource }

            response_payload[:credentials] = generate_auth_headers(resource) if resource.active_for_authentication?

            response_payload
          else
            resource.try(:clean_up_passwords)
            raise_user_error_list(
              I18n.t('graphql_devise.registration_failed'),
              resource: resource
            )
          end
        end
    end

    private

    def build_resource(attrs)
      User.new(attrs)
    end
  end
end
