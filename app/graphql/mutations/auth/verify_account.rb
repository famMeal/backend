module Mutations::Auth
  class VerifyAccount < GraphqlDevise::Mutations::ConfirmRegistrationWithToken 
    argument :confirmation_token, String, required: true
    argument :email, String, required: true

    field :credentials,
          GraphqlDevise::Types::CredentialType,
          null:        true,
          description: 'Authentication credentials. Null unless user is signed in after confirmation.'
    field :authenticatable, Types::UserType, null: true

    def resolve(email:, confirmation_token:)
      resource = User.find_by(email: email, confirmation_token: confirmation_token)
      
      return raise_user_error("Invalid confirmation token") unless resource
      
      resource.confirmed_at = DateTime.now
      resource.save!

      if resource.errors.empty?
        yield resource if block_given?

        response_payload = { authenticatable: resource }

        response_payload[:credentials] = generate_auth_headers(resource) if resource.active_for_authentication?

        response_payload
      else
        raise_user_error(I18n.t('graphql_devise.confirmations.invalid_token'))
      end
    end
  end
end