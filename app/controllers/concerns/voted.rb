module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:voteup, :votedown]
  end

  def voteup
    @votable.voteup(current_user)
    render_rate
  end

  def votedown
    @votable.votedown(current_user)
    render_rate
  end

  private

  def render_rate
    render json: @votable.rate
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end