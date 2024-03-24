module Types
  class MutationType < Types::BaseObject
    field :meal_create, mutation: Mutations::Meal::Create, authenticate: false
    field :meal_update, mutation: Mutations::Meal::Update, authenticate: false
    field :meal_delete, mutation: Mutations::Meal::Delete, authenticate: false
    field :add_to_cart, mutation: Mutations::Order::AddToCart, authenticate: false
    field :place_order, mutation: Mutations::Order::PlaceOrder, authenticate: false
    field :update_order, mutation: Mutations::Order::UpdateOrder, authenticate: false
    field :update_all_orders_status, mutation: Mutations::Order::UpdateAllOrdersStatus, authenticate: false
    field :add_tip, mutation: Mutations::Order::AddTip, authenticate: false
    field :update_restaurant_setting, mutation: Mutations::RestaurantSetting::UpdateSetting, authenticate: false
    field :sign_up, mutation: Mutations::Auth::SignUp, authenticate: false
    field :verify_account, mutation: Mutations::Auth::VerifyAccount, authenticate: false
  end
end
