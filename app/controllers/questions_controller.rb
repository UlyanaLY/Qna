# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  respond_to :html, :json, :js

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :build_answer, only: %i[show]

  after_action :publish_question, only: %i[create]

  def index
    respond_with(@questions = Question.all)
  end

  def show

    respond_with (@question.comments.new)
  end

  def new
    @question = Question.new
    respond_with (@question.attachments.build)
  end

  def edit; end

  def create
    respond_with( @question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy) if current_user.author_of?(@question)
  end

  private

  def load_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[file id _destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',
                                 ApplicationController.render(
                                     partial: 'common/question_list',
                                     locals: { question: @question }
                                 )
    )
  end
end
