# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, foreign_key: :id
  has_many :attachments, as: :attachable
  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscription_create

  def matched_user?(current_user)
    current_user.id == user_id
  end

  def subscribed?(user)
    subscriptions.exists?(subscriber: user)
  end

  def add_subscribe(user)
    subscriptions.create!(subscriber: user, question: self)
  end

  def del_subscribe(user)
    subscriptions.where(subscriber: user).destroy_all
  end

  private

  def subscription_create
    subscriptions.create!(subscriber: user)
  end
end
