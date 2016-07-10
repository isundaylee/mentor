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

  def mark_calendar
    date = Date.parse(params[:date])
    st = params[:st].to_i
    ed = params[:ed].to_i
    action = params[:action]

    intersections = @user.segments.where('(start_time <= ? AND ? <= end_time) OR (start_time <= ? AND ? <= end_time)', slot_center(date, st), slot_center(date, st), slot_center(date, ed), slot_center(date, ed))

    case action
    when 'reserved'
    when 'available'
    when 'unavailable'
    end
  end

  private
    def slot_start(day, slot)
      day.in_time_zone + (slot * 30).minutes
    end

    def slot_center(day, slot)
      slot_start(day, slot) + 15.minutes
    end

    def slot_end(day, slot)
      slot_start(day, slot). + 30.minutes
    end

    def fetch_user
      @user = User.find(params[:id])
    end
end
