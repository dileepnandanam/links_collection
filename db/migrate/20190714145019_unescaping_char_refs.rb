class UnescapingCharRefs < ActiveRecord::Migration[5.2]
  def up
  	Link.all.each do |link|
      if link.name.to_s.include?('&')
        link.update(name: MassEntry.escape_unescapable(link.name.to_s))
      end
  	end
  end

  def down
  end
end
