require 'uv'

class AddPreviews < ActiveRecord::Migration
  def up
    Post.all.each do |post|
      lang = Post.lang_by_id(post.lang_id).to_s.downcase

      preview = Uv.parse( post.raw_body || post.body, "xhtml", lang, false, "twilight")
      post.preview_text = preview.each_line.take(10).join
      post.save(:validate=>false)
    end
  end

  def down
  end
end
