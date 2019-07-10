class MassEntry
  def self.process(urls)
  	urls.map(&:strip).each do |url|
      html = Net::HTTP.get_response(URI.parse(url)).response.body
      name, tags = with_info(url, html)
      Link.create(url: url, name: name, tags: tags)
  	end
  end

  def self.with_info(url, html)
    if url.include? 'xnxx.com'
      name = Nokogiri::HTML(html).css('strong')[0].text
      tags = Nokogiri::HTML(html).css('div.video-tags').css('a').map(&:text).join(' ')
    elsif url.include? 'xvideos.com'
      name = Nokogiri::HTML(html).css('title')[0].text
      tags = Nokogiri::HTML(html).css('div.video-tags-list').css('a').map(&:text).join(' ')
    elsif url.include? 'youtube.com'
      name = Nokogiri::HTML(html).css('title')[0].text
      tags = html.match(/"keywords.*/)[0].split('"')[-2]
    elsif url.include? 'pornhub.com'
      name = Nokogiri::HTML(html).css('div.title-container').text.squish
      tags = Nokogiri::HTML(html).css('div.categoriesWrapper').css('a').map(&:text).join(' ').sub('+ Suggest', '')
    else
      name = Nokogiri::HTML(html).css('title')[0].text
      tags = "new_from_#{url}"
    end
    return name, tags
  end
end