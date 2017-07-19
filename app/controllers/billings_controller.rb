class BillingsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_current_user
	def index
		Stripe.api_key = ENV['stripe_key']
		customer=@user.customer_id
		billings = Stripe::Charge.list(customer: customer)
		respond_to do |format|
			format.json{render json: billings.data}
		end
	end
	protected
		def set_current_user
			@user=current_user
		end
end
