class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = current_user
    @today_lessons = @user.lessons.select do |lesson|
      lesson.occurrences.include?(Date.today.to_s)
    end.sort_by do |lesson|
      lesson.hour
    end

    @lessons = @user.lessons.map do |lesson|
      student = Student.find(lesson.student_id)
      teacher = Teacher.find(lesson.teacher_id)
      lesson.attributes.merge(student_name: student.name, teacher_name: teacher.name)
    end

    @notes = @user.notes.order(created_at: :desc)
  end
  
end
