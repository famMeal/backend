module Types
  class MutationType < Types::BaseObject
    field :meal_create, mutation: Mutations::Meal::Create
    field :meal_update, mutation: Mutations::Meal::Update
  end
end
