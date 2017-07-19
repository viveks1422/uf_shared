class HomeController < ApplicationController
  
  def index
  	render '/layouts/application.html'
  end
  def main
 	 	
  end
  def about
  	respond_to do |format|
  	  	format.html{render :json=>@json}
  	end
  end
  
end
