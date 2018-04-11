class CommentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show update destroy]
  before_action :set_commentable, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]
  after_action :publish_comment,  only: %i[create]
  after_action :destroy_comment,  only: %i[destroy]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: { body: @comment.body }
    else
      render json: @comment.errors.full_messages
    end
  end

  def destroy
      @comment.destroy
      flash[:notice] = 'Comment was successfully destroyed.'
  end

  private

  def destroy_comment
    return if @comment.errors.any?
    the_method = "destroyed"
    data = {
        comment: @comment,
        commentable_id: @comment.commentable.id,
        commentable_type: @comment.commentable_type.underscore,
        the_method: the_method,
        comment_id: @comment.id,
        user_email: @comment.user.email
    }
    ActionCable.server.broadcast( "comments_for#{@comment.commentable_type === 'Question' ? @comment.commentable.id : @comment.commentable.question_id}",
                                  data
    )
  end

  def publish_comment
    return if @comment.errors.any?
    the_method =  "created"

    data = {
        commentable_id: @commentable.id,
        commentable: @commentable,
        commentable_type: @comment.commentable_type.underscore,
        the_method: the_method,
        comment: @comment,
        comment_id: @comment.id,
        user_email: @comment.user.email
    }
    ActionCable.server.broadcast( "comments_for#{@comment.commentable_type === 'Question' ? @commentable.id : @commentable.question_id}",
                                  data
    )
  end

  def set_commentable
    @commentable = Question.find(params[:question_id]) if (params[:question_id]).present?
    @commentable = Answer.find(params[:answer_id]) if (params[:answer_id]).present?
  end
  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end