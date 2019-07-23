class EmbedUrlFetcher < ApplicationJob
  def perform(link_id)
  	@link = Link.find(link_id)
  	get_xnxx_data
    get_pornhub_data
    get_youtube_url
    get_xvideos_data
    get_xhamster_data
    @link.source_url
  end

  def get_youtube_url
    host = URI.parse(@link.url.chomp).host
    if host.include? 'youtube.'
      html = Net::HTTP.get_response(URI.parse(@link.url)).response.body
      name, tags = MassEntry.with_info(@link.url, html) if [name, tags].any?(&:blank?)
      @link.update_attributes(name: @link.name.present? ? @link.name : name, tags: (@link.tags.to_s + ' ' + tags).split(' ').uniq.join(' '), source_url: 'https://youtube.com/embed/' + @link.url.match(/v=(.*)/)[1])
    end
  end

  def get_xvideos_data
    host = URI.parse(@link.url.chomp).host
    if host.include? 'xvideos.'
      html = Net::HTTP.get_response(URI.parse(@link.url)).response.body
      if html.include?('Sorry, this URL is outdated')
        @link.url = 'https://www.xvideos.com' + html.match(/Url : (.*) /)[1].split(' ').first
        get_xvideos_data
        return
      end
      name, tags = MassEntry.with_info(@link.url, html) if [name, tags].any?(&:blank?)
      video_url = html.match(/setVideoUrlLow\('(.*)'\)/)[1]
    else
      return
    end
    @link.update_attributes(name: name, tags: tags, source_url: video_url)
  end

  def get_xhamster_data
    host = URI.parse(@link.url.chomp).host
    if host.include? 'xhamster.'
      html = Net::HTTP.get_response(URI.parse(@link.url)).response.body
      if html.include?('Sorry, this URL is outdated')
        @link.url = 'https://www.xhamster.com' + html.match(/Url : (.*) /)[1].split(' ').first
        get_xhamster_data
        return
      end
      name, tags = MassEntry.with_info(@link.url, html) if [name, tags].any?(&:blank?)
      video_url = html.match(/embedUrl":"(.*)"/)[1][0..33]
    else
      return
    end
    @link.update_attributes(name: name, tags: tags, source_url: video_url)
  end

  def get_xnxx_data
    host = URI.parse(@link.url.chomp).host
    if host.include? 'xnxx.'
      html = Net::HTTP.get_response(URI.parse(@link.url)).response.body
      if html.include?('Sorry, this URL is outdated')
        @link.url = 'https://www.xnxx.com' + html.match(/Url : (.*) /)[1].split(' ').first
        get_xnxx_data
        return
      end
      name, tags = MassEntry.with_info(@link.url, html) if [name, tags].any?(&:blank?)
      video_url = html.match(/setVideoUrlLow\('(.*)'\)/)[1]
    else
      return
    end
    @link.update_attributes(name: name, tags: tags, source_url: video_url)
  end

  def get_pornhub_data
    host = URI.parse(@link.url.chomp).host
    if host.include? 'pornhub.'
      html = Net::HTTP.get_response(URI.parse(@link.url)).response.body
      name, tags = MassEntry.with_info(@link.url, html) if [name, tags].any?(&:blank?)
    else
      return
    end
    video_url = Nokogiri::HTML(html).css('meta[name="twitter:player"]').attr('content').value
    @link.update_attributes(name: name, tags: tags, source_url: video_url)
  end
end