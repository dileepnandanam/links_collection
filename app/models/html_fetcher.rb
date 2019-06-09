class HtmlFetcher

  def initialize(url)
  	@url = url
  end

  def fetch_video_url
    Net::HTTP.get_response(URI.parse(@url)).response.body.match(/setVideoUrlLow\('(.*)'\)/)[1]
  end
end