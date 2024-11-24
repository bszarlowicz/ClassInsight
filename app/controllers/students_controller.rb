class StudentsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_student, only: %i[show edit update destroy]
  before_action :set_teacher, only: %i[index new create]

  def index
    @search_url = students_path
    @title = Student.model_name.human(count: 2)

    @search = @teacher.students.ransack(params[:q])
    @students = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def new
    @student = Student.new
  end

  def create
    @search_url = students_path
    @title = Student.model_name.human(count: 2)

    @students = @teacher.students
    @search = @students.ransack(params[:q])

    @student = Student.new(student_params)
    password = generate_random_password(12)
    @student.password = password
    @student.password_confirmation = password

    respond_to do |format|
      if @student.save
        @teacher.students << @student
        UserMailer.temporary_password(@student, password).deliver_now
        flash[:notice] = flash_message(:create, User)
        format.turbo_stream
        flash.discard
      else
        format.html { redirect_to new_user_path, status: :unprocessable_entity}
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def set_teacher
      @teacher = current_user
    end

    def student_params
      params.require(:student).permit(User.permitted_params)
    end
end