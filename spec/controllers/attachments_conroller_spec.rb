require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:attachment) { create(:attachment, question: question) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:invalid_user) { create(:user) }
  let(:second_answer) { create(:answer, question: question, user: invalid_user) }


  describe 'DELETE #destroy' do
    sign_in_user
    before { question }

    context 'valid user' do
      it 'deletes attachment' do
        expect { delete :destroy, params: { question_id: question, id: attachment }, format: :js }.to change(Attachment, :count).by(-1)
      end
    end
  end
end