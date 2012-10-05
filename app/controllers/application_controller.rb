class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :is_admin?
  def is_admin?
    true
  end

  helper_method :menu_urls
  def menu_urls
    @menu_urls ||= {
        posts_path => 'Home',
        posts_popular_path => 'Popular',
        home_about_path => 'About',
        new_post_path => 'Suggest new'
    }
  end
end
