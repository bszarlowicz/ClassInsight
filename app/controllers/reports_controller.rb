class ReportsController < ApplicationController
  load_and_authorize_resource

  def new
    @student = Student.find(params[:student_id])
    @report = Report.new
  end

  def edit
    @student = Student.find(params[:student_id])
  end

  def create
    @teacher = current_user
    @student = Student.find(params[:report][:student_id])

    @search_url = students_path
    @title = Student.model_name.human(count: 2)
    @students = @teacher.students
    @search = @students.ransack(params[:q])

    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        flash[:notice] = flash_message(:create, Report)
        format.turbo_stream
        format.json { render :show, status: :created, location: @report }
        flash.discard
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @teacher = current_user
    @student = Student.find(params[:report][:student_id])

    @search_url = students_path
    @title = Student.model_name.human(count: 2)
    @students = @teacher.students
    @search = @students.ransack(params[:q])

    respond_to do |format|
      if @report.update(report_params)
        flash[:notice] = flash_message(:update, Report)
        format.turbo_stream
        format.json { render :show, status: :created, location: @report }
        flash.discard
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @report.destroy!

    respond_to do |format|
      format.html { redirect_to reports_url, notice: "Report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def report_params
      params.require(:report).permit(:teacher_id, :student_id, :main_school_subject, :level, :grade, :school_rank)
    end
end
