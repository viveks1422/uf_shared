# == Schema Information
#
# Table name: user_hearts
#
#  id         :integer          not null, primary key
#  US         :integer
#  M          :integer
#  M_1        :integer
#  FF         :integer
#  P          :integer
#  P_1        :integer
#  G          :integer
#  D          :integer
#  L          :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserHeart < ApplicationRecord
  belongs_to :user
  belongs_to :relationship
end
