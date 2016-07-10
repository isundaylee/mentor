class SegmentSet
  def initialize
    @set = Set.new
  end

  def insert(st, ed)
    st.upto(ed) do |i|
      @set.add(i)
    end
  end

  def remove(st, ed)
    st.upto(ed) do |i|
      @set.delete?(i)
    end
  end

  def vacant?(st, ed)
    st.upto(ed) do |i|
      return false if @set.include?(i)
    end

    return true
  end

  def covered?(st, ed)
    st.upto(ed) do |i|
      return false unless @set.include?(i)
    end

    return true
  end

  def include?(i)
    @set.include?(i)
  end

  def canonical_form
    st = @set.min
    ed = @set.max

    return [] if st.nil? # empty

    results = []
    curr_st = st

    st.upto(ed) do |i|
      if @set.include?(i)
        curr_st ||= i
      else
        results << [curr_st, i - 1] if curr_st.present?
        curr_st = nil
      end
    end

    results << [curr_st, ed] if curr_st.present?

    results
  end
end