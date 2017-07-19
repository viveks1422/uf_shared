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

class MasterList < ApplicationRecord
 	# assocations	
  belongs_to :user
  belongs_to :sub_category, foreign_key: :parent_id
  has_many :item_lists, dependent: :destroy
  LIST_TYPES = ['looking for love','Love List', 'All about me']
  # callbacks
  after_create :set_category
  # scopes
  default_scope { where(category_type: 'Subsub') }
  #validations
  validates :content, presence: true, length: { maximum: 200 }
  # validates :list_type, presence: true, length: { maximum: 1 }
  # validates :user, presence: true
  # methods
  def set_category
    debugger
		self.category_type="Subsub"
		self.list_type=self.sub_category.list_type
		self.user_id=self.sub_category.user_id
		self.save
	end
	# name method specially for rails admin
	def name
		self.content
	end
end
