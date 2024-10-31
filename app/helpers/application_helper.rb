module ApplicationHelper
  def not_standard_url(url)
    url ? {url: url} : {}
  end
end
