class CreateFeatureTags < ActiveRecord::Migration[5.2]
  def change
    create_table :feature_tags do |t|
      t.string :name
      t.string :tag

      t.timestamps
    end
  end
end
