require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { @user || create(:user) }
  let!(:subscriber) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { sign_in(subscriber) }

    let(:create_subscription) { post :create, params: { question_id: question.id, user_id: subscriber.id, format: :js } }

    it 'assigns user to @user' do
      create_subscription
      expect(assigns("subscription").user).to eq subscriber
    end

    it 'assigns question to @question' do
      create_subscription
      expect(assigns("subscription").question).to eq question
    end

    it 'saves the new subscription to database with valid user_id' do
      expect { post :create, params: { question_id: question.id, user_id: subscriber.id, format: :js } }.to change(subscriber.subscriptions, :count).by(1)
    end

    it 'saves the new subscription to database' do
      expect{ post :create, params: { question_id: question.id, user_id: subscriber.id, format: :js } }.to change(Subscription, :count).by(1)
    end

    it 'render create view' do
      create_subscription
      expect(response).to render_template "common/subscribe"
    end
  end

  describe 'DELETE #destroy' do

    before { sign_in(subscriber) }
    let!(:subscription) { create(:subscription, question: question, user: subscriber) }

      it 'deletes subscription' do
        expect { delete :destroy, params:  { question_id: question.id, user_id: subscriber.id, id: subscription }, format: :js  }.to change(Subscription, :count).by(-1)
      end

      it 'assigns subscription to @subscription' do
        expect(assigns("subscription")).to eq @subscription
      end

      it 'render destroy view' do
        delete :destroy, params:  { question_id: question.id, user_id: subscriber.id, id: subscription }, format: :js
        expect(response).to render_template "common/subscribe"
     end
  end
end
