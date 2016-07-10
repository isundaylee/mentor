class Segment < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, class_name: 'User'

  def self.insert(user, owner, date, st, ed)
    own = (user.id == owner.id)
    inter_own = Segment.where(user_id: user.id, date: date).where(owner_id: user.id)
    inter_non_own = Segment.where(user_id: user.id, date: date).where('owner_id != ?', user.id)
    set_own = SegmentSet.new
    set_non_own = SegmentSet.new

    inter_own.each { |i| set_own.insert(i.st, i.ed) }
    inter_non_own.each { |i| set_non_own.insert(i.st, i.ed) }

    if own
      set_own.insert(st, ed)
      inter_own.destroy_all

      set_own.canonical_form.each do |i|
        Segment.create!(user_id: user.id, owner_id: owner.id, st: i[0], ed: i[1], date: date)
      end

      return true
    else
      return false unless set_own.covered?(st, ed)
      return false unless set_non_own.vacant?(st, ed)

      Segment.create!(user_id: user.id, owner_id: owner.id, st: st, ed: ed, date: date)

      return true
    end
  end

  def self.remove(user, owner, date, st, ed)
    raise "Remove should only be used to remove availability segments. " unless user.id == owner.id

    inter_own = Segment.where(user_id: user.id, date: date).where(owner_id: user.id)
    inter_non_own = Segment.where(user_id: user.id, date: date).where('owner_id != ?', user.id)
    set_own = SegmentSet.new
    set_non_own = SegmentSet.new

    inter_own.each { |i| set_own.insert(i.st, i.ed) }
    inter_non_own.each { |i| set_non_own.insert(i.st, i.ed) }

    return false unless set_non_own.vacant?(st, ed)

    set_own.remove(st, ed)
    inter_own.destroy_all

    set_own.canonical_form.each do |i|
      Segment.create!(user_id: user.id, owner_id: owner.id, st: i[0], ed: i[1], date: date)
    end

    return true
  end

  def self.get_slots(user, date)
    inter_own = Segment.where(user_id: user.id, date: date).where(owner_id: user.id)
    inter_non_own = Segment.where(user_id: user.id, date: date).where('owner_id != ?', user.id)
    set_own = SegmentSet.new
    set_non_own = SegmentSet.new

    inter_own.each { |i| set_own.insert(i.st, i.ed) }
    inter_non_own.each { |i| set_non_own.insert(i.st, i.ed) }

    results = []

    0.upto(47) do |i|
      if set_non_own.include?(i)
        results << :reserved
      elsif set_own.include?(i)
        results << :available
      else
        results << :unavailable
      end
    end

    results
  end
end
