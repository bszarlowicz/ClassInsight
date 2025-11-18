class StudentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_teacher, only: %i[show index new create]

  def index
    @search_url = students_path
    @title = Student.model_name.human(count: 2)

    @search = @teacher.students.ransack(params[:q])
    @students = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def show
    @user = @teacher
    @events = @student.lessons.where(teacher_id: @teacher.id)
    @topics = @student.lessons.where(teacher_id: @teacher.id).includes(:topics).flat_map(&:topics).sort_by(&:date).reverse
    @next_topic_date = @topics.select { |topic| topic.date >= Date.today }.sort_by(&:date).first&.date if @topics.present?
    teacher_attachments = @events.includes(:teacher_files_attachments).flat_map do |lesson|
      lesson.teacher_files_attachments.map(&:blob)
    end
    student_attachments = @events.includes(:student_files_attachments).flat_map do |lesson|
      lesson.student_files_attachments.map(&:blob)
    end
    @teacher_attachments = teacher_attachments.sort_by(&:created_at).reverse
    @student_attachments = student_attachments.sort_by(&:created_at).reverse
    @conversation = Conversation.find_by(teacher_id: @teacher.id, student_id: @student.id)
    @messages = Message.where(conversation_id: @conversation&.id)
    @report = Report.find_by(teacher_id: @user.id, student_id: @student)
    @report_info = [ @report&.main_school_subject&.upcase, @report&.print_level&.upcase, @report&.print_grade&.upcase, @report&.print_school_rank&.upcase].compact.join(", ")
  end

  def new
    @student = Student.new
  end

  def create
    @search_url = students_path
    @title = Student.model_name.human(count: 2)
  
    @search = @teacher.students.ransack(params[:q])
    @students = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
  
    @student = find_or_initialize_student(params[:student])
  
    respond_to do |format|
      if @student.persisted?
        @teacher.students << @student
        create_conversation(@teacher, @student)
        flash[:notice] = flash_message(:create, User)
        format.turbo_stream
        flash.discard
      else
        if @student.save
          @teacher.students << @student
          create_conversation(@teacher, @student)
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
    def set_teacher
      @teacher = current_user
    end

    def student_params
      params.require(:student).permit(User.permitted_params)
    end

    def create_conversation(teacher, student)
      Conversation.find_or_create_by(student: student, teacher: teacher) do |conversation|
        conversation.title = "Chat #{student.name} #{teacher.name}"
      end
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