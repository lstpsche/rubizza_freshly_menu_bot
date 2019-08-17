require_relative '../lib/dependencies'
require_relative '../models/models'

class Database
  def initialize
  end

  def build_user(params)
    User.new(params)
  end

  def create_user(params)
    User.create(params)
  end

  def find_user(params)
    User.find_by(params)
  end
end
