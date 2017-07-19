class UserHeartsController < ApplicationController
	# before_action :authenticate_user!
	before_action :set_current_user
	def index
		@user_hearts=@user.user_hearts.order(:updated_at)
		# debugger
		# @user_hearts=@user_hearts.blank? ? @user.user_hearts.build({M: 24, M_1: 24, D: 24,P: 24,P_1: 24, FF: 24, L: 24, US: 24,G: 24}) : @user_hearts.first
		respond_to do |format|
			format.json{render json: @user_hearts, :include =>:relationship}
		end	
	end
	def create
		@user_heart=@user.user_hearts.build(user_heart_params)
		respond_to do |format|
			if @user_heart.save
				format.json{render json: @user_heart.reload, :include =>:relationship}
			else
				format.json{render json: {success: :false, notice: @user_heart.error.full_messages}}
			end
		end
	end
	def update
		@user_heart=@user.user_hearts.find(params[:id])
		respond_to do |format|
			if @user_heart.update_attributes(user_heart_params)
				format.json{render json: @user_heart}
			else
				format.json{render json: {success: :false, notice: @user_heart.error.full_messages}.to_json}
			end
		end		
	end
	def show
		respond_to do |format|
			if params[:id] && params[:id].to_i== 0
				if @user.user_hearts.present?
					current_relationship=@user.relationships.where({current: true}).order('ASC updated_at').first rescue {}
					
					if current_relationship.blank?
						relationship=@user.relationships.order(:updated_at).first rescue {}
						# debugger
						if relationship.present?
							@user_heart=relationship.user_heart.first rescue {}
							format.json{render json: (@user_heart.blank? ? (@user.user_hearts.order(:updated_at).first rescue {}) : @user_heart), :include =>:relationship}
						else
							@user_heart=@user.user_hearts.order(:updated_at).first
							format.json{render json: (@user_heart.blank? ? {} : @user_heart), :include =>:relationship}
						end
						
					else
						@user_heart=current_relationship.user_heart.first rescue {}
						format.json{render json: (@user_heart.blank? ? (@user.user_hearts.order(:updated_at).first rescue {}) : @user_heart), :include =>:relationship}
					end
				else
					format.json{render json: {}}
				end
				
			else
				@user_heart=@user.user_hearts.find(params[:id])
				format.json{render json: @user_heart, :include =>:relationship}
			end	
		end	
			
	end
	def destroy
		@user_heart=@user.user_hearts.find(params[:id])
		respond_to do |format|
			if @user_heart.destroy
				format.json{render json: @user_heart}
			else
				format.json{render json: {success: :false, notice: @user_heart.error.full_messages}.to_json}
			end
		end	
	end
	protected
		def user_heart_params
			params.require(:user_heart).permit(:US,:M,:M_1,:P_1,:G,:D,:L,:P,:FF,:relationship_id)
		end
		def set_current_user
			@user=User.find(params[:user_id])
		end
end
