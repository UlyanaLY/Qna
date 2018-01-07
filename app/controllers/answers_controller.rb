# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_answer, only: %i[show destroy]
  before_action :set_question, only: %i[new create destroy]

  def index
    @answers = Answer.all
  end

  def show
    @answer = @question.answers
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to @answer.question, notice: 'Answer was successfully created.'
    else
      redirect_to @answer.question, notice: 'You need to sign in or sign up before continuing'
    end
  end

  def destroy
    @answer.destroy
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
