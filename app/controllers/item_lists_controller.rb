class ItemListsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_current_user
	def index
		@item_lists=@user.item_lists
		@item_lists=@item_lists.where({list_type: params[:type]}) if params[:type].present?
		respond_to do |format|
			format.json{render json: @item_lists.order(:position)}
		end
	end
	def create
		@item_list=@user.item_lists.build(item_list_params)
		respond_to do |format|
			if @item_list.save(validate: false)
				format.json{render json: {success: :true, item_list: @item_list}}
			else
				format.json{render json: {success: :false, notice: @item_list.errors.full_messages}}
			end
		end
	end
	def update
		@item_list=@user.item_lists.find(params[:id])
		if params[:item_list][:all_items].present?
			respond_to do |format|
				params[:item_list][:all_items].each_with_index do |item_list,index|
					# puts index
					item_list_obj=ItemList.find(item_list[:id])
					item_list_obj.position=index
					item_list_obj.save(validate: false) 
				end	
				format.json{render json: {success: :true, item_list: @item_list}}
				
			end
		else
			respond_to do |format|
				if @item_list.update_attribute('active', item_list_params[:active])
					format.json{render json: {success: :true, item_list: @item_list}}
				else
					format.json{render json: {success: :false, notice: @item_list.error.full_messages}}
				end
			end
		end
	end
	def destroy
		@item_list=@user.item_lists.find(params[:id])
		@item_list.destroy
		respond_to do |format|
			if @item_list.destroy
				format.json{render json: {success: :true, item_list: @item_list}}
			else
				format.json{render json: {success: :false, notice: @item_list.error.full_messages}}
			end
		end
	end
	protected
		def item_list_params
			params.require(:item_list).permit(:active,:added_item,:list_type, :content, :master_list_id, :position,:star,:sub_category_id)
		end
		def set_current_user
			@user=User.find(params[:user_id])
		end
end
