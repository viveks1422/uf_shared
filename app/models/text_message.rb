class TextMessage < ApplicationRecord
	validates :key, presence: true, length: { maximum: 200 }
	validates :message, presence: true, length: { maximum: 500 } 
end
