module ApplicationHelper
  def external_url(url)
    value = url.to_s.strip
    return value if value.match?(/\A[a-z][a-z0-9+\-.]*:/i)

    "https://#{value}"
  end
end
