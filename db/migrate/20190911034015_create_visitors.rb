class CreateVisitors < ActiveRecord::Migration[5.2]
  def change
    create_table :visitors do |t|
      t.string :ip
      t.string :user_agent
      t.timestamps
    end
  end
end
