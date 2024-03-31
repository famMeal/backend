module Types
  module FilterObjects
    class OrderStatusField < GraphQL::Schema::Enum
      value "CART", "Filters for orders with the status cart", value: :cart
      value "PAYMENT_FAILED", "Filters for orders with the status payment_failed", value: :payment_failed
      value "PREPARING", "Filters for orders with the status preparing", value: :preparing
      value "READY", "Filters for orders with the status ready", value: :ready
      value "PICKED_UP", "Filters for orders with the status picked_up", value: :picked_up
      value "COMPLETED", "Filters for orders with the status completed", value: :completed
      value "CANCELLED", "Filters for orders with the status cancelled", value: :cancelled
    end
  end
end