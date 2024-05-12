module Mutations::Restaurant
  class CreateOrUpdateStripeAccount < Mutations::BaseMutation 
    field :error_message, String, null: true
    field :redirect_link, String, null: true

    def resolve
      raise StandardError.new("You are not authorized to perform this action") unless context[:current_resource].is_store_owner 
      
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      
      restaurant = context[:current_resource].restaurant
      stripe_account_id = restaurant.stripe_account_id
      
      account = if stripe_account_id.present?
        Stripe::Account.retrieve(stripe_account_id)
      else
        Stripe::Account.create({
          capabilities: { card_payments: { requested: true }, transfers: { requested: true } },
          type: "custom",
          country: "CA"
        })
      end

      restaurant.update!(stripe_account_id: account.id) unless stripe_account_id.present?

      redirect_link = Stripe::AccountLink.create({
        account: account.id,
        refresh_url: 'https://batch-app.info',
        return_url: 'https://batch-app.info',
        type: 'account_onboarding',
      })

      { redirect_link: redirect_link.url, errors: [] }
    rescue StandardError => e
      { error_message: e.message }
    end
  end
end