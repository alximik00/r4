class Post < ActiveRecord::Base
  LANG_RUBY = 1
  LANG_ERB = 2
  LANG_HAML = 3
  LANG_JS = 4
  LANG_SHELL = 5
  LANG_C = 6

  LANGS = {}.with_indifferent_access

  self.constants(false).each do |const|
    const = const.to_s
    if const.starts_with?("LANG_")
      lang_name = const.gsub(/^LANG_/, '') .downcase
      LANGS[lang_name] = self.const_get(const)
    end
  end

  belongs_to :user
  attr_accessor :user_email

  validates_presence_of :description, :title, :body

  def decided?
    self.confirmed? && self.discarded?
  end

  def self.lang_by_id(id)
    lang,_ = LANGS.detect {|k,v| v.to_s == id.to_s}
    lang
  end

end
