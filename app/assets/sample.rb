class HomeController < ApplicationController
  def index
    @sample = File.read( File.join(Rails.root,'assets', 'sample.rb' ) )
    render 'home/index'
  end
end
