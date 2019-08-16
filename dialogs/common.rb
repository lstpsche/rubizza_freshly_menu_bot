require_relative '../lib/dependencies'
require_relative '../lib/messages'

def show_help(bot:, chat_id:)
  bot.api.send_message(chat_id: chat_id, text: HELP_MESSAGE)
end

def show_invalid_command_msg(bot:, chat_id:)
  bot.api.send_message(chat_id: chat_id, text: INVALID_COMMAND_MESSAGE)
end
