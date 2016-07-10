class UsersController < ApplicationController
  before_action :fetch_user

  def show
    @week_offset = params[:week_offset].to_i
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

  def set_rate
    return redirect_to root_path, flash: {error: "You can only set your own rate. "} unless current_user == @user

    @user.rate = params[:rate].to_f
    @user.save!

    redirect_to @user, flash: {success: "You have successfully set your rate to %0.1f tokens per hour. " % @user.rate}
  end

  def mark_calendar
    return redirect_to root_path, flash: {error: "You need to be signed in. "} unless signed_in?

    date = Date.parse(params[:date])
    st = params[:st].to_i
    ed = params[:ed].to_i
    action = params[:mark_as]

    st, ed = ed, st if st > ed

    case action
    when 'reserved'
      return redirect_to @user, flash: {error: "You shouldn't reserve your own time slots. "} if @user.id == current_user.id

      price = @user.rate * 0.5 * (ed - st + 1)
      return redirect_to @user, flash: {error: "You don't have enough tokens left to reserve this slot. "} if current_user.balance <= price

      return redirect_to @user, flash: {error: "Cannot reserve slots. "} unless Segment.insert(@user, current_user, date, st, ed)

      current_user.balance -= price
      current_user.save!
      @user.balance += price
      @user.save!

      return redirect_to @user, flash: {success: "You have successfully reserved the slots! "}
    when 'available'
      return redirect_to @user, flash: {error: "You can only mark your own time slots available. "} unless @user.id == current_user.id
      return redirect_to @user, flash: {error: "Cannot mark slots as available. "} unless Segment.insert(@user, current_user, date, st, ed)
      return redirect_to @user, flash: {success: "You have successfully marked the slots as available! "}
    when 'unavailable'
      return redirect_to @user, flash: {error: "You can only mark your own time slots unavailable. "} unless @user.id == current_user.id
      return redirect_to @user, flash: {error: "Cannot mark slots as unavailable. "} unless Segment.remove(@user, current_user, date, st, ed)
      return redirect_to @user, flash: {success: "You have successfully marked the slots as unavailable! "}
    end

    raise "Unexpected action: #{action}. "
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
