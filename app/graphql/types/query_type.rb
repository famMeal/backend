module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :restaurants, [Types::RestaurantType], null: false, authenticate: false
    field :meals, [Types::MealType], null: false, authenticate: false
    field :restaurant, Types::RestaurantType, null: true, authenticate: false do
      argument :id, ID, required: true
    end
    field :user, Types::UserType, null: true, authenticate: false do
      argument :id, ID, required: true
    end
    field :meal, Types::MealType, null: true, authenticate: false do
      argument :id, ID, required: true
    end
    field :order, Types::OrderType, null: true, authenticate: false do
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

    def meals
      Meal.all
    end

    def meal(id:)
      Meal.find_by(id: id)
    end 

    def order(id:)
      Order.find_by(id: id)
    end  
  end
end
