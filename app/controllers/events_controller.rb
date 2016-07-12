class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      current_user.join!(@event)
      redirect_to current_user, flash: {success: "You have successfully created the event \"#{@event.title}\". "}
    else
      render 'new'
    end
  end

  def join
    return redirect_to root_path, flash: {error: 'You have to be signed in. '} unless signed_in?

    event = Event.find(params[:id])

    return redirect_to event.user, flash: {error: "You don't have enough tokens left. "} unless current_user.balance >= event.rate

    current_user.balance -= event.rate
    current_user.save!
    event.user.balance += event.rate
    event.user.save!

    current_user.join!(event)

    return redirect_to event.user, flash: {success: "You have successfully joined the event. "}
  end

  private
    def event_params
      params.require(:event).permit(:title, :description, :location, :date, :start_minute, :end_minute, :rate, :skill_list)
    end
end
