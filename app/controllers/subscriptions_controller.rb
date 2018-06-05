
class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_subscription, only: [:destroy]

  authorize_resource

  respond_to :html, :json, :js

  def create
    @subscription = current_user.subscribe(@question)
    respond_with(@subscription, template: 'common/subscribe')
  end

  def destroy
    @question = @subscription.question
    respond_with(@subscription.destroy!, template: 'common/subscribe')
  end

  private

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
