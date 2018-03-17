module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def voteup(user)
    vote(1, user)
  end

  def votedown(user)
    vote(-1, user)
  end

  def rate
    votes.sum(:rating)
  end

  private

  def vote(rating, user)
    vote = votes.where(user: user, rating: rating)

    if vote.exists?
      votes.where(user: user).first.destroy
    else
      votes.create(rating: rating, user: user)
    end
  end
end