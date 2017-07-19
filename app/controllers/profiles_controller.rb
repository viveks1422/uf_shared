class ProfilesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_current_user
	def index
		@profile=@user.profile
		BasicQuestion.all.each do |basic|
			@profile.profile_questions << @profile.profile_questions.find_or_initialize_by({basic_question_id: basic.id})
		end
		respond_to do |format|
			format.json{render json: @profile, include: :profile_questions}
		end
	end
	def update
		@profile=@user.profile
		respond_to do |format|
			if @profile.update(profile_params)
				if params[:profile][:profile_questions].present? 
					params[:profile][:profile_questions].each do |key,question|
						question=question.blank? ? key : question
						profile_question=ProfileQuestion.find_or_initialize_by({basic_question_id: question[:basic_question_id], profile_id: @profile.id,user_id: @user.id})
						profile_question.answer=question[:answer]
						profile_question.save
					end
				end
				format.json{render json: @profile}
			else
				format.json{render json: @profile.error.full_messages}
			end
		end
	end
	# to verify mobile number

	def verify_number
		begin
			pin=@user.generate_pin
			twillio = Twilio::REST::Client.new
			# create message
			res=twillio.messages.create(
			  from: ENV['twillio_phone_number'],
			  to: @user.mobile,
			  body: "Verify your BalanceBueau mobile. Your pin is #{pin}"
			)
			respond_to do |format|
				format.json{render json: {message: 'Pin sent successfully'}}	
			end	
		rescue Twilio::REST::RequestError => e
			respond_to do |format|
				format.json{render json: {error: e}}	
			end
		end
		
		
	end
	# verify pin recieved
	def submit_pin
		begin
			pin=@user.pin
			# verify with database message
			if pin==params[:pin]
				@user.update_attribute(:verified, true)
				respond_to do |format|
					format.json{render json: {message: 'Pin verified successfully'}}	
				end
			else
				respond_to do |format|
					format.json{render json: {error: 'You have entered Wrong pin, please try again!'}}	
				end
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
		def profile_params
			params.require(:profile).permit(:title, :description,:facebook_account_url,:twitter_account_url,:google_account_url,:instagram_account_url)
		end
end
