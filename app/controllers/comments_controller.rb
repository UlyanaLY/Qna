class CommentsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!, except: %i[index show update destroy]
  before_action :set_commentable, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]
  after_action :publish_comment,  only: %i[create]
  before_action :destroy_comment,  only: %i[destroy]

  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))
    respond_with(@comment)
    flash[:notice] = 'Comment was successfully created'
  end

  def destroy
    @commentable = @comment.commentable
    if current_user.author_of?(@comment)
      respond_with(@comment.destroy)
    else
      flash[:notice] = "You can't destroy this comment"
    end
  end

  private

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

  def destroy_comment
    return if @comment.errors.any?
    the_method =  "destroy"

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