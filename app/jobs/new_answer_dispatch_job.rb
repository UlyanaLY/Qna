class NewAnswerDispatchJob < ApplicationJob
  queue_as :default

  def perform(answer)
    subscribers = answer.question.subscribers
    subscribers.each do |recipient|
      AnswerMailer.notifier(answer, recipient).try(:deliver_later) unless answer.user == recipient
    end
  end
end