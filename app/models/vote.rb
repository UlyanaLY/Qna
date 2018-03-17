# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user

  validate :vote_once

  def vote_once
    errors.add(:user_id, "You can't vote for your #{votable_type}") if votable && user_id == votable.user_id
  end
end