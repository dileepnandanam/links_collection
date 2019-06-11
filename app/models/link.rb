class Link < ApplicationRecord
  validates :url, presence: true

  after_create :generate_source_url

  def get_youtube_url
    host = URI.parse(url.chomp).host
    if host.include? 'youtube.com'
      self.update_attributes(source_url: 'https://youtube.com/embed/' + url.match(/v=(.*)/)[1])
    end
  end

  def get_xnxx_data
    host = URI.parse(url.chomp).host
    if host.include? 'xnxx.com'
      html = Net::HTTP.get_response(URI.parse(url)).response.body
    else
      return
    end
    if html.include?('Sorry, this URL is outdated')
      url = 'https://www.xnxx.com' + html.match(/Url : (.*) /)[1].split(' ').first
      get_xnxx_data
      return
    else
      video_url = html.match(/setVideoUrlLow\('(.*)'\)/)[1]
    end
    self.update_attributes(source_url: video_url)
  end

  def get_pornhub_data
    host = URI.parse(url.chomp).host
    if host.include? 'pornhub.com'
      html = Net::HTTP.get_response(URI.parse(url)).response.body
    else
      return
    end
    video_url = Nokogiri::HTML(html).css('meta[name="twitter:player"]').attr('content').value
    self.update_attributes(source_url: video_url)
  end

  def generate_source_url
    get_xnxx_data
    get_pornhub_data
    get_youtube_url
    source_url
  end
end
