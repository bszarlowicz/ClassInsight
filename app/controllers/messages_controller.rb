class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, only: %i[ create ]

  def create
    if params[:message][:body].present?
      @message = current_user.messages.build(message_params)
      @message.conversation_id = params[:conversation_id]
      @message.save
    end
  end

  private

  def set_current_user
    @user = current_user
  end

  def message_params
    params.require(:message).permit(:body)
  end

end