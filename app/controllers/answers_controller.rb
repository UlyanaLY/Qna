# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: %i[show destroy update accept_answer]
  before_action :set_question, only: %i[new create]

  after_action :publish_answer, only: %i[create]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question

    flash[:notice] = 'Answer was successfully created.' if @answer.save && current_user.author_of?(@answer)
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was successfully destroyed.'
    else
      flash[:notice] = 'You can\'t destroy the answer, that is not yours'
    end
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
    return if @answer.errors.any?
    attachments = @answer.attachments.map do |attach|
      { id: attach.id, filename: attach.file.filename, url: attach.file.url }
    end
    data = @answer.as_json(include: :attachments).merge(answer: @answer,
                                                        voted: @answer.matched_user?(current_user),
                                                        rating: @answer.rate)


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
