# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[show destroy]
  before_action :set_question, only: %i[new create]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to @answer.question, notice: 'Answer was successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)

    redirect_to @question, notice: 'Answer was successfully destroyed.'
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
