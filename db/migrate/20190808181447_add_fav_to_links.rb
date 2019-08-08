class AddFavToLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :favourite, :boolean, default: false
  end
end
