class CategoriesController < ApplicationController
	before_action :authenticate_user!
	def index
		@categories=params[:list_type].present? ? Category.all.where({list_type: params[:list_type]}) : Category.all
		respond_to do |format|
			format.json{render json: @categories, include: :sub_categories}
		end
	end
end
