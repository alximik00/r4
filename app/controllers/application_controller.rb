class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :is_admin?
  def is_admin?
    true
  end

  helper_method :menu_urls
  def menu_urls
    urls = {
        posts_path => 'Home',
        posts_popular_path => 'Most read',
        home_about_path => 'About',
    }

    admin_urls = {}
    if is_admin?
      admin_urls[posts_all_path] =   'All'
      admin_urls[new_post_path] = 'New post'
    end

    {:menu=>urls, :admin_menu=>admin_urls }
  end
end
