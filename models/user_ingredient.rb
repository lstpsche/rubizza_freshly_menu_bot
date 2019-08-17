class UserIngredient < ActiveRecord::Base
  validates :score, presence: true

  belongs_to :user
  belongs_to :ingredient

  def increase_score
    update(score: score + 1)
  end

  def decrease_score
    update(score: score - 1)
  end
end
