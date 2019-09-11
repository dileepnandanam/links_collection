class Link < ApplicationRecord
  attr_accessor :lazy
  validates :url, presence: true
  validates :url, uniqueness: true

  belongs_to :visitor


  after_create :generate_source_url, unless: :lazy

  default_scope -> {where(hidden: false)}
  scope :favourite, -> {where('favourite = true')}
  scope :normal, -> {where("COALESCE(LOWER(tags), '') NOT LIKE '%#{'dik'.reverse}%'").order('updated_at DESC')}
  scope :with_orientation, -> (orientation) {
    orientation == 'straight' || orientation.blank? ? where("not(COALESCE(LOWER(name), '') LIKE '%gay%') and not(COALESCE(LOWER(url), '') LIKE '%gay%') and not(COALESCE(LOWER(tags), '')  LIKE '%gay%')") : where("LOWER(name) LIKE '%#{orientation}%' or LOWER(url) LIKE '%#{orientation}%' or LOWER(tags) LIKE '%#{orientation}%'")
  }

  def self.move_top(url)
    existing = Link.where(url: url).first
    if existing.present?
      if existing.tags.to_s.include?('0')
        existing.tags.match(/(0+)/)
        existing.update(tags: existing.tags.gsub(/(0+)/, $1 + '0'))
      else
        existing.update(tags: existing.tags.to_s + ' 10')
      end
    end
  end

  def self.search(q, orientation = nil, order= 'DESC')
    if match_stmt(q, '')[0].blank?
      Link.where('1 = 2')
    else
      Link.with_orientation(orientation)
        .select("#{Link.new.attributes.keys.join(', ')}")
        .where(['name', 'url', 'tags'].map{|att| "#{match_stmt(q, att)[0]} >= #{match_stmt(q, att)[1]}"}.join(' OR '))
        .order("updated_at #{order}")
    end
  end

  def self.search_count(q, orientation = nil)
    Link.with_orientation(orientation).where(['name', 'url', 'tags'].map{|att| "#{match_stmt(q, att)[0]} >= #{match_stmt(q, att)[1]}"}.join(' OR ')).count
  end

  def self.match_stmt(q, column)
    stop_words.each{|sw| q.gsub!(Regexp.new("[$\s]#{sw}[\s^]", 'i'), '')}
    keys = q.split(/[\s,:;\-\(\)\.\/]/).select{|w| w.length > 1}
    match_stmt_str = keys.map{|w| "COALESCE((LOWER(#{column}) LIKE '%#{w.downcase}%'), FALSE)::int"}.join(' + ')
    match_stmt_str.present? ? [match_stmt_str, keys.count] : "id"
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
