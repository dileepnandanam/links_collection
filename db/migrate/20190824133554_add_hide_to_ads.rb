class AddHideToAds < ActiveRecord::Migration[5.2]
  def change
    add_column :ads, :hide, :boolean, default: false
  end
end
