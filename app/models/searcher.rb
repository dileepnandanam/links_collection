class Searcher < ApplicationJob
  def perform(query)
    urls = [
      "https://www.pornhub.com/video/search?search=#{query.split(' ').join('+')}",
      #"https://www.youtube.com/results?search_query=#{query.split(' ').join('+')}",
      "https://www.xnxx.com/search/#{query.split(' ').join('+')}"      
    ]
    urls.each{ |url| fetch_links(url) }
  end

  def fetch_links(url)
    urls = Nokogiri::HTML(Net::HTTP.get_response(url).response.body).html.css('a.linkVideoThumb').map{|link| link['href']} if URI.parse(url).host.include?('pornhub')
    urls = fetch_xnxx_urls(url) if URI.parse(url).host.include?('xnxx')
    urls.each do |u|
      uri = URI.parse(u)
      Link.create url: uri.host.blank? ? "#{URI.parse(url).scheme}://#{URI.parse(url).host}#{u}" : u
    end
  end

  def fetch_xnxx_urls(url)
    html = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(url)).response.body)
    urls = html.css('div.thumb a').map{|link| "https://xnxx.com#{link['href']}"}
    urls.map do |url|
      resp = Net::HTTP.get_response(URI.parse(url)).response
      case resp
        when Net::HTTPSuccess     then url
        when Net::HTTPRedirection then resp['location']
      end
    end
  end
end