# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :gon_user

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end
end
