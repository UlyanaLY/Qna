# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :load_quest

  def destroy
    @attachment.destroy if @attachment.attachable.matched_user?(current_user)
  end

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def load_quest
    @question = Question.find_by_id(@attachment.attachable.id)
  end
end
