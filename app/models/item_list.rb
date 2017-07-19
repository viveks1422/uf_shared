# == Schema Information
#
# Table name: item_lists
#
#  id             :integer          not null, primary key
#  list_type      :integer
#  content        :text
#  user_id        :integer
#  sub_category_id :integer
#  position       :integer
#  star           :boolean          default("false")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ItemList < ApplicationRecord
	# assocaitions
	belongs_to :user
	belongs_to :sub_category
	#validations
  	validates :content, presence: true, length: { maximum: 500 }
  	validates :user, presence: true
  	validates :sub_category, presence: true
end
