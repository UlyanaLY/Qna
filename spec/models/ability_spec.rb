require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }
    let(:second_question) { create :question, user: other }
    let(:answer) { create :answer, question: question, user: user}
    let(:second_answer) { create :answer, question: question, user: other}


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }

    context 'Question' do

      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, second_question, user: user }
      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, second_question, user: user }

      it { should be_able_to :voteup, second_question, user: user }
      it { should be_able_to :votedown, second_question, user: user }

      it { should_not be_able_to :voteup, question, user: user }
      it { should_not be_able_to :votedown, question, user: user }
    end

    context 'Answer' do
      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, second_answer, user: user }
      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, second_answer, user: user }

      it { should be_able_to :voteup, second_answer, user: user }
      it { should be_able_to :votedown, second_answer, user: user }

      it { should_not be_able_to :voteup, answer, user: user }
      it { should_not be_able_to :votedown, answer, user: user }

      it { should be_able_to :accept_answer, second_answer, user: user }
      it { should_not be_able_to :accept_answer, create(:answer, user: other, question: second_question), user: user }
    end
  end
end