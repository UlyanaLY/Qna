require 'rails_helper'

describe 'Question API' do
  describe 'GET/index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/questions/', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { @user || create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question, user: user) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question)  { questions.first }
      let!(:answer) { create(:answer, question: question, user: user)}

      before { get '/api/v1/questions/', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        get '/api/v1/questions/', params: { format: :json, access_token: access_token.token }
        expect(response).to be_success
      end

      it 'returns list of questions'do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it 'question object contains #{attr}' do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'questions object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end


      context 'answers' do
        it 'is included in a question object' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}") }
        end
      end
    end
  end
end