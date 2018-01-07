# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:invalid_user) { create(:user) }
  let(:second_answer) { create(:answer, question: question, user: invalid_user) }

  describe 'POST #create' do
    sign_in_user

    let(:create_answer) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show question view' do
        create_answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      sign_in_user
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 'redirects to show question view' do
        create_answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { answer }

    context 'valid user' do
      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      context 'invalid user' do
        it 'deletes question' do
          expect { delete :destroy, params: { question_id: question, id: second_answer } }.not_to change(Answer, :count)
        end

        it 'redirects to index view' do
          delete :destroy, params: { question_id: question, id: second_answer }
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end
    end
  end
end
