class Relationship < ApplicationRecord
  belongs_to :user
  has_many :user_heart, dependent: :destroy
  # validations
  validates :person, presence: true, length: { maximum: 200 }
  validates :start_date, presence: true, length: { maximum: 50 }
  validates :end_date, length: { maximum: 50 }
  validates :user, presence: true, length: { maximum: 100 }
  validates :gender, presence: true, length: { maximum: 50 }
end
