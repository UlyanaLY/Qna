require 'rails_helper'

RSpec.describe DigestDispatchJob, type: :job do
    let!(:users) { create_list(:user, 5) }

    it 'sends digest to all users' do
      users.each do |user|
        expect(DigestMailer).to receive(:digest).with(user).and_call_original
      end

      DigestDispatchJob.perform_now
    end
end
