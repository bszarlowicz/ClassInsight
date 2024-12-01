module ApplicationHelper

  DAYS_OF_WEEK = { 
    0 => :monday,
    1 => :tuesday, 
    2 => :wednesday, 
    3 => :thursday, 
    4 => :friday, 
    5 => :saturday,
    6 => :sunday, 
  }

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

  def get_next_lesson_data(events)
    nearest_lesson = events.min_by do |lesson|
      future_dates = lesson.occurrences.map { |date| Date.parse(date) }.select { |d| d >= Date.today }
      future_dates.min || nil
    end
    nearest_date = nearest_lesson&.occurrences&.map { |date| Date.parse(date) }&.select { |d| d >= Date.today }&.min
    day_of_week = nearest_date.present? ? I18n.t("days.#{DAYS_OF_WEEK[nearest_date&.wday-1]}") : nil
    [nearest_lesson&.hour&.strftime("%H:%M"), nearest_date&.strftime("%d-%m-%Y"), day_of_week]
  end

  def print_user_initials(name)
    name_parts = name.split
    name_parts[0][0] + name_parts[1][0]
  end
end
