class Event < ActiveRecord::Base
  default_scope -> { order('start_time ASC')}

  belongs_to :user
  has_many :participations

  validates :title, presence: true, length: {minimum: 1, maximum: 200}
  validates :description, presence: true, length: {minimum: 10, maximum: 2000}
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :rate, presence: true, numericality: {minimum: 0.5}

  validates :date, presence: true

  before_validation :set_dates

  acts_as_taggable_on :skills

  def date
    @date ||= start_time.try(:to_date)
  end

  def start_minute
    return 0 if (@start_minute.nil? && start_time.nil?)
    @start_minute ||= ((start_time - date.in_time_zone) / 60).to_i
  end

  def end_minute
    return 0 if (@end_minute.nil? && end_time.nil?)
    @end_minute ||= ((end_time - date.in_time_zone) / 60).to_i
  end

  def date=(date)
    begin
      @date = date.to_date
    rescue ArgumentError
      @date = nil
    end
  end

  def start_minute=(min)
    @start_minute = min.to_i
  end

  def end_minute=(min)
    @end_minute = min.to_i
  end

  def same_day?
    self.start_time.to_date == self.end_time.to_date
  end

  def location_is_url?
    self.location =~ /^http/
  end

  private
    def set_dates
      return if date.nil?
      self.end_minute += 60 * 24 if self.end_minute <= self.start_minute

      self.start_time = date + start_minute.minutes
      self.end_time = date + end_minute.minutes
    end
end
