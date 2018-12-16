require 'rails_helper'

describe 'Question API' do
  describe 'GET/ show' do
    it_behaves_like "API Authenticable"

    let(:user) { @user || create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:comment) { create(:comment, commentable: question, user: user) }
    let!(:attachment) { create(:attachment_api, attachable: question) }

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }

      %w[id title body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}") }
      end
      context 'comments' do
        it 'is included in a question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w[id body created_at updated_at user_id].each do |attr|
          it "questions comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'is included in a question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        %w[url].each do |attr|
          it "questions attachment object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { post '/api/v1/questions/', params: { action: :create, format: :json, access_token: access_token.token, question: attributes_for(:question) } }

      it { expect(response).to be_success }

      it 'adds new question to the database' do
        expect{ post '/api/v1/questions/', params: { action: :create, format: :json, access_token: access_token.token, question: attributes_for(:question)} }.to change { Question.count }.by(1)
      end
    end

    def do_request(options = {})
      post '/api/v1/questions/', params: { action: :create, format: :json }.merge(options)
    end
  end
end