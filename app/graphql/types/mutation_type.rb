module Types
  class MutationType < Types::BaseObject
    field :meal_create, mutation: Mutations::Meal::Create
    field :meal_update, mutation: Mutations::Meal::Update
    field :meal_delete, mutation: Mutations::Meal::Delete
    field :add_to_cart, mutation: Mutations::Order::AddToCart
    field :place_order, mutation: Mutations::Order::PlaceOrder
    field :update_order_status, mutation: Mutations::Order::UpdateOrderStatus
    field :update_all_orders_status, mutation: Mutations::Order::UpdateAllOrdersStatus
  end
end
