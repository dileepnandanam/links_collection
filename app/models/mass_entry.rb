class MassEntry
  def self.process(urls)
  	urls.map do |url|
      if url.include? 'xnxx.com'
        name = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(url)).response.body).css('strong')[0].text
        tags = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(url)).response.body).css('div.video-tags').css('a').map(&:text).join(' ')
      elsif url.include? 'youtube.com'
      	name = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(url)).response.body).css('title')[0].text
      	tags = Net::HTTP.get_response(URI.parse(url)).response.body.match(/"keywords.*/)[0].split('"')[-2]
      elsif url.include? 'pornhub.com'
        name = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(url)).response.body).css('div.title-container').text.squish
        tags = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(url)).response.body).css('div.categoriesWrapper').css('a').map(&:text).join(' ').sub('+ Suggest', '')
      end
      Link.create(url: url, name: name, tags: tags)
  	end
  end
end