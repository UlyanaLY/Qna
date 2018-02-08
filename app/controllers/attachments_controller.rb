class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment


  def destroy
    if current_user.id==@attachment.attachable.id
      @attachment.destroy
    end
  end

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end