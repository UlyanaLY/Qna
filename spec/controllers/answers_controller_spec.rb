# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:invalid_user) { create(:user) }
  let(:second_answer) { create(:answer, question: question, user: invalid_user) }

  describe 'POST #create' do
    sign_in_user

    let(:create_answer) { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it 'saves the new answer in the database with valid user.id' do
        expect { create_answer }.to change(user.answers, :count).by(1)
      end

      it 'render create template' do
        create_answer
      end
    end

    context 'with invalid attributes' do
      sign_in_user
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js }.to_not change(Answer, :count)
      end

      it 'render create template' do
        create_answer
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { answer }
    before { second_answer }

    context 'valid user' do
      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      context 'invalid user' do
        it 'doesn\'t delete answer' do
          expect { delete :destroy, params: { question_id: question, id: second_answer }, format: :js }.not_to change(Answer, :count)
        end

        it 'redirects to index view' do
          delete :destroy, params: { question_id: question, id: second_answer }, format: :js
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    before { answer }
    before { second_answer }

    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js}
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns th question' do
      patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer), format: :js}
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, params: {id: answer, question_id: question, answer: { body: 'new body'}, format: :js}
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer), format: :js}
      expect(response).to render_template :update
    end

  end
end
