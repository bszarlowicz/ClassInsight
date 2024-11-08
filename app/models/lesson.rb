class Lesson < ApplicationRecord
  belongs_to :user
  
  after_initialize :set_arrays
  after_save :set_all_occurrences
  before_validation :convert_days_of_week


  validates :hour, presence: true
  validates :year, presence: true

  def set_arrays
    self.days_of_week ||= []
    self.occurrences ||= []
  end

  def set_all_occurrences
    schedule = IceCube::Schedule.new(Time.zone.local(self.year, 8, 31, 23, 59, 59))
    schedule.add_recurrence_rule IceCube::Rule.weekly.day(:friday).until(Time.zone.local(self.year+1, 6, 30, 12, 00, 00))
    schedule.all_occurrences.each do |occurence|
      self.occurrences << occurence
    end
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

  private
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
