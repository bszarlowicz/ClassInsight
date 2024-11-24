class TeachersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_teacher

  def create_student
    @title = user_table_title(current_user)
    @search_url = users_path
    @users = @teacher.students
    @search = @teacher.students.ransack(params[:q])
    @search.result(distinct: true).order(created_at: :desc).page(params[:page])

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

  private
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    def student_params
      params.require(:user).permit(User.permitted_params)
    end
end