class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id

  has_many :comments
  has_many :attachments

  belongs_to :question
  belongs_to :user
end