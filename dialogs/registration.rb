require_relative '../lib/dependencies'
require_relative '../workers/database'

class Registration
  attr_reader :bot, :chat_id, :user_id, :db

  def initialize(bot:, chat_id:, user_id:)
    @bot = bot
    @chat_id = chat_id
    @user_id = user_id
    @db = Database.new.record_to_db
  end

  def register

  end

  def show_preferences

  end
end
