class User < ActiveRecord::Base
  validates :number, presence: true, uniqueness: true
  validates :vegetarian, inclusion: { in: [true, false] }
  validates :name, presence: true

  has_many :user_ingredients
end
