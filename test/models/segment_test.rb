require 'test_helper'

class SegmentSetTest < ActiveSupport::TestCase
  test "SegmentSet works" do
    set = SegmentSet.new

    set.insert(1, 3)
    set.insert(6, 9)
    set.insert(4, 5)

    c = set.canonical_form

    assert_equal(1, c.size)
    assert_equal([1, 9], c[0])

    set.remove(2, 3)

    c = set.canonical_form

    assert_equal(2, c.size)
    assert_equal([1, 1], c[0])
    assert_equal([4, 9], c[1])
  end
end

class SegmentTest < ActiveSupport::TestCase
  def setup
    @user_a = User.create!
    @user_b = User.create!
    @user_c = User.create!

    @date = Date.today
  end

  test "basic owner insert works" do
    Segment.destroy_all

    Segment.insert(@user_a, @user_a, @date, 2, 4)

    assert_same(1, Segment.count)
    assert_same(2, Segment.all.to_a[0].st)
    assert_same(4, Segment.all.to_a[0].ed)
  end

  test "fusing owner insert works" do
    Segment.destroy_all

    Segment.insert(@user_a, @user_a, @date, 2, 4)
    Segment.insert(@user_a, @user_a, @date, 8, 9)
    Segment.insert(@user_a, @user_a, @date, 5, 7)

    assert_same(1, Segment.count)
    assert_same(2, Segment.all.to_a[0].st)
    assert_same(9, Segment.all.to_a[0].ed)
  end

  test "overlapping owner insert works" do
    Segment.destroy_all

    Segment.insert(@user_a, @user_a, @date, 2, 4)
    Segment.insert(@user_a, @user_a, @date, 8, 9)
    Segment.insert(@user_a, @user_a, @date, 3, 9)

    assert_same(1, Segment.count)
    assert_same(2, Segment.all.to_a[0].st)
    assert_same(9, Segment.all.to_a[0].ed)
  end

  test "non-owner insert unavailable does not work" do
    Segment.destroy_all

    Segment.insert(@user_a, @user_a, @date, 1, 3)

    assert_same(false, Segment.insert(@user_a, @user_b, @date, 2, 4))
  end

  test "non-owner insert reserved does not work" do
    Segment.destroy_all

    Segment.insert(@user_a, @user_a, @date, 1, 7)
    Segment.insert(@user_a, @user_b, @date, 1, 2)

    assert_same(false, Segment.insert(@user_a, @user_b, @date, 2, 4))
  end

  test "non-owner insert available works" do
    Segment.destroy_all

    Segment.insert(@user_a, @user_a, @date, 1, 7)
    assert_same(true, Segment.insert(@user_a, @user_b, @date, 2, 3))

    assert_same(2, Segment.count)
    assert_same(2, Segment.last.st)
    assert_same(3, Segment.last.ed)
    assert_same(@user_b.id, Segment.last.owner_id)
  end

  test "owner remove reserved should not work" do
    Segment.destroy_all

    Segment.insert(@user_a, @user_a, @date, 1, 7)
    Segment.insert(@user_a, @user_b, @date, 2, 3)

    assert_same(false, Segment.remove(@user_a, @user_a, @date, 2, 2))
  end

  test "owner remove should work" do
    Segment.destroy_all

    Segment.insert(@user_a, @user_a, @date, 1, 7)
    assert_same(true, Segment.remove(@user_a, @user_a, @date, 3, 4))

    assert_same(2, Segment.count)

    assert_same(1, Segment.first.st)
    assert_same(2, Segment.first.ed)

    assert_same(5, Segment.last.st)
    assert_same(7, Segment.last.ed)
  end
end
