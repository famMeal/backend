
module Mutations::Meal
  class Create < Mutations::BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false
    argument :active, Boolean, required: false
    argument :price, Float, required: true
    argument :restaurant_id, ID, required: true

    field :errors, [String], null: false
    field :meal, Types::MealType, null: true

    def resolve(**args)
      
      meal = Meal.create!(
        name: args[:name],
        description: args[:description],
        price: args[:price],
        restaurant_id: args[:restaurant_id]
      )

      { meal: meal, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end
  end
end