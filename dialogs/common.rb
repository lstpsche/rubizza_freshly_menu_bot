require_relative '../lib/dependencies'
require_relative '../lib/messages'

def show_help_1(bot:, chat_id:)
  bot.api.send_message(chat_id: chat_id, text: HELP_MESSAGE_1)
end

def show_help_2(bot:, chat_id:)
  bot.api.send_message(chat_id: chat_id, text: HELP_MESSAGE_2)
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

def show_coming_soon_msg(bot:, chat_id:)
  bot.api.send_message(chat_id: chat_id, text: COMING_SOON)
end

def show_order_confirmed_message(bot:, chat_id:, dish_num:)
  bot.api.send_message(chat_id: chat_id, text: ORDER_CONFIRMED % {dish_num: dish_num})
end
