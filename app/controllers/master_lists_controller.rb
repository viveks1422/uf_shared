class MasterListsController < ApplicationController
	before_action :authenticate_user!
	def index
		@master_lists=params[:parent_id].present? ? MasterList.all.where({parent_id: params[:parent_id]}) : MasterList.all
		respond_to do |format|
			format.json{render json: @master_lists}
		end
	end
	def add_from_master_list
		master_list=MasterList.find(params[:id])
		user=User.find(params[:user_id])
		item_lists=master_list.item_lists.where({user_id: user.id}) rescue []
		respond_to do |format|
			if item_lists.blank?
				item_list=user.item_lists.build({content: master_list.content, list_type: master_list.list_type, master_list_id: master_list.id})
				item_list.save
				format.json{render json: item_list.reload}
			else
				format.json{render json: {status: false, message: 'Item already present'}}
			end
		end
	end
end
