require 'date'

puts 'Destroying current DB 🔥'

User.destroy_all
Restaurant.destroy_all

puts 'Creating restaurants 🍽'

def create_restaurant(name, lat, long)
  Restaurant.create!(
    name: name,
    address_line_1: '91 Bayview Ave',
    city: 'Toronto',
    province: 'ON',
    postal_code: 'M2K 1E6',
    latitude: lat, 
    longitude: long
  )
end

def create_restaurant_setting(restaurant, order_start, order_cutoff, pickup_start, pickup_end, quantity)
  today = Date.today
  RestaurantSetting.create!(
    order_start_time: DateTime.new(today.year, today.month, today.day, order_start, 00, 0),
    order_cutoff_time: DateTime.new(today.year, today.month, today.day, order_cutoff, 00, 0),
    pickup_start_time: DateTime.new(today.year, today.month, today.day, pickup_start, 00, 0),
    pickup_end_time: DateTime.new(today.year, today.month, today.day, pickup_end, 00, 0),
    quantity_available: quantity,
    restaurant: restaurant
  )
end

def create_user(first_name, last_name, email, password, restaurant, is_owner)
  User.create!(
    first_name: first_name,
    last_name: last_name,
    email: email,
    password: password,
    restaurant: restaurant,
    is_store_owner: is_owner,
    confirmed_at: DateTime.now
  )
end

def create_meal(name, description, price, restaurant)
  Meal.create!(
    name: name,
    description: description,
    active: true,
    price: price,
    restaurant: restaurant
  )
end

def create_order(status, pickup_start, pickup_end, total, subtotal, tip, meal, user, order_placed_at = nil)
  today = Date.today
  Order.create!(
    status: status,
    pickup_start_time: DateTime.new(today.year, today.month, today.day, pickup_start, 00, 0),
    pickup_end_time: DateTime.new(today.year, today.month, today.day, pickup_end, 15, 0),
    total: total,
    subtotal: subtotal,
    tip_amount: tip,
    meal: meal,
    user: user,
    order_placed_at: order_placed_at || DateTime.now
  )
end

# Provided restaurant data with unique names and corresponding meals
restaurant_data = [
  { name: 'Basil Bliss', lat: 43.64289429999999, long: -79.4084768, meal: { name: "Pesto Pasta", description: "Fresh pasta tossed in homemade basil pesto sauce, perfect for a quick, flavorful meal.", price: 12.0 } },
  { name: 'Celtic Cravings', lat: 43.6384423, long: -79.4172366, meal: { name: "Irish Stew", description: "Hearty stew made with tender lamb, potatoes, and carrots in a rich broth, a comforting batch meal.", price: 10.0 } },
  { name: 'Siam Savory', lat: 43.6381558, long: -79.41763329999999, meal: { name: "Green Curry", description: "Fragrant green curry with chicken, bamboo shoots, and Thai basil, served with jasmine rice.", price: 14.0 } },
  { name: 'The Curry Leaf', lat: 43.6390608, long: -79.4177271, meal: { name: "Vegetable Biryani", description: "Aromatic basmati rice cooked with mixed vegetables, spices, and herbs, a perfect batch-cooked dish.", price: 9.0 } },
  { name: 'Smokehouse Eats', lat: 43.64569669999999, long: -79.4107488, meal: { name: "Pulled Pork", description: "Slow-cooked pulled pork with a smoky BBQ sauce, served with a side of coleslaw.", price: 11.0 } },
  { name: 'Grill Masters', lat: 43.64328, long: -79.41211899999999, meal: { name: "BBQ Chicken", description: "Grilled chicken basted with BBQ sauce, served with a side of grilled vegetables.", price: 17.0 } },
  { name: 'Taco Haven', lat: 43.6422885, long: -79.4113172, meal: { name: "Beef Tacos", description: "Soft tacos filled with seasoned beef, fresh salsa, and topped with cheese and lettuce.", price: 10.0 } },
  { name: 'Burger Barn', lat: 43.6451094, long: -79.4148802, meal: { name: "Cheeseburger", description: "Juicy cheeseburger with lettuce, tomato, and a side of crispy fries.", price: 12.0 } },
  { name: 'Southern Comfort', lat: 43.6435154, long: -79.4227669, meal: { name: "Buttermilk Fried Chicken", description: "Crispy buttermilk fried chicken served with creamy mashed potatoes and gravy.", price: 15.0 } },
  { name: 'Spice Route', lat: 43.6469223, long: -79.4060226, meal: { name: "Chicken Tikka Masala", description: "Tender chicken cooked in a creamy tomato sauce with Indian spices, served with naan bread.", price: 13.0 } },
  { name: 'Brunch Bites', lat: 43.6415235, long: -79.4221685, meal: { name: "Eggs Benedict", description: "Classic Eggs Benedict with hollandaise sauce, served with a side of hash browns.", price: 20.0 } },
  { name: 'Slice of Heaven', lat: 43.6462755, long: -79.4197233, meal: { name: "Pepperoni Pizza", description: "Hand-tossed pizza with a tangy tomato sauce, mozzarella cheese, and pepperoni slices.", price: 15.0 } },
  { name: 'Ocean Fresh', lat: 43.6457524, long: -79.4104717, meal: { name: "Fish and Chips", description: "Crispy battered fish served with golden fries and tartar sauce.", price: 18.0 } }
]

restaurants = []
restaurant_data.each do |data|
  restaurants << create_restaurant(data[:name], data[:lat], data[:long])
end

puts 'Creating restaurant settings 🍴'

# Restaurant settings data
restaurants.each_with_index do |restaurant, index|
  order_start_time = [10, 12, 14, 16, 18].sample
  order_cutoff_time = order_start_time + 2
  pickup_start_time = order_cutoff_time + 2
  pickup_end_time = pickup_start_time + 1
  create_restaurant_setting(restaurant, order_start_time, order_cutoff_time, pickup_start_time, pickup_end_time, 15)
end

puts 'Creating new users 👩🏽‍💻'

# User data
user_password = "password"

restaurants.each_with_index do |restaurant, i|
  email = "shahynkamali+#{i}@gmail.com"  # Unique email for each user
  create_user("Shahyn", "Kamali", email, user_password, restaurant, true)
end

puts 'Creating meals 🥘'

# Meal data
meals = []
restaurant_data.each_with_index do |data, index|
  meals << create_meal(data[:meal][:name], data[:meal][:description], data[:meal][:price], restaurants[index])
end

puts 'Creating orders 📄'

# Order data
3.times do |i|
  email = "shahynkamali+#{i}@gmail.com"
  user = User.find_by(email: email)
  create_order('cart', 12, 12, 20.0, 15.0, 0, meals[i], user)
  create_order('preparing', 18, 18, 20.0, 15.0, 3.05, meals[i], user, DateTime.now)
  create_order('picked_up', 18, 18, 20.0, 15.0, 3.05, meals[i+2], user, DateTime.now)
end

puts 'Seeding complete 🌱'
