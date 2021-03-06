class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    alias_action :create, :read, :update, :destroy, :to => :crud
    alias_action :read, :attend, :cancel, :attend_recurring, :stop_attend_recurring, :photo, :to => :normal_user_event_action
    alias_action :index, :show, :avatar, :upload_avatar, :events, :to => :user_action

    user ||= User.new() # guest user (not logged in)
    
    if user.super_admin?
        can :manage, :all
    elsif user.admin?
        can [:crud, :loadmore] , Comment
        can [:normal_user_event_action, :finish, :new_finish, :edit_finish, :update_finish], Event
        can :user_action, User, id: user.id
    elsif user.normal?
        if user.id? # user who signed in
            can [:crud, :loadmore], Comment
            can [:normal_user_event_action], Event
            can :user_action, User, id: user.id
        else # visitor who not sign in
            can [:loadmore], Comment
            can :read, Event
        end
    end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
 
end
