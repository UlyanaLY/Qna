# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'

  it { should belong_to(:question) }
  it { should have_many(:attachments) }
  it { should belong_to(:user) }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe 'set answer as best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:second_answer) { create(:answer, user: user, question: question) }

    it 'accepts answer as best' do
      answer.set_as_best
      answer.reload

      expect(answer.best).to be true
      expect(question.answers.where(best: true).count).to eq(1)
    end

    it 'the question can have only one best answer' do
      second_answer.set_as_best
      second_answer.reload

      expect(question.answers.where(best: true).count).to eq(1)
    end
  end

  describe 'verify user' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }

    it 'matched' do
      expect(answer.matched_user?(user)).to be true
      expect(question.matched_user?(user)).to be true
    end

    it 'not matched' do
      expect(answer.matched_user?(second_user)).to be_falsey
      expect(question.matched_user?(second_user)).to be_falsey
    end
  end

  describe 'dispatch_new_answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:subscribed_user) { create(:user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let!(:subscription){ create(:subscription, user: subscribed_user, question: question) }

    it 'dispatch_new_answer' do
      NewAnswerDispatchJob.perform_later(answer)
    end
  end
end
