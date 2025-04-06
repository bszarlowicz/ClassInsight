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
    day_number = nearest_date&.wday-1
    day_of_week = nearest_date.present? ? I18n.t("days.#{DAYS_OF_WEEK[day_number < 0 ? 6 : day_number]}") : nil
    [nearest_lesson&.hour&.strftime("%H:%M"), nearest_date&.strftime("%d-%m-%Y"), day_of_week]
  end

  def print_user_initials(name)
    name_parts = name.split
    name_parts[0][0] + name_parts[1][0]
  end

  def darken_rgba_color(rgba, amount = 0.1)
    rgba_values = rgba.match(/^rgba\((\d+), (\d+), (\d+), ([0-9.]+)\)$/)
  
    return rgba unless rgba_values
  
    r = rgba_values[1].to_i
    g = rgba_values[2].to_i
    b = rgba_values[3].to_i
    a = rgba_values[4].to_f
  
    r = (r * (1 - amount)).floor
    g = (g * (1 - amount)).floor
    b = (b * (1 - amount)).floor
  
    "rgba(#{r}, #{g}, #{b}, #{a})"
  end

  def get_lesson_user_url(user, lesson)
    if user.is_a?(Teacher)
      student_path(lesson.student)
    elsif user.is_a?(Student)
      teacher_path(lesson.teacher)
    else
      dashboard_path
    end
  end

end
