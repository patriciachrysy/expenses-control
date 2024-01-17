class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is? :admin
      can :manage, Category
      can :manage, Expense
      can :manage, User
    else
      can :manage, Category, user_id: user.id
      can :manage, Expense, author_id: user.id
    end
  end
end
