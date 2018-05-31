# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, optional: true
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :dispatch_new_answer, on: :create

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

  private

  def dispatch_new_answer
    NewAnswerDispatchJob.perform_later(self)
  end
end
