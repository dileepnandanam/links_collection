class MassEntry
  def self.process(urls)
  	urls.map do |url|
      if url.include? 'xnxx.com'
        name = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(url)).response.body).css('strong')[0].text
        tags = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(url)).response.body).css('div.video-tags').css('a').map(&:text).join(' ')
      elsif url.include? 'youtube.com'
      	name = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(url)).response.body).css('title')[0]
      	tags = ''
      end
      Link.create(url: url, name: name, tags: tags)
  	end
  end
end