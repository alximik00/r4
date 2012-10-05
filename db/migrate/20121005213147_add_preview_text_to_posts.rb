class AddPreviewTextToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :preview_text, :text
  end
end
