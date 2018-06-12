require 'rails_helper'

RSpec.describe NewAnswerDispatchJob, type: :job do
  let!(:subscribed_user) { create(:user) }
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:subscription) {create(:subscription, question: question, user: subscribed_user)}

  let!(:answer) {create(:answer, question: question, user: user)}
  let!(:users) { create_list(:user, 10) }

  it 'sends new answer' do
    users.each do |subscribing_user|
      subscribing_user.subscribe(question)
      expect(AnswerMailer).to receive(:notifier).with(answer, subscribing_user)
    end
    NewAnswerDispatchJob.perform_now(answer)
  end

  it 'sends new answer only to subscribers' do
    users.each do |not_subscribed_user|
      expect(AnswerMailer).to_not receive(:notifier).with(answer, not_subscribed_user)
    end

    NewAnswerDispatchJob.perform_now(answer)
  end
end