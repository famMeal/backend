puts 'Destroying current DB 🔥'

User.destroy_all
Restaurant.destroy_all

puts 'Creating new restaurant 🍽'

restaurant = Restaurant.create!(
  name: 'Centro Cafe',
  address_line_1: '91 Bayview Ave',
  city: 'Toronto',
  province: 'ON',
  postal_code: 'M2K 1E6',
  country: 'canada'
)

RestaurantSetting.create!(
  order_start_time: DateTime.new(2000, 01, 01, 9, 00, 0),
  order_cutoff_time: DateTime.new(2000, 01, 01, 16, 00, 0),
  pickup_start_time: DateTime.new(2000, 01, 01, 18, 00, 0),
  pickup_end_time: DateTime.new(2000, 01, 01, 20, 00, 0),
  restaurant: restaurant
)

puts 'Creating new users 👩🏽‍💻'

kristine_owner = User.create!(
  first_name: "Kristine",
  last_name: "McBride",
  email: "kristinelmcbride@gmail.com",
  password: "password",
  restaurant: restaurant,
  is_store_owner: true
)

User.create!(
  first_name: "Shahyn",
  last_name: "Kamali",
  email: "shahynkamali@gmail.com",
  password: "password",
  restaurant: restaurant
)

monty_the_guest = User.create!(
  first_name: "Monty",
  last_name: "McBride",
  email: "kristinelmcbride+monty@gmail.com",
  password: "password"
)

puts 'Creating meals 🥘'

rice_and_chicken = Meal.create!(
  name: "Chicken fried rice",
  description: "chicken, rice, egg and mixed veggies",
  active: true,
  price: 15.0,
  restaurant: restaurant
)

Meal.create!(
  name: "Salmon gnocchi",
  description: "gnocchi with asparagus, peppers & pesto sauce",
  active: false,
  price: 15.0,
  restaurant: restaurant
)

puts 'Creating order 📄'

Order.create!(
  status: 'processing',
  pickup_start_time: DateTime.new(2000, 01, 01, 18, 00, 0),
  pickup_end_time: DateTime.new(2000, 01, 01, 18, 15, 0),
  total: 20.0,
  subtotal: 15.0,
  tip_amount: 3.05,
  meal: rice_and_chicken,
  user: monty_the_guest
)

