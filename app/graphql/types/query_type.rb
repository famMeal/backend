module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :restaurants, [RestaurantType], null: false
   
    def restaurants
      Restaurant.all
    end
  end
end
