
module Mutations::Meal
  class Delete < Mutations::BaseMutation
    argument :meal_id, ID, required: true

    field :errors, [String], null: false
    field :meal, Types::MealType, null: true

    def resolve(**args)
      meal = Meal.find(args[:meal_id])
      
      meal.destroy!

      { meal: meal, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end
  end
end