
module Mutations::Order
  class AddTip < Mutations::BaseMutation
    argument :order_id, ID, required: true
    argument :tip_amount, Float, required: false
    argument :tip_percentage, Integer, required: false

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true

    def resolve(**args)
      raise StandardError.new("Choose either tip percentage or amount, not both") if args[:tip_percentage] && args[:tip_amount]
      raise StandardError.new("Choose either tip percentage or amount") if args[:tip_percentage].nil? && args[:tip_amount].nil?
      
      order = Order.find(args[:order_id])
      
      new_tip_amount = args[:tip_amount] || (order.total - order.tip_amount) * (args[:tip_percentage].to_d / 100.00)
      new_tip_percentage = args[:tip_percentage] || nil

      order.update!(
        tip_amount: new_tip_amount, 
        tip_percentage: new_tip_percentage,
        total: (order.total - order.tip_amount) + new_tip_amount
      )

      { order: order, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end
  end
end