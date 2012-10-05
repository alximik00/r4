class AddLangIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :lang_id, :integer
  end
end
