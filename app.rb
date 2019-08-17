require_relative 'lib/dependencies'
require_relative 'workers/dialogs'
require_relative 'helpers/common'

token = ENV['BOT_TOKEN']

class App
  attr_reader :token, :dialogs

  def initialize(token:)
    @token = token
  end

  def run
    Telegram::Bot::Client.run(token) do |bot|
      @dialogs = Dialogs.new(bot: bot)

      bot.listen do |message|
        case message
        when Telegram::Bot::Types::Message
          case message.text
          when '/start'
            dialogs.registration(chat_id: message.chat.id, user_id: message.from.id, user_name: message.from.first_name)
            dialogs.main_dialog(chat_id: message.chat.id, user_id: message.from.id)
          when '/help'
            dialogs.help_dialog(chat_id: message.chat.id, help: 1)
          else
            dialogs.invalid_message(chat_id: message.chat.id)
            dialogs.help_dialog(chat_id: message.chat.id, help: 1)
          end
        end
      end
    end
  end
end

connect_database
App.new(token: token).run
