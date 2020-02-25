class AddNsfwToLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :nsfw, :boolean, default: :fault
  end
end
