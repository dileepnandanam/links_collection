class HtmlFetcher
  require 'capybara/dsl'
  include Capybara::DSL
  Capybara.current_driver = Capybara.javascript_driver

  def initialize(url)
  	@url = url
  end

  def fetch_video_url
    Capybara.app_host = URI.parse(@url.chomp).scheme + '://' + URI.parse(@url.chomp).host
    visit URI.parse(@url.chomp).path
    page.find('#html5video video')[:src]
  end
end