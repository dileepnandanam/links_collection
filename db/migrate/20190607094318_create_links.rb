class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.text :url
      t.text :name
      t.string :tags
      t.string :text

      t.timestamps
    end
  end
end
