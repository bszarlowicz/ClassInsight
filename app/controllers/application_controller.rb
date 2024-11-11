class ApplicationController < ActionController::Base
  helper_method :show_left_menu?

  def flash_message(action, model)
    I18n.t(".notices.#{action}.success", model: model.model_name.human)
  end
  
  def show_left_menu?
    !(devise_controller? && (controller_name == "sessions" || controller_name == "registrations" || controller_name == "passwords"))
  end
end
