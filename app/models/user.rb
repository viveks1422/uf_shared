# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  first_name             :string
#  last_name              :string
#  image                  :string
#  email                  :string
#  relation_status        :string
#  location               :string
#  mobile                 :string
#  gender                 :string
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  rolify
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  mount_uploader :image, ImageUploader
  # associations
  has_one :profile, dependent: :destroy
  has_many :user_hearts, dependent: :destroy
  has_many :item_lists, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :profile_questions, dependent: :destroy
  has_many :basic_questions, through: :profile_questions
  belongs_to :subscription_plan
  #validations
  validates :first_name, length: { maximum: 200 }
  validates :last_name, length: { maximum: 200 }
  validates :email, length: { maximum: 200 }
  validates :relation_status, length: { maximum: 200 }
  validates :location, length: { maximum: 200 }
  validates :mobile, length: { maximum: 15 }
  validates :gender, length: { maximum: 20 }
  validates :provider, length: { maximum: 50 }
  validates :customer_id, length: { maximum: 100 }
  validates :subscription_plan_id, length: { maximum: 200 }
  # callbacks
  after_create :set_profile
  after_save :mobile_changed
  # to set profile for the first time
  def set_profile
    self.build_profile.save
  end
  # to make verified false for new mobile update
  def mobile_changed
    if mobile_changed?
      # self.verified=false 
      self.update_column(:verified, false)
    end
  end
  # generate pin to verify mobile number
  def generate_pin
    self.pin = rand(0000..9999).to_s.rjust(4, "0")
    save
    self.pin
  end
  # after confirmation callback
  def after_confirmation
    begin
    	UserMailer.welcome(self).deliver!
      self.add_role :member
      Stripe.api_key = ENV['stripe_key']
      customer=Stripe::Customer.create({email: self.email})
    	# build profile
    	self.build_profile
      #update subscription plan detail
      plan=SubscriptionPlan.find_by({plan_id: 'basic'})
      self.customer_id=customer.id
      self.subscription_plan_id=plan.try(:id)
      self.subscription_start=Date.today
      # subscription create
      Stripe::Subscription.create(
        :customer => customer.id,
        :plan => plan.plan_id
      )
      self.save(validate: false)
    rescue Exception => e
     	puts "Error: #{e}"
    end
  end
  # name method
  def name
    if first_name.blank? && last_name.blank?
      email
    else
      [first_name,last_name].join(' ')
    end
  end
end
