require_relative '../lib/dependencies'
require_relative '../models/models'
require_relative '../helpers/common'
require_relative '../workers/csv'

connect_database

puts "\n------------------------------------------------\n\n"
puts 'Cleaning database...'
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
dishes_table = Csv.parse_file(file_path: "#{ENV['APP_ROOT']}/external_files/dish_ingredients_matrix.csv")
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
puts 'Creating UserIngredient base'
ingredients.each do |ingredient|
  ing = Ingredient.find_by(name: ingredient)
  UserIngredient.create(user: default_user, ingredient: ing, score: 0)
end
puts 'Done.'

puts "\n------------------------------------------------\n\n"
puts 'Randomly updating UserIngredients score (for default_user)'
max_ingrs = ingredients.count > 1000 ? 1000 : ingredients.count / 2
random_ingredients = ingredients.shuffle[0..max_ingrs]
random_ingredients.each do |ingredient|
  ing = Ingredient.find_by(name: ingredient)
  UserIngredient.find_by(user: default_user, ingredient: ing).update(score: rand(-15..15))
end
puts 'Done.'
