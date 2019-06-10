class HtmlFetcher
  def initialize(url)
  	@url = url
  end

  def fetch_video_url
    Nokogiri::HTML(Net::HTTP.get_response(URI.parse(@url)).response.body).css('input')[2].attributes['value'].value.match(/src="(.*)"/)[1]
  end
end