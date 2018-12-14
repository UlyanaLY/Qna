# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:vkontakte]

  has_many :authorizations
  has_many :subscriptions, dependent: :destroy
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments

  def author_of?(resource)
    id == resource.user_id
  end

  def subscribed?(question)
    question.subscriptions.where(user_id: self.id).exists?
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def subscribe(question)
    @subscription = question.subscriptions.create!(user_id: self.id)
 end

  def unsubscribe(question)
    question.subscriptions.where(user_id: self.id).destroy_all
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
