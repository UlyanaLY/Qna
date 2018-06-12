# require 'rails_helper'
#
# RSpec.describe NewAnswerDispatchJob, type: :job do
#   let!(:subscribed_user) { create(:user) }
#   let!(:user) { create(:user) }
#   let!(:question) { create(:question, user: subscribed_user) }
#   let!(:answer) {create(:answer, question: question, user: user)}
#   let(:foreign_users) { create_list(:user, 10) }
#
#   it 'sends new answer' do
#     expect(AnswerMailer).to receive(:notifier).with(answer.id, subscribed_user)
#     NewAnswerDispatchJob.perform_now(answer)
#   end
#
#   it 'sends new answer only subscribers' do
#     foreign_users.each do |not_subscribed_user|
#       expect(AnswerMailer).to_not receive(:notifier).with(answer.id, not_subscribed_user)
#     end
#
#     NewAnswerDispatchJob.perform_now(answer)
#   end
# end
require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "notifier" do
    let!(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    let(:mail) { AnswerMailer.notifier(answer, question.user) }

    it "renders the headers" do
      expect(mail.to).to eq([question.user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_content answer.body
    end
  end

end
