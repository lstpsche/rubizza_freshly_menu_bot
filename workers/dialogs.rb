require_relative '../lib/dependencies'
require_relative '../dialogs/common'
require_relative '../dialogs/registration'
require_relative '../dialogs/main_dialog'

class Dialogs
  attr_reader :bot

  def initialize(bot:)
    @bot = bot
  end

  def help_dialog(chat_id:, help:)
    case help
    when 1
      # common
      show_help_1(bot: bot, chat_id: chat_id)
    when 2
      show_help_2(bot: bot, chat_id: chat_id)
    end
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

  def coming_soon(chat_id:)
    show_coming_soon_msg(bot: bot, chat_id: chat_id)
  end

  def main_dialog(chat_id:, user_id:)
    MainDialog.new(bot: bot, chat_id: chat_id, user_id: user_id).start
  end

  def order_confirmed(chat_id:, dish_num:)
    show_order_confirmed_message(bot: bot, chat_id: chat_id, dish_num: dish_num)
  end
end
