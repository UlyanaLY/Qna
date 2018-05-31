# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create :question, user: user }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should have_many(:comments)}
  it { should have_many(:subscriptions)}
  it { should have_many(:subscribers)}
  it { should belong_to(:user) }


  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe '#subscribed?' do
    it 'user subscribed to question or not?' do
      expect(question).to be_subscribed(user)
    end
  end
  describe '#add_subscribe' do
    it 'create a new subscribe for question' do
      expect(question.subscriptions).to include(question.add_subscribe(other_user))
    end
  end

  describe '#del_subscribe' do
    it 'del subscribe for question' do
      expect(question.subscriptions).to_not include(question.del_subscribe(user))
    end
  end
end
