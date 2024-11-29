module ApplicationHelper
  def not_standard_url(url)
    url ? {url: url} : {}
  end

  def print_file_icon(id)
    file = ActiveStorage::Attachment.find(id).blob

    case file.content_type
    when 'image/jpeg', 'image/png', 'image/gif'
      icon = 'file-image-o'
    when 'application/pdf'
      icon = 'file-pdf-o'
    when 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      icon = 'file-word-o'
    when 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      icon = 'file-excel-o'
    when 'application/zip', 'application/x-zip-compressed'
      icon = 'file-archive-o'
    when 'audio/mpeg', 'audio/wav'
      icon = 'file-video-o'
    when 'video/mp4', 'video/webm'
      icon = 'file-audio-o'
    else
      icon = 'file-o'
    end
    
    return icon
  end
end
