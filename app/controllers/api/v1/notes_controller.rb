class Api::V1::NotesController < ApiBaseController

  protect_from_forgery with: :null_session
  
  def create
    @user = User.find(params[:user_id])

    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    @note = @user.notes.new(params[:note])

    if @note.save
      render json: @note, status: :created
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
