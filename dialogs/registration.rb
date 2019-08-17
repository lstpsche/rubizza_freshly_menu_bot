require_relative '../lib/dependencies'
require_relative '../workers/database'
require_relative '../helpers/registration_helper.rb'
require_relative '../models/models'

class Registration
  attr_reader :bot, :chat_id, :user_id, :user_name, :db, :helper

  def initialize(bot:, chat_id:, user_id:, user_name:)
    @bot = bot
    @chat_id = chat_id
    @user_id = user_id
    @user_name = user_name
    @db = Database.new
    @helper = RegistrationHelper.new(bot: bot, chat_id: chat_id, user_id: user_id)
  end

  def register
    user = db.build_user(number: user_id, name: user_name)
    # update here all needed preferences
    user.update(vegetarian: vegeterian_preference)

    if user.save
      helper.send_success_preferences_setup(chat_id: chat_id)
    end
  end

  private

  def vegeterian_preference
    loop do
      helper.send_vegetarian_preference_msg
      vegeterian_preference = helper.listen_vegetarian_preference
      return vegeterian_preference if [true, false].include? vegeterian_preference
    end
  end
end
