class Student < User
  before_create :set_default_type
  has_many :student_teachers, dependent: :destroy
  has_many :teachers, through: :student_teachers
  has_many :lessons, foreign_key: 'student_id', dependent: :destroy
  has_many :conversations, foreign_key: 'student_id', dependent: :destroy
  

  def self.extra_params
    []
  end

  private

  def set_default_type
    self.type ||= 'Student'
  end
end