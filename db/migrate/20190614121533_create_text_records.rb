class CreateTextRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :text_records do |t|
      t.string :name
      t.text :value
    end
  end
end
