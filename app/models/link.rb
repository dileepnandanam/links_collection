class Link < ApplicationRecord
  validates :url, presence: true
  validates :name, presence: true

  after_create :enqueue_sorce_generation
  after_create :generate_youtube_embed_url

  def enqueue_sorce_generation
    SourceGenerator.perform_later self
  end

  def generate_youtube_embed_url
    host = URI.parse(url.chomp).host
    if host.include? 'youtube.com'
      self.update_attributes(source_url: 'https://youtube.com/embed/' + url.match(/v=(.*)/)[1])
    end
  end

  def generate_source_url
    host = URI.parse(url.chomp).host
    if host.include? 'xnxx.com'
      self.update_attributes(source_url: HtmlFetcher.new(url).fetch_video_url)
    end
  end
end
