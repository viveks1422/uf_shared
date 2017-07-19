class SubscriptionPlan < ApplicationRecord
	# validations
	validates :plan_id, presence: true, length: { maximum: 200 }, uniqueness: true
	validates :name, presence: true, length: { maximum: 200 }, uniqueness: true
	validates :amount, presence: true, length: { maximum: 200 }
	validates :trial, length: { maximum: 20 }
	validates :tenure, presence: true,length: { maximum: 20 }
end
