class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Student)
      can [:index], Lesson
      can [:index, :edit, :update], Lesson, student_id: user.id
    end

    if user.is_a?(Teacher)
      can [:index, :new, :create], Lesson
      can [:edit, :update, :destroy], Lesson, teacher_id: user.id
      can :manage, Topic
    end

    if user.is?("admin")
      can :manage, :all
    end
  end

end
