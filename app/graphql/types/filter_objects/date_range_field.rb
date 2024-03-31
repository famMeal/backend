module Types
  module FilterObjects
    class DateRangeField < GraphQL::Schema::Enum
      value "TODAY", "Filters for todays order", value: :today
      value "NOT_TODAY", "Filters for all orders except todays", value: :not_today
    end
  end
end