class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments_for#{data['id']}"
  end
end