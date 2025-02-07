class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Student)
      can :manage, Note, user_id: user.id
      can [:index], Lesson
      can [:index, :edit, :update, :add_attachments], Lesson, student_id: user.id
      can [:index, :show], Teacher, id: user.teachers.pluck(:id)
      can [:create], Message
      can [:edit, :update], User, id: user.id
    end

    if user.is_a?(Teacher)
      
      can :manage, Note, user_id: user.id
      can :manage, Report, teacher_id: user.id
      can [:new, :create], Student
      can [:index, :show], Student, id: user.students.pluck(:id)
      can [:index, :new, :create], Lesson
      can [:edit, :update, :destroy, :add_attachments, :remove_attachment], Lesson, teacher_id: user.id
      can [:new, :create], Topic
      can [:destroy], Topic, lesson: { teacher_id: user.id }
      can [:create], Message
      can [:edit, :update], User, id: user.id
    end

    if user.is?("admin")
      can :manage, :all
    end

  end

end
