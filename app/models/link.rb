class Link < ApplicationRecord
  validates :url, presence: true
  validates :name, presence: true

  after_create :generate_youtube_url
  after_create :generate_xnxx_url

  def generate_youtube_url
    host = URI.parse(url.chomp).host
    if host.include? 'youtube.com'
      self.update_attributes(source_url: 'https://youtube.com/embed/' + url.match(/v=(.*)/)[1])
    end
  end

  def generate_xnxx_url
    host = URI.parse(url.chomp).host
    if host.include? 'xnxx.com'
      self.update_attributes(source_url: HtmlFetcher.new(url).fetch_video_url)
    end
  end
end
