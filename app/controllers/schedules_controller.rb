class SchedulesController < ApplicationController

  def index
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
