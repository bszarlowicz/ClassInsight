class Teacher < User
  before_create :set_default_type
  has_many :student_teachers, dependent: :destroy
  has_many :students, through: :student_teachers

  def self.extra_params
    []
  end

  private

  def set_default_type
    self.type ||= 'Teacher'
  end
end