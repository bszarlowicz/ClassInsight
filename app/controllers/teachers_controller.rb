class TeachersController < ApplicationController
  load_and_authorize_resource
  before_action :set_student, only: %i[index show]
  

  def index
    @search_url = teachers_path
    @title = Lesson.model_name.human(count: 2)

    @search = @student.teachers.ransack(params[:q])
    @teachers = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def show
    @user = @student
    @events = @student.lessons.where(teacher_id: @teacher.id)
    @topics = @student.lessons.where(teacher_id: @teacher.id).includes(:topics).flat_map(&:topics).sort_by(&:date).reverse
    @next_topic_date = @topics.select { |topic| topic.date > Date.today }.sort_by(&:date).first&.date if @topics.present?
    teacher_attachments = @events.includes(:teacher_files_attachments).flat_map do |lesson|
      lesson.teacher_files_attachments.map(&:blob)
    end
    student_attachments = @events.includes(:student_files_attachments).flat_map do |lesson|
      lesson.student_files_attachments.map(&:blob)
    end
    @teacher_attachments = teacher_attachments.sort_by(&:created_at).reverse
    @student_attachments = student_attachments.sort_by(&:created_at).reverse
    @conversation = Conversation.find_by(teacher_id: @teacher.id, student_id: @student.id)
    @messages = Message.where(conversation_id: @conversation.id)
    @report = Report.find_by(student_id: @user.id, teacher_id: @teacher)
    @report_info = @report&.main_school_subject&.upcase
  end



  private

    def set_student
      @student = current_user
    end

    def student_params
      params.require(:user).permit(User.permitted_params)
    end
end