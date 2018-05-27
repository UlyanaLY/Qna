require 'rails_helper'
  describe 'Profile API' do
    describe 'GET/me' do
      it_behaves_like "API Authenticable"

      context 'authorized' do
        let(:me){ create (:user) }
        let(:access_token){ create(:access_token, resource_owner_id: me.id) }

        before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

        it 'returns success' do
          expect(response).to be_success
        end

        %w(id email created_at updated_at admin).each do |attr|
          it { expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr) }
        end

        %w(password encrypted_password).each do |attr|
          it { expect(response.body).to_not have_json_path(attr) }
        end
      end
      def do_request(options = {})
        get '/api/v1/questions/',  params: { format: :json }.merge(options)
      end
    end

    describe 'GET/index' do
      it_behaves_like "API Authenticable"

      context 'authorized' do
        let(:me) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: me.id) }
        let!(:others) { create_list(:user, 2) }

        before { get '/api/v1/profiles/', params: { format: :json, access_token: access_token.token } }

        it 'returns success' do
          expect(response).to be_success
        end

        it 'should not show the info about current user' do
          expect(response.body).not_to include_json(me.to_json)
        end

        it 'should show info about users list' do
          expect(response.body).to be_json_eql(others.to_json)
        end

        %w(id email created_at updated_at admin).each do |attr|
          it { expect(response.body).to be_json_eql(others.first.send(attr.to_sym).to_json).at_path("0/#{attr}") }
        end

        %w(password encrypted_password).each do |attr|
          it { expect(response.body).to_not have_json_path(attr) }
        end
      end
      def do_request(options = {})
        get '/api/v1/profiles/', params: { format: :json }.merge(options)
      end
    end
  end