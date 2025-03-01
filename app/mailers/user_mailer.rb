class UserMailer < ApplicationMailer
  default from: 'no-reply@mentora-app.pl'

  def temporary_password(user, temp_password)
    @user = user
    @temporary_password = temp_password
    mail(to: @user.email, subject: 'Witaj w naszym serwisie!')
  end
end
