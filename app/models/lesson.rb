class Lesson < ApplicationRecord
  belongs_to :user
  after_initialize :set_days_of_week

  def set_days_of_week
    self.days_of_week ||= []
  end

  def add_day(day)
    self.days_of_week << day unless days_of_week.include?(day)
  end

  def remove_day(day)
    days_of_week.delete(day)
  end

end
