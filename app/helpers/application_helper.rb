module ApplicationHelper
  def slot_start_to_text(slot)
    time_str((Date.today + (30 * slot).minutes))
  end

  def slot_end_to_text(slot)
    slot_start_to_text(slot + 1)
  end

  def minute_select_options(prefix)
    (0..47).map do |i|
      time = Date.today + (30 * i).minutes
      [prefix + time_str(time), 30 * i]
    end
  end

  def time_str(time)
    time.strftime("%l:%M %p").strip
  end

  def date_str(time)
    time.strftime("%Y/%m/%d")
  end
end
