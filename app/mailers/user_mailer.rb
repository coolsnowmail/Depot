class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_order_alerm.subject
  #
  def new_order_alerm(order)
    @order = order

    mail(to: ENV['gmail_username'], subject: "there is a new order")
  end
end
