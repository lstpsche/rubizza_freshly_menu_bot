require_relative 'lib/dependencies'
require_relative 'workers/dialogs'

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
        case message.text
        when '/start'
          # calls registration dialog
          # dialogs.registration
          bot.api.send_message(chat_id: message.chat.id, text: 'чё каво')
        when '/help'
          dialogs.help_dialog(chat_id: message.chat.id)
        else
          dialogs.invalid_message(chat_id: message.chat.id)
        end
      end
    end
  end
end

App.new(token: token).run
