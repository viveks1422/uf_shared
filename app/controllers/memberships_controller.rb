class MembershipsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_current_user
	def index
		@membership=@user.subscription_plan
		respond_to do |format|
			format.json{render json: @membership}
		end
	end
	# to update membership plan
	def update
		begin
			Stripe.api_key = ENV['stripe_key']
			customer = Stripe::Customer.retrieve(@user.customer_id)
			subscription=customer.subscriptions.data[0]
			subscription.plan= params[:id]
			subscription.save
			plan=SubscriptionPlan.find_by({plan_id: params[:id]})
			@user.subscription_plan_id=plan.id
			@user.save(validate: false)
			respond_to do |format|
				format.json{render json: customer}
			end	
		rescue Exception => e
			respond_to do |format|
				format.json{render json: {error: e}}
			end	
		end
	end
	protected
		def set_current_user
			@user=current_user
		end
end
