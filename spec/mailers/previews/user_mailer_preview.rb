# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/new_order_alerm
  def new_order_alerm
    UserMailer.new_order_alerm
  end

end
