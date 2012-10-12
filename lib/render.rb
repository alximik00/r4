module Render
  def self.render_html(text)
    @@markdown ||= Redcarpet::Markdown.new(::HtmlxWithAlbino,
                                       :autolink => true,
                                       :fenced_code_blocks => true,
                                       :space_after_headers => true)
    @@markdown.render(text)
  end
end