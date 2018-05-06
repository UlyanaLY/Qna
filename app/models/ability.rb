class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can :update,[Question, Answer, Comment], user_id: user.id
    can :destroy,[Question, Answer, Comment, Attachment], user_id: user.id

    can :voteup, [Question, Answer] do |item|
      !user.author_of?(item)
    end
    can :votedown, [Question, Answer] do |item|
      !user.author_of?(item)
    end
    can :accept_answer, Answer do |answer|
      user.author_of?(answer.question) && !answer.best?
    end

    can :me, User, id: user.id
  end
end