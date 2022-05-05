# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin?
        can :manage, :all
      elsif user.host?
        can [:read, :profile], User
        can [:read, :create], [Home, Pet]
        can [:update, :destroy], [Home, Pet] do |item| 
          item.user == user
        end
      elsif user.guest?
        can [:read, :profile], [Home, User]
        can :create, Pet
        can [:read, :update, :destroy], Pet do |item|
          item.user == user
        end
      end
    else
      can :read, [Home, User]
    end
  end
end
