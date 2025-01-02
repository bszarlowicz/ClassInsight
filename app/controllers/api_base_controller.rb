class ApiBaseController < ActionController::Metal
  include AbstractController::Rendering
  include ActionView::Layouts
  include ActionController::Rendering
  include ActionController::Renderers::All
  include ActionController::MimeResponds
  include ActionController::RequestForgeryProtection
  include ActionController::Rescue

  append_view_path "#{Rails.root}/app/views/api/v1/"

  protect_from_forgery with: :null_session
  after_action :set_content_type
  before_action :set_default_response_format

  rescue_from Exception, RuntimeError do |exception|
    render json: { exception: exception }, status: 500
  end

  rescue_from ActionController::RoutingError, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound do |exception|
    render json: { exception: exception }, status: 404
  end


  def set_content_type
    self.content_type = "application/json; charset=utf-8"
  end

  def logger
    Rails.logger
  end

  def optional_authenticate_request
    header = request.headers["Authorization"]
    if header.present?
      begin
        header = header.split(" ").last if header
        decoded = jwt_decode(header)
        @current_user = User.find_by(token: decoded[:user_id]) if decoded && decoded[:user_id]
      rescue
        @current_user = nil
      end
    end
    true
  end

  private

  def authenticate_request
    begin
      header = request.headers["Authorization"]
      header = header.split(" ").last if header
      decoded = jwt_decode(header)
      @current_user = User.find_by(token: decoded[:user_id])

      render(json: {message: "Not existing user"}, status: :unauthorized) if @current_user.nil?
    rescue Exception=>e
      render(json: {message: "Unauthorized"}, status: :unauthorized)
    end
  end

  def set_default_response_format
    request.format = :json
  end

  def use_https?
    true
  end

  def turn_off_the_app
    respond_to do |format|
      format.json {render json: 'Bad credentials', status: 401}
    end
  end
end