class Report < ApplicationRecord
  belongs_to :teacher, class_name: 'Teacher', foreign_key: 'teacher_id'
  belongs_to :student, class_name: 'Student', foreign_key: 'student_id'


  # validates :parent_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :main_school_subject, presence: true
  validates :level, presence: true
  validates :grade, presence: true
  validates :school_rank, presence: true

  LEVEL = { 
    0 => :basic,
    1 => :advanced, 
  }

  SCHOOL_RANKS = {
    0 => :primary,
    1 => :high,
    2 => :university
  }
  
  GRADES = {
    0 => :first,
    1 => :second,
    2 => :third,
    3 => :fourth,
    4 => :fifth,
    5 => :sixth,
    6 => :seventh,
    7 => :eighth
  }

  MAIN_SCHOOL_SUBJECTS = {
    0 => :biology,
    1 => :math,
    2 => :foreign_language,
    3 => :history,
    4 => :geography,
    5 => :chemistry,
    6 => :physics,
    7 => :polish_language,
    8 => :computer_science
  }

  def print_level
    I18n.t(LEVEL[self.level], scope: :levels)
  end

  def print_school_rank
    I18n.t(SCHOOL_RANKS[self.school_rank], scope: :school_ranks)
  end

  def print_grade
    I18n.t(GRADES[self.grade], scope: :grades)
  end

  def self.levels_for_select
    LEVEL.map { |key, value| [I18n.t(value, scope: :levels), key] }
  end

  def self.school_rank_for_select
    SCHOOL_RANKS.map { |key, value| [I18n.t(value, scope: :school_ranks), key] }
  end

  def self.grades_for_select
    GRADES.map { |key, value| [I18n.t(value, scope: :grades), key] }
  end

  def self.main_school_subject_for_select
    MAIN_SCHOOL_SUBJECTS.map { |key, value| [I18n.t(value, scope: :main_school_subjects), I18n.t(value, scope: :main_school_subjects)] }
  end

end
