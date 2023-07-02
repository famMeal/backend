module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :restaurants, [Types::RestaurantType], null: false
    field :restaurant, Types::RestaurantType, null: true do
      argument :id, ID, required: true
    end
    field :user, Types::UserType, null: true do
      argument :id, ID, required: true
    end
    field :meal, Types::MealType, null: true do
      argument :id, ID, required: true
    end
    field :order, Types::OrderType, null: true do
      argument :id, ID, required: true
    end

    def restaurants
      Restaurant.all
    end

    def restaurant(id:)
      Restaurant.find_by(id: id)
    end

    def user(id:)
      User.find_by(id: id)
    end

    def meal(id:)
      Meal.find_by(id: id)
    end 

    def order(id:)
      Order.find_by(id: id)
    end  
  end
end
