require_relative '../lib/dependencies'
require_relative '../lib/messages'
require_relative '../workers/dialogs'

class RegistrationHelper
  attr_reader :bot, :chat_id, :user_id, :dialogs

  def initialize(bot:, chat_id:, user_id:)
    @bot = bot
    @chat_id = chat_id
    @user_id = user_id
    @dialogs = Dialogs.new(bot: bot)
  end

  def send_vegetarian_preference_msg
    keyboard = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: [[YES_MSG, NO_MSG], []], remove_keyboard: true, one_time_keyboard: true
    )

    bot.api.send_message(chat_id: chat_id, text: VEGETARIAN_QUESTION, reply_markup: keyboard)
  end

  def listen_vegetarian_preference
    bot.listen do |message|
      case message.text.downcase
      when 'yes'
        return true
      when 'no'
        return false
      else
        dialogs.invalid_message(chat_id: message.chat.id)
        return 'invalid'
      end
    end
  end

  def send_success_preferences_setup(chat_id:)
    markup = Telegram::Bot::Types::ReplyKeyboardRemove.new(
      remove_keyboard: true
    )
    dialogs.success_preferences_setup(chat_id: chat_id, markup: markup)
  end
end
