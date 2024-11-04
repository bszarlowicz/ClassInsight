class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: %i[ show edit update destroy ]
  before_action :set_user

  # GET /lessons or /lessons.json
  def index
    @search_url = user_lessons_path
    @search = @user.lessons.ransack(params[:q])
    @lessons = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  # GET /lessons/1 or /lessons/1.json
  def show
  end

  # GET /lessons/new
  def new
    @lesson = @user.lessons.new
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons or /lessons.json
  def create
    @lesson = @user.lessons.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to user_lesson_path(@user, @lesson), notice: "Lesson was successfully created." }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to user_lesson_path(@user, @lesson), notice: "Lesson was successfully updated." }
        format.json { render :show, status: :ok, location: @lesson }
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
      format.html { redirect_to user_lessons_path(@user), notice: "Lesson was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lesson_params
      params.require(:lesson).permit(:daysOfWeek, :hour, :year)
    end
end
