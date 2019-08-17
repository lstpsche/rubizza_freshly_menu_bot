require_relative '../lib/dependencies'
require_relative '../models/models'
require_relative '../helpers/common'

connect_database

Dish.destroy_all
UserIngredient.destroy_all
User.destroy_all
Ingredient.destroy_all

default_user = User.create(id: 1, number: 0, name: 'default', vegetarian: false)
