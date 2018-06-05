class NewAnswerDispatchJob < ApplicationJob
  queue_as :mailers

    def perform(answer)
      answer.question.subscriptions.includes(:user).each do |subscription|
        if answer.user != subscription.user
          AnswerMailer.notifier(answer, subscription.user).try(:deliver_later) unless subscription.user.author_of?(answer)
        end
      end
    end
end
