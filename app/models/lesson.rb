class Lesson < ApplicationRecord
  belongs_to :user
  
  after_initialize :set_arrays
  before_save :set_all_occurrences
  before_save :set_hour_time_zone
  before_validation :convert_days_of_week


  validates :hour, presence: true
  validates :year, presence: true

  def set_arrays
    self.days_of_week ||= []
    self.occurrences ||= []
  end

  DAYS_OF_WEEK = { 
    0 => :sunday, 
    1 => :monday, 
    2 => :tuesday, 
    3 => :wednesday, 
    4 => :thursday, 
    5 => :friday, 
    6 => :saturday 
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

  def display_school_year
    "#{self.year}/#{self.year+1}"
  end

  def display_days_of_week
    self.days_of_week.map { |day| I18n.t('date.day_names')[day] }
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
