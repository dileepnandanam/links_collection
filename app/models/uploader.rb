class Uploader
	def self.upload
		urls = Dir.entries('/Users/Dileep/xlinks_folder').select{ |f| f.include? "link-" }.map{|f| 
			File.open("/Users/Dileep/xlinks_folder/#{f}").read.strip
		}.join(',')

		Net::HTTP.post_form(URI.parse("http://localhost:3000/links"), {link: {url: urls}})
	end
end