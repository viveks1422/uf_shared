class Profile < ApplicationRecord
  belongs_to :user
  has_many :profile_questions, dependent: :destroy
  has_many :basic_questions, through: :profile_questions
  # validations
  validates :user, presence: true
  accepts_nested_attributes_for :profile_questions
end
