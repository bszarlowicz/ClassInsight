class Api::V1::UsersController < ApiBaseController
  def show
    @user = User.find(params[:id])

    if @user
      render 'users/show'
    else
      render json: @current_user.errors, status: :bad_request
    end

  end
end
