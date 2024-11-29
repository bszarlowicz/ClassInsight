class Lesson < ApplicationRecord
  belongs_to :teacher, class_name: 'Teacher', foreign_key: 'teacher_id'
  belongs_to :student, class_name: 'Student', foreign_key: 'student_id'
  has_many :topics, dependent: :destroy
  has_many_attached :teacher_files
  has_many_attached :student_files
  
  after_initialize :set_arrays
  before_save :set_all_occurrences
  before_save :set_hour_time_zone
  before_validation :convert_days_of_week


  validates :hour, presence: true
  validates :year, presence: true
  validates :duration, presence: true
  validate :check_days_of_week

  def set_arrays
    self.days_of_week ||= []
    self.occurrences ||= []
  end

  DAYS_OF_WEEK = { 
    0 => :monday,
    1 => :tuesday, 
    2 => :wednesday, 
    3 => :thursday, 
    4 => :friday, 
    5 => :saturday,
    6 => :sunday, 
  }
  
  def set_hour_time_zone
    self.hour = Time.zone.parse(self.hour.to_s)
  end

  def set_all_occurrences
    school_start_date = Time.zone.local(self.year, 9, 1, 12, 00, 00)
    school_end_date = Time.zone.local(self.year+1, 6, 30, 12, 00, 00)
    occurrence_days = get_symbols_of_week_days
    schedule = IceCube::Schedule.new(school_start_date)

    occurrence_days.each do |day|
      schedule.add_recurrence_rule IceCube::Rule.weekly.day(day).until(school_end_date)
    end

    self.occurrences = schedule.all_occurrences.map { |occurrence| occurrence.to_date }
  end

  def add_day(day)
    self.days_of_week << day unless days_of_week.include?(day)
  end

  def remove_day(day)
    days_of_week.delete(day)
  end

  def self.quick_search
    :hour_cont
  end

  def self.school_year_for_select
    today = Date.today
    current_year = today.month >= 9 ? today.year : today.year - 1
    school_years = [
      ["#{current_year}/#{current_year + 1}", current_year],
      ["#{current_year + 1}/#{current_year + 2}", current_year + 1]
    ]
  end

  def self.duration_time_for_select
    [
      ["30 minut", 30],
      ["45 minut", 45],
      ["1 godzina", 60],
      ["1 godzina 15 minut", 75],
      ["1 godzina 30 minut", 90], 
      ["1 godzina 45 minut", 105], 
      ["2 godziny", 120], 
    ]
  end

  def display_school_year
    "#{self.year}/#{self.year+1}"
  end

  def display_days_of_week
    self.days_of_week.map do |day|
      day_symbol = DAYS_OF_WEEK[day]
      I18n.t("days.#{day_symbol}")
    end
  end

  def display_lesson_end_time
    hours = self.duration / 60
    minutes = self.duration % 60
    (self.hour + (hours * 1.hour) + (minutes * 1.minute)).strftime("%H:%M")
  end

  def check_days_of_week
    errors.add(:days_of_week, message: I18n.t(:empty_days_of_week)) if self.days_of_week.empty?
  end 

  private
    def get_symbols_of_week_days
      self.days_of_week.map { |day| DAYS_OF_WEEK[day] }
    end

    def self.ransackable_attributes(auth_object = nil)
      super & %w(
        hour
      )
    end

    def self.ransackable_associations(auth_object = nil)
      super + ['user']
    end

    def convert_days_of_week
      self.days_of_week = days_of_week.map(&:to_i) if days_of_week.is_a?(Array)
    end

end
