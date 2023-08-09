module Types
  class MutationType < Types::BaseObject
    field :meal_create, mutation: Mutations::Meal::Create
  end
end
