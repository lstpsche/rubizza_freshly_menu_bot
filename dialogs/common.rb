require_relative '../lib/dependencies'
require_relative '../lib/messages'

def show_help(bot:, chat_id:)
  bot.api.send_message(chat_id: chat_id, text: HELP_MESSAGE)
end

def show_invalid_command_msg(bot:, chat_id:)
  bot.api.send_message(chat_id: chat_id, text: INVALID_COMMAND_MESSAGE)
end

def show_old_welcome_msg(bot:, chat_id:, user_name:)
  msg_text = OLD_WELCOME_MSG % { user_name: user_name }

  bot.api.send_message(chat_id: chat_id, text: msg_text)
end

def show_new_welcome_msg(bot:, chat_id:, user_name:)
  msg_text = NEW_WELCOME_MSG % { user_name: user_name }

  bot.api.send_message(chat_id: chat_id, text: msg_text)
end
