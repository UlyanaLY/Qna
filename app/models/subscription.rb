class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :subscriber, class_name: 'User', foreign_key: :user_id
end