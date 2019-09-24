class AddLastSenToVisitors < ActiveRecord::Migration[5.2]
  def change
    add_column :visitors, :last_seen, :datetime
  end
end
