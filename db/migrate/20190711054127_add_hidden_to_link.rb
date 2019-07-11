class AddHiddenToLink < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :hidden, :boolean, default: false
  end
end
