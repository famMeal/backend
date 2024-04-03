module Types
  module FilterObjects
    class OrdersFilterObject < GraphQL::Schema::InputObject
      argument :status_list, [Types::FilterObjects::OrderStatusField], required: false, description: "Filter by status"
      argument :date_range, Types::FilterObjects::DateRangeField, required: false, description: "Returns todays or not todays orders"

      def apply(object)
        scope = object.orders
  
        unless status_list.empty?
          status_array = []

          status_list.each do |status|
            if status == :completed
              status_array << "completed_client"
              status_array << "completed_restaurant"
            elsif status 
              status_array << status.to_s
            end
          end
          scope = object.orders.where(status: status_array)
        end

        today = DateTime.now.beginning_of_day..DateTime.now.end_of_day
        scope = scope.where(order_placed_at: today) if date_range == :today
        scope = scope.where.not(order_placed_at: today) if date_range == :not_today
        
        scope
      end
    end
  end
end