class Link < ApplicationRecord
  attr_accessor :lazy
  validates :url, presence: true
  validates :url, uniqueness: true

  after_create :generate_source_url, unless: :lazy

  scope :normal, -> {where("tags NOT LIKE '%#{'dik'.reverse}%'").order('created_at DESC')}
  def self.search(q)
    if match_stmt(q).blank?
      Link.where('1 = 2')
    else
      Link.select("#{Link.new.attributes.keys.join(', ')}, (#{match_stmt(q)}) as match_count")
        .where("#{match_stmt(q)} > 0")
        .order('match_count, created_at DESC')
    end
  end

  def self.match_stmt(q)
    stop_words.each{|sw| q.gsub!(Regexp.new("[$\s]#{sw}[\s^]", 'i'), '')}
    q.split(/[\s,:;\-\(\)\.\/]/).select{|w| w.length > 1}.map{|w| "(name ~* '#{w}')::int + (url ~* '#{w}')::int + (tags ~* '#{w}')::int"}.join(' + ')
  end

  def self.stop_words
    ['ourselves', 'hers', 'between', 'yourself', 'but', 'again', 'there', 'about', 'once', 'during', 'out', 'very', 'having', 'with', 'they', 'own', 'an', 'be', 'some', 'for', 'do', 'its', 'yours', 'such', 'into', 'of', 'most', 'itself', 'other', 'off', 'is', 'am', 'or', 'who', 'as', 'from', 'him', 'each', 'the', 'themselves', 'until', 'below', 'are', 'we', 'these', 'your', 'his', 'through', 'don', 'nor', 'me', 'were', 'her', 'more', 'himself', 'this', 'down', 'should', 'our', 'their', 'while', 'above', 'both', 'up', 'to', 'ours', 'had', 'she', 'all', 'no', 'when', 'at', 'any', 'before', 'them', 'same', 'and', 'been', 'have', 'in', 'will', 'on', 'does', 'yourselves', 'then', 'that', 'because', 'what', 'over', 'why', 'so', 'can', 'did', 'not', 'now', 'under', 'he', 'you', 'herself', 'has', 'just', 'where', 'too', 'only', 'myself', 'which', 'those', 'i', 'after', 'few', 'whom', 't', 'being', 'if', 'theirs', 'my', 'against', 'a', 'by', 'doing', 'it', 'how', 'further', 'was', 'here', 'than']
  end

  def generate_source_url
    if Rails.env.production?
      EmbedUrlFetcher.perform_later(self.id)
    else
      EmbedUrlFetcher.new.perform(self.id)
    end
  end

  def generate_source_url_now
    EmbedUrlFetcher.new.perform(self.id)
  end
end
