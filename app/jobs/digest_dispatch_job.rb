class DigestDispatchJob < ApplicationJob
  queue_as :default

   def perform
      questions = Question.where(created_at: 24.hours.ago..Time.now)
      User.find_each.each do |user|
           DigestMailer.digest(user, questions).deliver_now
      end
   end
end
