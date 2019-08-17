require_relative '../lib/dependencies'
require_relative '../dialogs/common'
require_relative '../helpers/main_dialog_helper'

class MainDialog
  attr_reader :bot, :chat_id, :user_id, :helper

  def initialize(bot:, chat_id:, user_id:)
    @bot = bot
    @chat_id = chat_id
    @user_id = user_id
    @helper = MainDialogHelper.new(bot: bot, chat_id: chat_id, user_id: user_id)
  end

  def start
    helper.show_keyboard
    helper.listen
  end
end
