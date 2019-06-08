class AddSourceToLink < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :source_url, :text
  end
end
