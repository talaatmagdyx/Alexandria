class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirmation_email.subject
  #
  def confirmation_email(user)
    @user = user
    @user.update_column(:confirmation_sent_at, Time.now)
    mail to: @user.email, subject: 'Confirm your Account!'
  end

  def reset_password(user)
    @user = user
    @user.update_column(:confirmation_sent_at, Time.now)
    mail to: @user.email, subject: 'Reset your password'
  end
end
