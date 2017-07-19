class BasicQuestion < ApplicationRecord
	validates :question, presence: true, length: { maximum: 400 }
	has_many :profile_questions, dependent: :destroy
  	has_many :profiles, through: :profile_questions
  	has_many :users, through: :profile_questions
end
