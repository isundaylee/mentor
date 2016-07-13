class PagesController < ApplicationController
  def explore
    @mentors = User.all
    @events = Event.all

    tag = params[:tag]

    if tag.present?
      @events = @events.tagged_with(tag)
      @mentors = @mentors.tagged_with(tag)
    end
  end
end
