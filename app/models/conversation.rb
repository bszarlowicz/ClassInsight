class Conversation < ApplicationRecord
  belongs_to :student, class_name: 'Student', foreign_key: 'student_id'
  belongs_to :teacher, class_name: 'Teacher', foreign_key: 'teacher_id'
  has_many :messages, dependent: :destroy
end
