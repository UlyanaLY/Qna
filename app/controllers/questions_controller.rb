# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    #@answer = Answer.new(question: @question)
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      redirect_to @question, notice: 'You can\'t update question, that is no yours'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question was successfully destroyed.'
    else
      redirect_to @question, notice: 'You can\'t delete question, that is no yours'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
