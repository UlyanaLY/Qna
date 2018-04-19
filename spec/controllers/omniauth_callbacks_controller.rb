require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe 'vkontakte' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:vkontakte)
    end

    context 'new user' do
      before { get :vkontakte }

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'creates new user' do
        expect(controller.current_user).to_not eq nil
      end
    end

    context 'user already exists' do
      before do
        auth = mock_auth_hash(:vkontakte)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :vkontakte
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'does not create user' do
        expect(controller.current_user).to eq user
      end
    end
  end
end