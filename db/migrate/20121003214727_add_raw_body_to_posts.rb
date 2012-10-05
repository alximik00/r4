class AddRawBodyToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :raw_body, :text
  end
end
