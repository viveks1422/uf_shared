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

class Category < ApplicationRecord
	# associations
	belongs_to :user
	self.table_name = "master_lists"
	has_many :sub_categories, foreign_key: :parent_id, dependent: :destroy
	# callbacks
	after_create :set_category
	default_scope { where(category_type: 'Main') }
	#validations
  	validates :content, presence: true, length: { maximum: 200 }, uniqueness: true
  	validates :list_type, presence: true, length: { maximum: 1 }
  	# validates :user, presence: true
	# setting category 
	def set_category
		self.category_type="Main"
		self.save
	end
	# name method specially for rails admin
	def name
		self.content
	end
end
