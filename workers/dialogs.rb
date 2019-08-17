require_relative '../lib/dependencies'
require_relative '../dialogs/common'
require_relative '../dialogs/registration'

class Dialogs
  attr_reader :bot

  def initialize(bot:)
    @bot = bot
  end

  def help_dialog(chat_id:)
    # common
    show_help(bot: bot, chat_id: chat_id)
  end

  def invalid_message(chat_id:)
    # common
    show_invalid_command_msg(bot: bot, chat_id: chat_id)
  end

  def registration(chat_id:, user_id:, user_name:)
    if User.find_by(number: user_id)
      old_welcome_dialog(chat_id: chat_id, user_name: user_name)
    else
      new_welcome_dialog(chat_id: chat_id, user_name: user_name)
      Registration.new(bot: bot, chat_id: chat_id, user_id: user_id, user_name: user_name).register
    end
  end

  def old_welcome_dialog(chat_id:, user_name:)
    # common
    show_old_welcome_msg(bot: bot, chat_id: chat_id, user_name: user_name)
  end

  def new_welcome_dialog(chat_id:, user_name:)
    # common
    show_new_welcome_msg(bot: bot, chat_id: chat_id, user_name: user_name)
  end
end
