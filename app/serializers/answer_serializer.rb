class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  has_many :comments
  has_many :attachments
  belongs_to :user
  belongs_to :question
end