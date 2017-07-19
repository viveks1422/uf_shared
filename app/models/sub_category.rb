# == Schema Information
#
# Table name: master_lists
#
#  id         :integer          not null, primary key
#  content    :text
#  list_type  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SubCategory < ApplicationRecord
	# associations
	belongs_to :user
	self.table_name = "master_lists"
	belongs_to :user
  	has_many :item_lists, dependent: :destroy
 	 LIST_TYPES = ['looking for love','Love List', 'All about me']
	belongs_to :category, foreign_key: :parent_id 
	# callbacks
	after_create :set_category
	# scopes
	default_scope { where(category_type: 'Sub') }
	#validations
  	validates :content, presence: true, length: { maximum: 200 }
  	# validates :list_type, presence: true, length: { maximum: 1 }
  	# validates :user, presence: true
	def set_category
		self.category_type="Sub"
		self.user_id=self.category.user_id
		self.list_type=self.category.list_type
		self.save
	end
	# name method specially for rails admin
	def name
		self.content
	end
end