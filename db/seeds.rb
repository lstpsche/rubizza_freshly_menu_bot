require_relative '../lib/dependencies'
require_relative '../models/models'
require_relative '../helpers/common'
require_relative '../workers/csv'

connect_database

puts "\n------------------------------------------------\n\n"
puts 'Cleaning database...'
# puts '>> Deleting Orders'
# Order.destroy_all
# puts '>> Deleting DishIngredient'
# DishIngredient.destroy_all
puts '>> Deleting Dishes'
Dish.destroy_all
puts '>> Deleting UserIngredients'
UserIngredient.destroy_all
puts '>> Deleting Users'
User.destroy_all
puts '>> Deleting Ingredients'
Ingredient.destroy_all
puts 'Done.'

puts "\n------------------------------------------------\n\n"
puts 'Creating default user'
default_user = User.create(id: 1, number: 0, name: 'default', vegetarian: false)
puts 'Done.'

puts "\n------------------------------------------------\n\n"
puts 'Parsing CSV file with dishes'
dishes_table = Csv.parse_file(file_path: "#{ENV['APP_ROOT']}/external_files/dish_ingredients_matrix.csv")[0..200]
puts 'Done.'

puts "\n------------------------------------------------\n\n"
puts 'Getting ingredients'
ingredients = dishes_table[0].to_h.keys[1..-1]
puts 'Done.'

puts "\n------------------------------------------------\n\n"
puts 'Getting dishes numbers'
dishes_numbers = dishes_table.map { |dish| dish['id'].to_i }
puts 'Done.'

puts "\n------------------------------------------------\n\n"
puts 'Creating Ingredients base'
ingredients.each do |ingredient|
  Ingredient.create(name: ingredient)
end
puts 'Done.'

puts "\n------------------------------------------------\n\n"
puts 'Creating Dishes base'
dishes_numbers.each do |dish_number|
  Dish.create(number: dish_number)
end
puts 'Done.'

puts "\n------------------------------------------------\n\n"
puts 'Fulfilling DishIngredient base'
dishes_table.each do |dish|
  dish_model = Dish.find_by(number: dish['id'].to_i)
  dish_ingredients = dish.to_h.select { |_key, val| val.to_i == 1 }.keys

  dish_ingredients.each do |ingredient_name|
    DishIngredient.create(dish: dish_model, ingredient: Ingredient.find_by(name: ingredient_name))
  end
end
puts 'Done.'


puts "\n------------------------------------------------\n\n"
puts 'Creating UserIngredient base'
ingredients.each do |ingredient|
  ing = Ingredient.find_by(name: ingredient)
  UserIngredient.create(user: default_user, ingredient: ing, score: 0)
end
puts 'Done.'

puts "\n------------------------------------------------\n\n"
puts 'Creating Orders base with random ratings'
max_dishes = dishes_numbers.count > 1000 ? 1000 : dishes_numbers.count / 2
rand_dishes_nums = dishes_numbers.shuffle[0..max_dishes]
rand_dishes_nums.each do |dish_num|
  dish = Dish.find_by(number: dish_num)
  order = Order.create(user: default_user, dish: dish, rating: rand(-1..1))
  case order.rating
  when 1
    order.dish.dish_ingredients.each { |dish_ingred| UserIngredient.where(user: default_user, ingredient_id: dish_ingred.ingredient_id).take.increase_score }
    # order.dish.ingredients.each { |ingred| UserIngredient.where(user: default_user, ingredient: ingred).increase_score }
  when -1
    order.dish.dish_ingredients.each { |dish_ingred| UserIngredient.where(user: default_user, ingredient_id: dish_ingred.ingredient_id).take.decrease_score }
    # order.dish.ingredients.each { |ingred| UserIngredient.where(user: default_user, ingredient: ingred).decrease_score }
  end
end
puts 'Done.'
