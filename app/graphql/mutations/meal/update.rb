
module Mutations::Meal
  class Update < Mutations::BaseMutation
    argument :name, String, required: false
    argument :description, String, required: false
    argument :active, Boolean, required: false
    argument :price, Float, required: false
    argument :meal_id, ID, required: true

    field :errors, [String], null: false
    field :meal, Types::MealType, null: true

    def resolve(**args)
      meal = Meal.find(args[:meal_id])
      meal.update!(args)

      { meal: meal, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end
  end
end