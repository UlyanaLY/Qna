class AttachmentsController < ApplicationController
  before_action :load_attachment

  def destroy
    @attachment.destroy
  end

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end