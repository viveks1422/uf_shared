class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :set_current_user
	def index
		user_roles=@user.roles
		respond_to do |format|
			format.json{render json: user_roles}
		end	
	end
	protected
		def set_current_user
			@user=current_user	
		end
end
