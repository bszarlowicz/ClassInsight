class Topic < ApplicationRecord
  belongs_to :lesson
  validates :title, presence: true
  validates :date, presence: true

  def self.topic_dates_for_select(lesson)
    lesson.occurrences.map do |o|
      [o, o.to_date]
    end
  end
  
end
