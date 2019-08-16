class User < ActiveRecord::Base
  validates :number, presence: true, uniqueness: true

  has_many :user_ingredients
end
