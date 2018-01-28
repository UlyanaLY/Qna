# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of :body }

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
end
