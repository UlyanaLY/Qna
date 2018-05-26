class AttachmentSerializer < ActiveModel::Serializer
  attributes :url, :filename

  def filename
    object.file.filename
  end

  def url
    object.file.url
  end
end