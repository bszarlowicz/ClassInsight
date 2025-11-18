class TopicsController < ApplicationController
  load_and_authorize_resource
  before_action :set_student, only: %i[ new  create destroy ]
  before_action :set_lesson, only: %i[ new create destroy ]

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # POST /topics or /topics.json
  def create
    @topic = Topic.new(topic_params)
    @topic.lesson_id = @lesson.id
    respond_to do |format|
      if @topic.save
        @topics = @student.lessons.where(teacher_id: current_user.id).includes(:topics).flat_map(&:topics).sort_by(&:date).reverse
        @next_topic_date = @topics.select { |topic| topic.date >= Date.today }.sort_by(&:date).first&.date if @topics.present?
        flash[:notice] = flash_message(:create, Topic)
        format.turbo_stream
        format.json { render :show, status: :created, location: @topic }
        flash.discard
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @topic.destroy!

    respond_to do |format|
      format.html { redirect_to student_path(@student), notice: flash_message(:destroy, Topic) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    
    def set_student
      @student = Student.find(params[:user_id])
    end

    def set_lesson
      @lesson = Lesson.find(params[:lesson_id])
    end

    # Only allow a list of trusted parameters through.
    def topic_params
      params.require(:topic).permit(:title, :date)
    end
end
