class AddProfileDataToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :country, :string, default: 'India'
    add_column :users, :looking_for, :string, default: 'female'
    add_column :users, :orientation, :string, default: 'lesbian'
    add_column :users, :age, :integer, default: '18'
    add_column :users, :interests, :text
  end
end
