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

    bot.api.send_message(chat_id: chat_id, text: MAIN_MENU_TEXT, reply_markup: markup)
  end

  def listen
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::CallbackQuery
        case message.data
        # FULL MENU ---------------------------
        when 'full_menu'
          dialogs.coming_soon(chat_id: chat_id)
        # RECOMENDED MENU ---------------------
        when 'recomended_menu'
          recomended_menu
        # ORDERS ------------------------------
        when 'orders'
          callback = user_orders
          return if callback == 'no_orders'
        # BACK --------------------------------
        when 'back'
          return
        else
          # ORDERED DISH ----------------------
          if /dish_\d+/.match? message.data
            dish_num = message.data.split('_')[1].to_i
            User.find_by(number: user_id).add_order(dish_num: dish_num)
            send_confirmed_order(dish_num: dish_num)
          elsif /^order_\d+$/.match? message.data
            order = Order.find(message.data.split('_')[1].to_i)
            callback = rate_order(order: order)
          elsif /^order_\d+_like$/.match? message.data
            order = Order.find(message.data.split('_')[1].to_i)
            order.like(user_num: user_id)
            dialogs.order_liked(chat_id: chat_id, order_id: order.id)
            return
          elsif /^order_\d+_dislike$/.match? message.data
            order = Order.find(message.data.split('_')[1].to_i)
            order.dislike(user_num: user_id)
            dialogs.order_disliked(chat_id: chat_id, order_id: order.id)
            return
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

  def rate_order(order:)
    text = "Order ##{order.id} -- Dish ##{order.dish.number} -- #{order.rating > 0 ? 'Liked' : (order.rating < 0 ? 'Disliked' : 'No rating') }"
    keyboard = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: LIKE, callback_data: "order_#{order.id}_like"),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: DISLIKE, callback_data: "order_#{order.id}_dislike"),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '<---  Back', callback_data: 'back')
    ]

    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
    bot.api.send_message(chat_id: chat_id, text: text, reply_markup: markup)
  end

  def user_orders
    user = User.find_by(number: user_id)
    if user.orders.empty?
      dialogs.no_orders_msg(chat_id: chat_id)
      return 'no_orders'
    else
      text = ALL_ORDERS
      orders = user.orders
      orders_menu(text: text, orders: orders)
    end
  end

  def orders_menu(text:, orders:)
    orders_buttons = []
    orders.sort_by(&:id).each do |order|
      text = "Order ##{order.id} -- Dish ##{order.dish.number} -- #{order.rating > 0 ? 'Liked' : (order.rating < 0 ? 'Disliked' : 'No rating') }"

      orders_buttons << Telegram::Bot::Types::InlineKeyboardButton.new(text: text, callback_data: "order_#{order.id}")
    end
    orders_buttons << Telegram::Bot::Types::InlineKeyboardButton.new(text: '<---  Back', callback_data: 'back')

    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: orders_buttons)
    bot.api.send_message(chat_id: chat_id, text: ALL_ORDERS + "\n\n" + CLICK_TO_RATE, reply_markup: markup)
  end

  def send_confirmed_order(dish_num:)
    dialogs.order_confirmed(chat_id: chat_id, dish_num: dish_num)
  end

  def recomended_menu
    dishes_buttons = []
    menu = get_recomended_menu_for_user
    menu.each.with_index do |entry, index|
      name = menu[index][0].name
      name = "Dish ##{menu[index][0].number}" if name.empty?

      dishes_buttons << Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{index+1}. #{name} -- Rating: #{menu[index][1]}", callback_data: "dish_#{menu[index][0].number}")
    end
    dishes_buttons << Telegram::Bot::Types::InlineKeyboardButton.new(text: '<---  Back', callback_data: 'back')

    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: dishes_buttons)
    bot.api.send_message(chat_id: chat_id, text: RECOMENDED_MENU + "\n\n" + CLICK_TO_ORDER, reply_markup: markup)
  end

  # returns array of Dish elements with ratings [[dish, rating], [.., ..], ....]
  def get_recomended_menu_for_user
    user = User.find_by(number: user_id)
    if user.orders.pluck(:rating).select{ |rating| rating != 0 }.empty?
      User.find(1).recomended_menu[0...10]
    else
      user.recomended_menu[0...10]
    end
  end
end
