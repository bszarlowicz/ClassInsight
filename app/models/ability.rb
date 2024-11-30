class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Student)

    end

    if user.is_a?(Teacher)
      can :manage, Topic
    end

    if user.is?("admin")
      can :manage, :all
    end
  end

end
