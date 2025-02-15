class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, :id => false do |t|
      t.string :id, :limit => 36, :primary_key => true, :null => false
      t.string :login
      t.string :password_digest
      t.timestamps
    end
  end
end
