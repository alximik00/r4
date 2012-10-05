class AddConfirmedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :confirmed, :boolean, :default=>false, :null=>false
    add_column :posts, :discarded, :boolean, :default=>false, :null=>false
  end
end
