class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      redirect_to current_user, flash: {success: "You have successfully created the event \"#{@event.title}\". "}
    else
      render 'new'
    end
  end

  private
    def event_params
      params.require(:event).permit(:title, :description, :location, :date, :start_minute, :end_minute, :rate)
    end
end
