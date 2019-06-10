class HtmlFetcher
  def initialize(url)
  	@url = url
  end

  def fetch_video_url
    html = Net::HTTP.get_response(URI.parse(@url)).response.body
    if html.include?('Sorry, this URL is outdated')
    	@url = 'https://www.xnxx.com' + html.match(/Url : (.*) /)[1].split(' ').first
    	fetch_video_url
    else
      html.match(/setVideoUrlLow\('(.*)'\)/)[1]
    end
  end
end