class SchedulesController < ApplicationController
  before_action :set_user
  before_action :set_week_days, only: %i[ index ]

  def index
    @lessons = @user.lessons
    @form_class = "modal-form"
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_week_days
      @week_days = ["PON", "WTO", "ŚRO", "CZW", "PIĄ", "SOB", "NIE"]
    end
end
