module Types
  module FilterObjects
    class OrdersFilterObject < GraphQL::Schema::InputObject
      argument :status, Types::FilterObjects::OrderStatusField, required: false, description: "Filter by status"
      argument :date_range, Types::FilterObjects::DateRangeField, required: false, description: "Returns todays or not todays orders"

      def apply(object)
        scope = object.orders
    
        if status == :completed
          scope = object.orders.where(status: ["completed_client", "completed_restaurant"])
        elsif status 
          scope = object.orders.where(status: status.to_s)
        end

        today = DateTime.now.beginning_of_day..DateTime.now.end_of_day
        scope = scope.where(order_placed_at: today) if date_range == :today
        scope = scope.where.not(order_placed_at: today) if date_range == :not_today
        
        scope
      end
    end
  end
end