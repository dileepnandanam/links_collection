class AddVisitorIdToLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :visitor_id, :integer
  end
end
