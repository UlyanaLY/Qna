require 'rails_helper'

describe 'Answers API' do
  let(:user) { @user || create(:user) }
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question, user: user) }

  let!(:answers) { create_list(:answer, 2, question: question, user: user) }
  let(:answer) { answers.first }
  let!(:comment) { create(:comment, commentable: answer, user: user) }
  let!(:attachment) { create(:attachment_api, attachable: answer) }


  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do

      before { get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token.token }}

      it { expect(response).to be_success }

      %w[body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")}
      end

      context 'comments' do
        it { expect(response.body).to have_json_size(1).at_path("answer/comments") }
        %w(id body created_at).each do |attr|
          it { expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}") }
        end
      end
      context 'attachments' do
        it { expect(response.body).to have_json_size(1).at_path("answer/attachments") }

        %w[url].each do |attr|
          it "answers attachment object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(2).at_path('answers') }

      %w[id body created_at updated_at].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/1/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:answer_params) { attributes_for(:answer) }
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      subject { post "/api/v1/questions/#{question.id}/answers", params: { answer: answer_params, format: :json, access_token: access_token.token }}

      it 'status 200' do
         subject
         expect(response).to be_success
      end

      it 'adds new answer to the database' do
        subject
        expect { post "/api/v1/questions/#{question.id}/answers",  params: { answer: answer_params, format: :json, access_token: access_token.token } }.to change { Answer.count }.by(1)
      end

      context 'attributes' do
        it 'is included in a answer object' do
          subject
          expect(response.body).to have_json_size(9).at_path("answer")
        end

        %w[body].each do |attr|
          it "answer object contains #{attr}" do
            subject
            expect(response.body).to be_json_eql(answer_params[attr.to_sym].to_json).at_path("answer/#{attr}")
          end
        end

        %w[user_id].each do |attr|
          it "answer object contains #{attr}" do
            subject
            expect(response.body).to be_json_eql(answer[attr.to_sym].to_json).at_path("answer/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { action: :create, format: :json}.merge(options)
    end
  end
end