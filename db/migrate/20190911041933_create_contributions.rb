class CreateContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :contributions do |t|
      t.string :contributable_type
      t.integer :contributable_id
      t.string :content
      t.integer :visitor_id

      t.timestamps
    end
  end
end
