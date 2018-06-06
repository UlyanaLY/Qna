class AnswerMailer < ApplicationMailer
    def notifier(answer, user)
      @answer = answer
      @user = user
      mail to: user.email
    end
end
