require 'uv'

class HomeController < ApplicationController
  def index
    text = File.read( File.join(Rails.root,'app', 'assets', 'sample.rb' ) )
    @sample = Uv.parse( text, "xhtml", "ruby", true, "twilight")
    render 'home/index'
  end

  def about
  end
end
