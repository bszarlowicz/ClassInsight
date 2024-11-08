class SchedulesController < ApplicationController
  before_action :set_user

  def index
    @lessons = @user.lessons
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end
end
