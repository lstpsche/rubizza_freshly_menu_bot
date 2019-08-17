require_relative '../lib/dependencies'
require_relative '../lib/messages'
require_relative '../workers/dialogs'

class MainDialogHelper
  attr_reader :bot, :chat_id, :user_id, :dialogs

  def initialize(bot:, chat_id:, user_id:)
    @bot = bot
    @chat_id = chat_id
    @user_id = user_id
    @dialogs = Dialogs.new(bot: bot)
  end

  def show_keyboard
    keyboard = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Full menu', callback_data: 'full_menu'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Recomended menu', callback_data: 'recomended_menu'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'My orders', callback_data: 'orders')
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)

    bot.api.send_message(chat_id: chat_id, text: 'Welcome to Freshly!', reply_markup: markup)
  end

  def listen
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::CallbackQuery
        case message.data
        when 'full_menu'
          dialogs.coming_soon(chat_id: chat_id)
        when 'recomended_menu'
          recomended_menu
        when 'orders'
        else
          if /\d+/.match message.data
            dish_num = message.data.to_i
            User.find_by(number: user_id).add_order(dish_num: dish_num)
            send_confirmed_order(dish_num: dish_num)
          end
        end
      when Telegram::Bot::Types::Message
        case message.text
        when '/help'
          dialogs.help_dialog(chat_id: chat_id, help: 2)
        else
        end
      end
    end
  end

  private

  def send_confirmed_order(dish_num:)
    dialogs.order_confirmed(chat_id: chat_id, dish_num: dish_num)
  end

  def recomended_menu
    dishes_buttons = []
    menu = get_recomended_menu_for_user
    menu.each.with_index do |entry, index|
      name = menu[index][0].name
      name = "Dish ##{menu[index][0].number}" if name.empty?

      dishes_buttons << Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{index+1}. #{name} -- Rating: #{menu[index][1]}", callback_data: "#{menu[index][0].number}")
    end

    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: dishes_buttons)
    bot.api.send_message(chat_id: chat_id, text: RECOMENDED_MENU + "\n\n" + CLICK_TO_ORDER, reply_markup: markup)
  end

  # returns array of Dish elements with ratings [[dish, rating], [.., ..], ....]
  def get_recomended_menu_for_user
    user = User.find_by(number: user_id)
    if user.orders.pluck(:rating).empty?
      User.find(1).recomended_menu[0...10]
    else
      user.recomended_menu[0...10]
    end
  end
end
