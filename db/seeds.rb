puts 'Destroying current DB 🔥'

User.destroy_all
Restaurant.destroy_all

puts 'Creating new restaurants 🍽'

restaurant_keg = Restaurant.create!(
  name: 'The Keg',
  address_line_1: '91 Bayview Ave',
  city: 'Toronto',
  province: 'ON',
  postal_code: 'M2K 1E6',
  country: 'canada',
  latitude: 43.6436784, 
  longitude: -79.39456179999999
)

restaurant_osteria = Restaurant.create!(
  name: 'Osteria Il Mulino',
  address_line_1: '91 Bayview Ave',
  city: 'Toronto',
  province: 'ON',
  postal_code: 'M2K 1E6',
  country: 'canada',
  latitude: 43.6559027, 
  longitude: -79.38109589999999
)

restaurant_pizzaiolo = Restaurant.create!(
  name: 'Pizzaiolo',
  address_line_1: '91 Bayview Ave',
  city: 'Toronto',
  province: 'ON',
  postal_code: 'M2K 1E6',
  country: 'canada',
  latitude:  43.6482349, 
  longitude: -79.38169429999999
)

restaurant_bangkok = Restaurant.create!(
  name: 'Bangkok Garden',
  address_line_1: '91 Bayview Ave',
  city: 'Toronto',
  province: 'ON',
  postal_code: 'M2K 1E6',
  country: 'canada',
  latitude:  43.6472019, 
  longitude: -79.3953394
)

restaurant_masala = Restaurant.create!(
  name: 'Masala Hut',
  address_line_1: '91 Bayview Ave',
  city: 'Toronto',
  province: 'ON',
  postal_code: 'M2K 1E6',
  country: 'canada',
  latitude: 43.6436784, 
  longitude: -79.39456179999999 
)

RestaurantSetting.create!(
  order_start_time: DateTime.new(2000, 01, 01, 9, 00, 0),
  order_cutoff_time: DateTime.new(2000, 01, 01, 16, 00, 0),
  pickup_start_time: DateTime.new(2000, 01, 01, 18, 00, 0),
  pickup_end_time: DateTime.new(2000, 01, 01, 20, 00, 0),
  quantity_available: 15,
  restaurant: restaurant_keg
)

RestaurantSetting.create!(
  order_start_time: DateTime.new(2000, 01, 01, 11, 00, 0),
  order_cutoff_time: DateTime.new(2000, 01, 01, 16, 00, 0),
  pickup_start_time: DateTime.new(2000, 01, 01, 19, 00, 0),
  pickup_end_time: DateTime.new(2000, 01, 01, 21, 00, 0),
  quantity_available: 10,
  restaurant: restaurant_osteria
)

RestaurantSetting.create!(
  order_start_time: DateTime.new(2000, 01, 01, 11, 00, 0),
  order_cutoff_time: DateTime.new(2000, 01, 01, 16, 00, 0),
  pickup_start_time: DateTime.new(2000, 01, 01, 19, 00, 0),
  pickup_end_time: DateTime.new(2000, 01, 01, 21, 00, 0),
  quantity_available: 15,
  restaurant: restaurant_pizzaiolo
)

RestaurantSetting.create!(
  order_start_time: DateTime.new(2000, 01, 01, 11, 00, 0),
  order_cutoff_time: DateTime.new(2000, 01, 01, 15, 00, 0),
  pickup_start_time: DateTime.new(2000, 01, 01, 17, 00, 0),
  pickup_end_time: DateTime.new(2000, 01, 01, 21, 00, 0),
  quantity_available: 4,
  restaurant: restaurant_bangkok
)

RestaurantSetting.create!(
  order_start_time: DateTime.new(2000, 01, 01, 11, 00, 0),
  order_cutoff_time: DateTime.new(2000, 01, 01, 15, 00, 0),
  pickup_start_time: DateTime.new(2000, 01, 01, 17, 00, 0),
  pickup_end_time: DateTime.new(2000, 01, 01, 21, 00, 0),
  quantity_available: 8,
  restaurant: restaurant_masala
)

puts 'Creating new users 👩🏽‍💻'

kristine_owner = User.create!(
  first_name: "Kristine",
  last_name: "McBride",
  email: "kristinelmcbride@gmail.com",
  password: "password",
  restaurant: restaurant_keg,
  is_store_owner: true
)

User.create!(
  first_name: "Shahyn",
  last_name: "Kamali",
  email: "shahynkamali@gmail.com",
  password: "password",
  restaurant: restaurant_keg
)

kristine_owner_osteria = User.create!(
  first_name: "Kristine",
  last_name: "McBride",
  email: "kristinelmcbride+osteria@gmail.com",
  password: "password",
  restaurant: restaurant_osteria,
  is_store_owner: true
)

User.create!(
  first_name: "Shahyn",
  last_name: "Kamali",
  email: "shahynkamali+osteria@gmail.com",
  password: "password",
  restaurant: restaurant_osteria
)

kristine_owner_pizzaiolo = User.create!(
  first_name: "Kristine",
  last_name: "McBride",
  email: "kristinelmcbride+pizzaiolo@gmail.com",
  password: "password",
  restaurant: restaurant_pizzaiolo,
  is_store_owner: true
)

kristine_owner_bangkok = User.create!(
  first_name: "Kristine",
  last_name: "McBride",
  email: "kristinelmcbride+bangkok@gmail.com",
  password: "password",
  restaurant: restaurant_bangkok,
  is_store_owner: true
)

kristine_owner_masala = User.create!(
  first_name: "Kristine",
  last_name: "McBride",
  email: "kristinelmcbride+masala@gmail.com",
  password: "password",
  restaurant: restaurant_masala,
  is_store_owner: true
)


monty_the_guest = User.create!(
  first_name: "Monty",
  last_name: "McBride",
  email: "kristinelmcbride+monty@gmail.com",
  password: "password"
)

puts 'Creating meals 🥘'

chicken_alfredo = Meal.create!(
  name: "Chicken Alfredo",
  description: "A classic dish of fettuccine pasta tossed in a creamy Alfredo sauce with grilled chicken.",
  active: true,
  price: 15.0,
  restaurant: restaurant_keg
)

steak_potatoes = Meal.create!(
  name: "Steak and Potatoes",
  description: "A juicy steak grilled to perfection and served with your choice of mashed potatoes, french fries, or vegetables.",
  active: true,
  price: 20.0,
  restaurant: restaurant_osteria
)

pasta = Meal.create!(
  name: "Pasta Carbonara",
  description: "A hearty dish of spaghetti tossed in a creamy sauce made with bacon, eggs, and Parmesan cheese.",
  active: true,
  price: 15.0,
  restaurant: restaurant_osteria
)

pad_thai = Meal.create!(
  name: "Pad Thai",
  description: "A stir-fried noodle dish made with rice noodles, chicken, shrimp, eggs, and vegetables in a sweet and savory sauce.",
  active: true,
  price: 15.0,
  restaurant: restaurant_bangkok
)

chicken_tikka = Meal.create!(
  name: "Chicken Tikka Masala",
  description: "A creamy curry dish made with chicken, tomatoes, and spices.",
  active: true,
  price: 15.0,
  restaurant: restaurant_bangkok
)

puts 'Creating order 📄'

Order.create!(
  status: 'preparing',
  pickup_start_time: DateTime.new(2000, 01, 01, 18, 00, 0),
  pickup_end_time: DateTime.new(2000, 01, 01, 18, 15, 0),
  total: 20.0,
  subtotal: 15.0,
  tip_amount: 3.05,
  meal: chicken_alfredo,
  user: monty_the_guest
)

Order.create!(
  status: 'picked_up',
  pickup_start_time: DateTime.new(2000, 01, 01, 18, 00, 0),
  pickup_end_time: DateTime.new(2000, 01, 01, 18, 15, 0),
  total: 20.0,
  subtotal: 15.0,
  tip_amount: 3.05,
  meal: pasta,
  user: monty_the_guest
)
