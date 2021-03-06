# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.author_of?' do
    let(:user) { create(:user) }
    let(:invalid_user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'for author' do
      expect(user).to be_author_of(question)
    end

    it 'not for author' do
      expect(invalid_user).not_to be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) {OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456')}

    context 'user already has authorisation' do
      it 'returns the user' do
        user.authorizations.create(provider: 'vkontakte', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorisation' do
      context 'user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context 'user does not exist' do
      context 'account with email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
