require 'rails_helper'

shared_examples 'voted' do
  resource_name = described_class.controller_name.singularize.to_sym

  sign_in_user

  let(:other_user)  { create(:user) }
  let(:resource)      { create(resource_name, user: other_user) }
  let(:user_resource) { create(resource_name, user: @user) }

  def send_request(action, member)
    process action, method: :post, params: { id: member }, format: :js
  end

  describe 'POST #voteup' do
    context 'resource non-owner' do
      it 'increase score by 1' do
        send_request(:voteup, resource)
        expect(resource.rate).to eq(1)
      end
    end

    it 'saves the new vote in the database' do
      expect { send_request(:voteup, resource) }
          .to change(resource.votes, :count).by(1)
    end

    context 'resource owner' do
      it 'increase score by 1' do
        send_request(:voteup, user_resource)
        expect(user_resource.rate).to eq(0)
      end
    end

    it 'saves the new vote in the database' do
      expect { send_request(:voteup, user_resource) }
          .to change(user_resource.votes, :count).by(0)
    end
  end
end