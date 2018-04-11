require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  let(:comment) { create(:comment, user: user)}


  describe 'POST #create' do
    sign_in_user
    context'with valid attributes' do
      it 'saves a new comment to database' do
        expect { post :create, params: { answer_id: answer, format: :js, comment: attributes_for(:comment) } }
            .to change(Comment, :count).by(1)

        expect { post :create, params: { question_id: question, format: :js, comment: attributes_for(:comment) } }
            .to change(Comment, :count).by(1)
      end
    end
  end
end