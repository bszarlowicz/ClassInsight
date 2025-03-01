class DeviseMailer < Devise::Mailer
  default from: 'no-reply@mentora-app.pl'
  layout 'mailer'
end
