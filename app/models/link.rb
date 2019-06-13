class Link < ApplicationRecord
  validates :url, presence: true
  validates :url, uniqueness: true

  after_create :generate_source_url

  scope :normal, -> {where("tags NOT LIKE '%#{'dik'.reverse}%'").order(Arel.sql('random()'))}
  def self.search(q)
    if match_stmt('name', q).blank?
      Link.where('1 = 2')
    else
      where(match_stmt('name', q))
        .or where(match_stmt('url', q))
        .or where(match_stmt('tags', q))
    end
  end

  def self.match_stmt(attrib, q)
    stop_words.each{|sw| q.gsub!(Regexp.new("[$\s]#{sw}[\s^]", 'i'), '')}
    q.split(/[\s,:;\-\(\)\.\/]/).select{|w| w.length > 1}.map{|w| "#{attrib} ~* '#{w}'"}.join(' or ')
  end

  def self.stop_words
    ['ourselves', 'hers', 'between', 'yourself', 'but', 'again', 'there', 'about', 'once', 'during', 'out', 'very', 'having', 'with', 'they', 'own', 'an', 'be', 'some', 'for', 'do', 'its', 'yours', 'such', 'into', 'of', 'most', 'itself', 'other', 'off', 'is', 'am', 'or', 'who', 'as', 'from', 'him', 'each', 'the', 'themselves', 'until', 'below', 'are', 'we', 'these', 'your', 'his', 'through', 'don', 'nor', 'me', 'were', 'her', 'more', 'himself', 'this', 'down', 'should', 'our', 'their', 'while', 'above', 'both', 'up', 'to', 'ours', 'had', 'she', 'all', 'no', 'when', 'at', 'any', 'before', 'them', 'same', 'and', 'been', 'have', 'in', 'will', 'on', 'does', 'yourselves', 'then', 'that', 'because', 'what', 'over', 'why', 'so', 'can', 'did', 'not', 'now', 'under', 'he', 'you', 'herself', 'has', 'just', 'where', 'too', 'only', 'myself', 'which', 'those', 'i', 'after', 'few', 'whom', 't', 'being', 'if', 'theirs', 'my', 'against', 'a', 'by', 'doing', 'it', 'how', 'further', 'was', 'here', 'than']
  end

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
