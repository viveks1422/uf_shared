class ProfileQuestion < ApplicationRecord
	belongs_to :basic_question
  	belongs_to :profile
  	belongs_to :user
end
