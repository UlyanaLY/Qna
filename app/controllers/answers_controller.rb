# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[show destroy update]
  before_action :set_question, only: %i[new create]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question

    if @answer.save
      flash[:notice] = 'Answer was successfully created.'
    else

    end
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
    redirect_to @question
  end

  protected

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
