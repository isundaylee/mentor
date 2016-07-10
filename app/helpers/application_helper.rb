module ApplicationHelper
  def slot_start_to_text(slot)
    (Date.today + (30 * slot).minutes).strftime("%l:%M %p").strip
  end

  def slot_end_to_text(slot)
    slot_start_to_text(slot + 1)
  end
end
