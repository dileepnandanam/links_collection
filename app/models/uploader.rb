class Uploader
	def self.upload
		Dir.entries('/Users/Dileep/xlinks_folder').select{ |f| f.include? "link-" }.each_slice(4).each{ |chunk|
			urls = chunk.map {|f|
				File.open("/Users/Dileep/xlinks_folder/#{f}").read.strip
			}.join(',')
			Net::HTTP.post_form(URI.parse("http://xlinks.herokuapp.com/links"), {'link[url]' => urls})
		}
		
		Dir.entries('/Users/Dileep/xlinks_folder').select{ |f| f.include? "link-" }.map{|f| 

			File.delete "/Users/Dileep/xlinks_folder/#{f}"
		}
	end
end