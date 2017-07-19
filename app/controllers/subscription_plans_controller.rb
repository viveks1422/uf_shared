class SubscriptionPlansController < ApplicationController
	before_action :authenticate_user!
	def index
		@membership_plans=SubscriptionPlan.all.reverse
		respond_to do |format|
			format.json{render json: @membership_plans}
		end
	end
end
