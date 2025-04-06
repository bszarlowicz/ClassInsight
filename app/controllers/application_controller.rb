class ApplicationController < ActionController::Base
  helper_method :show_left_menu?
  helper_method :generate_random_password
  helper_method :user_table_title

  def flash_message(action, model)
    I18n.t(".notices.#{action}.success", model: model.model_name.human)
  end
  
  def show_left_menu?
    !(devise_controller? && (controller_name == "sessions" || controller_name == "registrations" || controller_name == "passwords") || controller_name == "landing")
  end

  def generate_random_password(length = 12)
    password = SecureRandom.base64(length)
    password += ('0'..'9').to_a.sample unless password.match(/\d/)
    password += ('A'..'Z').to_a.sample unless password.match(/[A-Z]/)
    password += ['!', '@', '#', '$', '%', '&', '*', '_'].sample unless password.match(/[\W_]/)
    password
  end 

  def user_table_title(user)
    case user
    when Teacher
      t(:students)
    when Student
      t(:teachers)
    when ->(u) { u.is?("admin") }
      User.model_name.human(count: 2)
    end
  end
end
