require_relative '../lib/dependencies'
require_relative '../dialogs/common'
require_relative '../dialogs/registration'

class Dialogs
  attr_reader :bot

  def initialize(bot:)
    @bot = bot
  end

  def help_dialog(chat_id:)
    show_help(bot: bot, chat_id: chat_id)
  end

  def invalid_message(chat_id:)
    show_invalid_command_msg(bot: bot, chat_id: chat_id)
  end

  def registration(chat_id:, user_id:)
    Registration.new(bot: bot, chat_id: chat_id, user_id: user_id).register
  end
end
