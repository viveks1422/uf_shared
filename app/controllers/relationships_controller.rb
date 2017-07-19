class RelationshipsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_current_user
	def index
		@relationship=@user.relationships
		respond_to do |format|
			format.json{render json: @relationship, :include =>:user_heart}
		end	
	end
	def create

		@relationship=@user.relationships.build(relationship_params)
		respond_to do |format|
			if @relationship.save
				format.json{render json: @relationship.reload, :include =>:user_heart}
			else
				format.json{render json: {success: :false, notice: @relationship.errors.full_messages}}
			end
		end	
	end
	def update
		@relationship=@user.relationships.find(params[:id])
		respond_to do |format|
			if @relationship.update_attributes(relationship_params)
				format.json{render json: @user.relationships, :include =>:user_heart}
			else
				format.json{render json: {success: :false, notice: @relationship.errors.full_messages}.to_json}
			end
		end		
	end
	def destroy
		@relationship=@user.relationships.find(params[:id])
		respond_to do |format|
			if @relationship.destroy
				format.json{render json: {success: :true, relationship: @relationship}}
			else
				format.json{render json: {success: :false, notice:@relationship.error.full_messages}}
			end
		end	
	end
	protected
		def relationship_params
			params.require(:relationship).permit(:person,:start_date,:end_date,:gender,:current)
		end
		def set_current_user
			@user=User.find(params[:user_id])
		end
end
