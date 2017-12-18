class Answer < ApplicationRecord
  belongs_to :question, dependent: :destroy, optional: true

  validates :body, presence: true
end