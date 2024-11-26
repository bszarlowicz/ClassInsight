class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[show]
  before_action :set_teacher, only: %i[show index new create]

  def index
    @search_url = students_path
    @title = Student.model_name.human(count: 2)

    @search = @teacher.students.ransack(params[:q])
    @students = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def show
    @events = @student.lessons.where(teacher_id: @teacher.id)
  end

  def new
    @student = Student.new
  end

  def create
    @search_url = students_path
    @title = Student.model_name.human(count: 2)
  
    @students = @teacher.students
    @search = @students.ransack(params[:q])
  
    @student = find_or_initialize_student(params[:student])
  
    respond_to do |format|
      if @student.persisted?
        @teacher.students << @student
        flash[:notice] = flash_message(:create, User)
        format.turbo_stream
        flash.discard
      else
        if @student.save
          @teacher.students << @student
          send_temporary_password_email(@student)
          flash[:notice] = flash_message(:create, User)
          format.turbo_stream
          flash.discard
        else
          format.html { render :new, status: :unprocessable_entity }
        end
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

    def find_or_initialize_student(params)
      email = params[:email]
      search_for_existing_student(email) || build_new_student
    end
    
    def search_for_existing_student(email)
      Student.find_by(email: email)
    end
    
    def build_new_student
      student = Student.new(student_params)
      password = generate_random_password(12)
      student.password = password
      student.password_confirmation = password
      student
    end
    
    def send_temporary_password_email(student)
      UserMailer.temporary_password(student, student.password).deliver_now
    end
end