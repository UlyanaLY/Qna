class Api::V1::ProfilesController < ApplicationController
  respond_to :json

  before_action :doorkeeper_authorize!
  def me
    respond_with current_resource_owner
  end

  protected
  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end