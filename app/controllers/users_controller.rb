class UsersController < ApplicationController
  before_action :fetch_user

  def show
  end

  def remove_skill
    return redirect_to root_path, flash: {error: "You can only edit your own profile. "} unless current_user == @user

    skill = params[:skill]

    @user.skill_list.remove(skill)
    @user.save!

    redirect_to @user, flash: {success: "You have successfully removed the skill \"#{skill}\". "}
  end

  def add_skill
    return redirect_to root_path, flash: {error: "You can only edit your own profile. "} unless current_user == @user

    skill = params[:skill]

    @user.skill_list.add(skill)
    @user.save!

    redirect_to @user, flash: {success: "You have successfully added the skill \"#{skill}\" to your profile. "}
  end

  private
    def fetch_user
      @user = User.find(params[:id])
    end
end
