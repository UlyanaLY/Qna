class AnswerMailer < ApplicationMailer
  def notifier(answer, user)
    @answer = answer
    mail to: user.email
  end
end
