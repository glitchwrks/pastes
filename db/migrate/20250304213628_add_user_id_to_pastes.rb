class AddUserIdToPastes < ActiveRecord::Migration[8.0]
  def up
    add_column :pastes, :user_id, :string, :limit => 36, :null => false
    add_index :pastes, :user_id
  end

  def down
    remove_column :pastes, :user_id
  end
end
