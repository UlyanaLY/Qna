# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  respond_to :js
  respond_to :json, only: %i[create]

  before_action :authenticate_user!
  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[show destroy update accept_answer ]
  after_action :publish_answer, only: %i[create]

  authorize_resource

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: @question.id))
    @answer.question = @question
    respond_with(@answer)
  end

  def update
    @question = @answer.question
    respond_with(@answer.update(answer_params))
  end

  def destroy
    @question = @answer.question
    respond_with(@answer.destroy) if current_user.author_of?(@answer)
  end

  def accept_answer
    @question = @answer.question

    if current_user.author_of?(@question)
      @answer = @question.answers.find(params[:id])
      @answer.set_as_best
    else
      flash[:notice] = 'You can\'t accept the answer for the question, that is not yours'
    end
  end

  protected
  def publish_answer

    if @answer.nil?
      set_answer
      @question = @answer.question
      created = false
    else
      created = true
    end
    return if @answer.errors.any?

    data = @answer.as_json.merge(voted: @answer.matched_user?(current_user),
                                 rate: @answer.rate,
                                 created: created,
                                 question_user: @answer.question.user.id,
                                 attachments: @answer.attachments.map do |attach|
                                   { id: attach.id, filename: attach.file.filename, url: attach.file.url }
                                 end)


    logger.debug data
    ActionCable.server.broadcast("questions_#{@question.id}",
                                 data: data
    )
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: %i[file id _destroy])
  end
end
