class CreateQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :queries do |t|
      t.integer :visitor_id
      t.string :key

      t.timestamps
    end
  end
end
