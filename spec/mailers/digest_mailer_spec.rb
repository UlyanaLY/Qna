require "rails_helper"

RSpec.describe DigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 5, user: user) }
    let(:mail) { DigestMailer.digest(user, questions) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Questions of the last day")
    end
  end
end
