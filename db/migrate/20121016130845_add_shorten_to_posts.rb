class AddShortenToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :shorten, :text
    add_column :posts, :cut, :string
  end
end
