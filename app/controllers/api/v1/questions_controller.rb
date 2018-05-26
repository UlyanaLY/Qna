class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    respond_with current_resource_owner.questions.create(question_params)
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end