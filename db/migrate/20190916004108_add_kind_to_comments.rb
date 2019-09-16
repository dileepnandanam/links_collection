class AddKindToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :kind, :string, default: 'postresponse'
  end
end
