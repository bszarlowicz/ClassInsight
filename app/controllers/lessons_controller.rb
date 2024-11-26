class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: %i[ show edit update destroy ]
  before_action :set_week_days, only: %i[ index new edit update create ]
  before_action :set_lesson_hour, only: %i[ new edit ]
  before_action :set_user

  # GET /lessons or /lessons.json
  def index
    @search_url = user_lessons_path
    @search = @user.lessons.ransack(params[:q])
    @lessons = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  # GET /lessons/1 or /lessons/1.json
  def show
    @student = @lesson.student
  end

  
  # GET /lessons/new
  def new
    @lesson = @user.lessons.new
  end

  # GET /lessons/1/edit
  def edit
    @selected_hour = @lesson.hour.present? ? @lesson.hour.strftime("%H:%M") : ""
  end

  # POST /lessons or /lessons.json
  def create
    @lesson = @user.lessons.new(lesson_params)
    @search_url = user_lessons_path
    @search = @user.lessons.ransack(params[:q])
    respond_to do |format|
      if @lesson.save
        @lessons = @user.lessons
        @lessons_to_json = @user.lessons.map do |lesson|
          student = Student.find(lesson.student_id)
          lesson.attributes.merge(student_name: student.name)
        end
        flash[:notice] = flash_message(:create, Lesson)
        format.turbo_stream
        format.json { render :show, status: :created, location: @lesson }
        flash.discard
      else
        format.html { render :new, status: :unprocessable_entity  }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    @search_url = user_lessons_path
    @search = @user.lessons.ransack(params[:q])
    respond_to do |format|
      if @lesson.update(lesson_params)
        @lessons = @user.lessons
        flash[:notice] = flash_message(:update, Lesson)
        format.turbo_stream
        format.json { render :show, status: :ok, location: @lesson }
        flash.discard
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    @lesson.destroy!
    respond_to do |format|
      flash[:notice] = flash_message(:destroy, Lesson)
      format.html { redirect_to user_lessons_path(@user) }
      format.json { head :no_content }
      flash.discard
    end
  end

  private
    def set_lesson_hour
      @lesson_hour = @lesson&.hour.present? ? @lesson.hour.strftime("%H:%M") : nil
    end
    
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_week_days
      @week_days = ["PON", "WTO", "ŚRO", "CZW", "PIĄ", "SOB", "NIE"]
    end

    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lesson_params
      params.require(:lesson).permit(:hour, :year, :color, :duration, :student_id, days_of_week: [])
    end
end
