class PaymentMethodsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_current_user
	def index
		# @customer=@user.customer_id
		Stripe.api_key = ENV['stripe_key']
		customer = Stripe::Customer.retrieve(@user.customer_id)
		cards=customer.sources.all(:object => "card")
		respond_to do |format|
			format.json{render json: {customer: customer, cards: cards.data}}
		end
	end
	def create
		# @customer=@user.customer_id
		begin
			params[:payment_method]
			Stripe.api_key = ENV['stripe_key']
			customer = Stripe::Customer.retrieve(@user.customer_id)
			customer.sources.create(source: params[:payment_method][:token])
			respond_to do |format|
				format.json{render json: customer}
			end	
		rescue Exception => e
			respond_to do |format|
				format.json{render json: {error: e}}
			end	
		end
		
	end
	# update card as default card
	def update
		begin
			Stripe.api_key = ENV['stripe_key']
			customer = Stripe::Customer.retrieve(@user.customer_id)
			customer.default_source=params[:id]
			customer.save
			respond_to do |format|
				format.json{render json: customer}
			end	
		rescue Exception => e
			respond_to do |format|
				format.json{render json: {error: e}}
			end	
		end
		
	end
	# remove card as default card
	def destroy
		begin
			Stripe.api_key = ENV['stripe_key']
			customer = Stripe::Customer.retrieve(@user.customer_id)
			customer.sources.retrieve(params[:id]).delete()
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
