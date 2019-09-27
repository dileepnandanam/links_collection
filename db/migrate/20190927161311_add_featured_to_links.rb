class AddFeaturedToLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :featured, :boolean
  end
end
