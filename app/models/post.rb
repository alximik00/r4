class Post < ActiveRecord::Base
  belongs_to :user

  attr_accessor :user_email
end
