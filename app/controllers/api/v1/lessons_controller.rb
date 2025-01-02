class Api::V1::LessonsController < ApiBaseController
  def show
    @lesson = Lesson.find(params[:id])

    if @lesson
      render 'lessons/show'
    else
      render json: @lesson.errors, status: :bad_request
    end
  end
end
