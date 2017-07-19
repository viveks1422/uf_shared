class SubCategoriesController < ApplicationController
	before_action :authenticate_user!
	def index
		@categories=params[:parent_id].present? ? SubCategory.all.where({parent_id: params[:parent_id]}) : SubCategory.all
		respond_to do |format|
			format.json{render json: @categories}
		end
	end
	# add from master list
	def add_from_sub_category
		sub_category=SubCategory.find(params[:id])
		user=User.find(params[:user_id])
		item_lists=sub_category.item_lists.find_by({content: sub_category.content, user_id: user.id})

		respond_to do |format|
			if item_lists.blank?
				item_list=user.item_lists.build({content: sub_category.content, list_type: sub_category.list_type, sub_category_id: sub_category.id, active: true})
				item_list.save
				format.json{render json: {success: true, removed: false, item_list: item_list.reload}}
			else
				item_list_return=item_lists
				item_lists.destroy
				format.json{render json: {success: true, removed: true, item_list: item_list_return}}
			end
		end
	end
		
end
