# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_should_behave_like 'voted'

  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:invalid_user) { create(:user) }
  let!(:second_question) { create(:question, user: invalid_user)}
  let(:second_answer) { create(:answer, question: question, user: invalid_user) }

  describe 'POST #create' do
    sign_in_user

    let(:create_answer) { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :json }
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
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :json }.to_not change(Answer, :count)
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
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    before { answer }
    before { second_answer }

    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns th question' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' }, format: :js }
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

  describe 'POST #accept_answer' do
    sign_in_user

    let(:accept_answer) { post :accept_answer, params: { id: second_answer, question_id: question, format: :js } }

    it 'assigns the requested answer to @answer' do
      accept_answer
      expect(assigns(:answer)).to eq second_answer
    end

    it 'assigns the @question' do
      accept_answer
      expect(assigns(:question)).to eq question
    end

    it 'author of question can accept the answer as best' do
      accept_answer

      second_answer.reload
      expect(second_answer.best).to be true
    end

    it 'user can\'t accept answer for someone else\'s  question as best' do

      post :accept_answer, params: { id: second_answer, question_id: second_question, format: :js }
      answer.reload
      expect(answer.best).to be_falsey
    end
  end
end
