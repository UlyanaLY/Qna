class QuestionsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "questions_#{data['id']}"
  end
end