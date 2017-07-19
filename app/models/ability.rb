class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new # guest user (not logged in)
      if user.has_role?(:uf_admin)
        can :manage, :all
        can :manage, :rails_admin
      
      elsif user.has_role?(:uf_user)
        can :show, Profile, :user_id => user.id
        can :edit, Profile, :user_id => user.id
        can :update, Profile, :user_id => user.id
        can :create, Answer
        can :update_avatar, Profile
        # can :read, :all
      else
        # can :read, :all 
      end
      
  end
end
