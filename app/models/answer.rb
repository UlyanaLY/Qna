# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def set_as_best
    return if reload.best?

    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def matched_user?(current_user)
    current_user.id == user_id
  end
end
