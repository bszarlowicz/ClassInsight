class ApplicationController < ActionController::Base
  helper_method :show_left_menu?

  def show_left_menu?
    !(devise_controller? && (controller_name == "sessions" || controller_name == "registrations" || controller_name == "passwords"))
  end
end
