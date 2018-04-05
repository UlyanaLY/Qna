# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :verify_user, only: %i[update destroy]

  after_action :publish_question, only: %i[create show]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.new
    @question.comments.new
  end

  def new
    @question = Question.new
    @question.attachments.build
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
    if verify_user
      @question.update(question_params)
      flash[:notice] = if @question.save
                         'Question was successfully updated.'
                       else
                         'Body or title of question can\'t be blanck'
                       end
    else
      flash[:notice] = 'You can\'t update question, that is no yours'
    end
    redirect_to @question
  end

  def destroy
    if verify_user
      @question.destroy
      flash[:notice] = 'Question was successfully destroyed.'
    else
      flash[:notice] = 'You can\'t delete question, that is no yours'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[file id _destroy])
  end

  def verify_user
    current_user.author_of?(@question)
  end

  def publish_question
      if @question.nil?
        load_question
        created = false
      else
        created = true
      end
      return if @question.errors.any?

      data = @question.as_json(include: :attachments).merge(answer: @question,
                                                          voted: @question.matched_user?(current_user),
                                                          rate: @question.rate,
                                                          created: created,
                                                          question_user: @question.user.id,
                                                          attachments: @question.attachments.map do |attach|
                                                            { id: attach.id, filename: attach.file.filename, url: attach.file.url }
                                                          end

      )
      ActionCable.server.broadcast("questions_#{@question.id}",
                                   data: data
      )
  end
end
