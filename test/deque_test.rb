require 'minitest'
require 'minitest/autorun'

require_relative '../lib/deque.rb'

class DequeTest < Minitest::Test
  def test_new
    assert_equal Deque.new, Deque[]
    assert_equal Deque.new([]), Deque[]
    assert_equal Deque.new([1, 2, 3]), Deque[1, 2, 3]

    assert_equal Deque.new([5, 5, 5]), Deque.new(3, 5)
  end

  def test_size
    d = Deque[]
    assert_equal 0, d.size
    d.pop
    assert_equal 0, d.size
    d.shift
    assert_equal 0, d.size
    d.push(2)
    assert_equal 1, d.size
    d.unshift(nil)
    assert_equal 2, d.size
    d.push('a')
    assert_equal 3, d.size
    d.pop
    assert_equal 2, d.size
    d.shift
    assert_equal 1, d.size
  end

  def test_empty?
    d = Deque[]
    assert d.empty?
    d.push(1)
    refute d.empty?

    d = Deque[1, 2, 3]
    refute d.empty?
    d.shift
    d.pop
    d.shift
    assert d.empty?
  end

  def test_unshift
    d = Deque[]
    assert_equal Deque[1], d.unshift(1)
    assert_equal Deque[2, 1], d.unshift(2)
    assert_equal Deque[3, 2, 1], d.prepend(3)
  end

  def test_push
    d = Deque[1, 2, 3]
    assert_equal Deque[1, 2, 3, 4], d.push(4)
    assert_equal Deque[1, 2, 3, 4, 5, 6], d.push(5, 6)
    d.unshift(99)
    d.unshift(98)
    assert_equal Deque[98, 99, 1, 2, 3, 4, 5, 6], d
  end

  def test_pop
    d = Deque[1, 2, 3]
    assert_equal 3, d.last
    assert_equal 3, d.pop
    assert_equal 2, d.pop
    assert_equal 1, d.pop
  end

  def test_pop_empty
    d = Deque[]
    assert_nil d.pop
  end

  def test_shift
    d = Deque[1, 2, 3]
    assert_equal 1, d.shift
    assert_equal 2, d.shift
    assert_equal 3, d.shift
  end

  def test_empty_shift
    d = Deque[1, 2, 3]
    assert_equal 1, d.shift
    assert_equal 2, d.shift
    assert_equal 3, d.shift
    assert_nil d.shift
    assert_nil d.shift

    d = Deque[]
    assert_nil d.shift
    assert_nil d.shift
  end

  def test_slice1
    d = Deque[:a, :b, :c, :d]
    assert_equal :d, d.slice(-1)
    assert_equal :d, d[-1]
    assert_equal :a, d[-4]
    assert_equal :b, d[1]
    assert_equal :b, d.at(1)
    assert_equal :c, d[2]
    d.push(:e)
    d.unshift(:z)
    assert_equal :a, d[1]
  end

  def test_slice_out_of_range
    d = Deque[]
    assert_nil d[0]
    assert_nil d[-1]
  end

  def test_slice_range
    d = Deque[:a, :b, :c, :d]
    assert_equal Deque[:b, :c], d[1..2]
    assert_equal Deque[:b, :c], d[1...3]
    assert_equal Deque[:d], d[-1..-1]
    d.shift
    assert_equal Deque[:c, :d], d[-2..-1]
  end

  def test_slice_assignment
    d = Deque[:a, :b, :c, :d]
    d[0] = 10
    assert_equal Deque[10, :b, :c, :d], d
    d[-1] = 40
    assert_equal Deque[10, :b, :c, 40], d
    d.pop
    d[-1] = 30
    d.push(:x)
    assert_equal Deque[10, :b, 30, :x], d
  end

  def test_count
    assert_equal 0, Deque[].count
    assert_equal 1, Deque[nil].count
    assert_equal(1, Deque[1, 2].count{ |e| e >= 2 })
  end

  def test_map
    assert_equal([2], Deque[1].map{ |e| e * 2 })
  end

  def test_dig
    assert_nil Deque[].dig(1, 2, 3)
    assert_equal :b, Deque[:x, %i[a b c]].dig(1, 1)

    deque = Deque[1, Deque[2, 3]]
    assert_equal 3, deque.dig(1, 1)

    assert_raises(ArgumentError){ Deque[5, 6].dig }
  end

  def test_inspect
    deque = Deque.new([1, 2, 3])
    assert_equal "Deque[1, 2, 3]", deque.inspect
  end

  def test_to_a
    assert_equal [], Deque[].to_a
    assert_equal [1, 2, 3], Deque[1, 2, 3].to_a

    d = Deque[]
    d.push(1)
    assert_equal [1], d.to_a
    d.unshift(2)
    assert_equal [2, 1], d.to_a
  end

  def test_to_a_with_reverse
    d = Deque.new.reverse
    assert_equal [], d.to_a
    d.reverse!
    assert_equal [], d.to_a

    d.push(2, 1)
    d.reverse!
    d.push(3)
    d.unshift(0)
    assert_equal [0, 1, 2, 3], d.to_a

    d.reverse!
    assert_equal [3, 2, 1, 0], d.to_a
  end

  def test_to_s
    assert_equal "Deque[]", Deque[].to_s
    assert_equal "Deque[1, 2, 3]", Deque[1, 2, 3].to_s

    assert_output("Deque[1, 2, 3]\n"){ puts Deque[1, 2, 3] }
  end

  def test_reverse
    d = Deque.new([5, 4, 2])
    assert_equal Deque[2, 4, 5], d.reverse
  end

  def test_reverse!
    assert_equal Deque[], Deque[].reverse!
    assert_equal Deque[2, 1], Deque[1, 2].reverse!
  end

  def test_rotate!
    d = Deque["a", "b", "c", "d"]
    assert_equal Deque["b", "c", "d", "a"], d.rotate!
    assert_equal Deque["b", "c", "d", "a"], d
    assert_equal Deque["d", "a", "b", "c"], d.rotate!(2)
    assert_equal Deque["a", "b", "c", "d"], d.rotate!(-3)
  end

  def test_rotate_bang_with_reverse
    d = Deque["d", "c", "b", "a"].reverse
    assert_equal Deque["b", "c", "d", "a"], d.rotate!
    assert_equal Deque["b", "c", "d", "a"], d
    assert_equal Deque["d", "a", "b", "c"], d.rotate!(2)
    assert_equal Deque["a", "b", "c", "d"], d.rotate!(-3)
  end

  def test_rotate
    d = Deque["a", "b", "c", "d"]
    assert_equal Deque["b", "c", "d", "a"], d.rotate
    assert_equal Deque["a", "b", "c", "d"], d
    assert_equal Deque["c", "d", "a", "b"], d.rotate(2)
    assert_equal Deque["d", "a", "b", "c"], d.rotate(-1)
    assert_equal Deque["b", "c", "d", "a"], d.rotate(-3)
  end

  def test_rotate_with_reverse
    d = Deque[:d, :c, :b, :a].reverse
    assert_equal Deque[:b, :c, :d, :a], d.rotate
    assert_equal Deque[:a, :b, :c, :d], d
    assert_equal Deque[:c, :d, :a, :b], d.rotate(2)
    assert_equal Deque[:d, :a, :b, :c], d.rotate(-1)
    assert_equal Deque[:b, :c, :d, :a], d.rotate(-3)
  end

  def test_swap
    d = Deque["a", "b", "c", "d"]
    assert_equal Deque["a", "c", "b", "d"], d.swap(1, 2)
    assert_equal Deque["a", "d", "b", "c"], d.swap(1, 3)
    assert_equal Deque["c", "d", "b", "a"], d.swap(-4, -1)
    d.push("e")
    d.unshift("f")
    assert_equal Deque["e", "c", "d", "b", "a", "f"], d.swap(0, -1)
  end

  def test_sample
    d = Deque.new([100, 2, 3])
    assert_includes [100, 2, 3], d.sample
  end

  def test_shuffle
    d = Deque.new([1, 2, 3, 4, 5])
    s = d.shuffle
    assert_equal d.size, s.size
    assert_equal d.to_a.sort, s.to_a.sort
  end

  def test_replace
    d = Deque["a", "b", "c", "d"]
    a = Deque["a", "b", "c"]
    b = Deque[:a, :b]
    c = Deque[1, 2, 3]
    assert_equal a, d.replace(a)
    assert_equal b, d.replace(b)
    assert_equal c, d.replace(c)
  end

  def test_reverse_push
    d = Deque[2, 1]
    d.reverse!
    d.push(3)
    assert_equal Deque[1, 2, 3], d
  end

  def test_reverse_unshift
    d = Deque[2, 1]
    d.reverse!
    d.unshift(0)
    assert_equal Deque[0, 1, 2], d
  end

  def test_reverse_pop
    d = Deque[2, 1]
    d.reverse!
    assert_equal 2, d.pop
    assert_equal Deque[1], d
  end

  def test_reverse_shift
    d = Deque[2, 1]
    d.reverse!
    assert_equal 1, d.shift
    assert_equal Deque[2], d
  end

  def test_reverse_slice
    d = Deque[30, 20, 10, 0]
    d.reverse!
    assert_equal 0, d[0]
    assert_equal 20, d[2]
    assert_equal 30, d[-1]
    d.reverse!
    assert_equal 0, d[-1]
  end

  def test_reverse_each
    d = Deque[20, 10, 0]
    d.reverse!
    assert_equal [0, 10, 20], d.each.to_a
  end

  def test_slice2
    d = Deque[:a, :b, :c, :d]
    assert_equal Deque[:b, :c], d[1, 2]
    assert_equal Deque[:d], d[-1, 1]
    d.shift
    assert_equal Deque[:c, :d], d[-2, 2]

    d = Deque[1, 2, 3]
    assert_equal Deque[], d[3, 1]
  end

  def test_slice_with_reverse
    d = Deque[:a, :b, :c, :d]
    d.reverse!
    assert_equal Deque[:c, :b], d[1, 2]
    assert_equal Deque[:a], d[-1, 1]
    d.shift
    assert_equal Deque[:b, :a], d[-2, 2]
  end

  def test_each_when_head_is_bigger_than_tail
    d = Deque.new([1, 2])
    d.unshift(0)

    ret = []
    d.each { |e| ret << e }
    assert_equal [0, 1, 2], ret

    d.reverse!
    ret = []
    d.each { |e| ret << e }
    assert_equal [2, 1, 0], ret
  end

  def test_range
    d = Deque[:a, :b, :c, :d]
    d.reverse!
    assert_equal Deque[:c, :b], d[1..2]
    assert_equal Deque[:c, :b], d[1...3]
    assert_equal Deque[:a], d[-1..-1]
    d.shift
    assert_equal Deque[:b, :a], d[-2..-1]
  end

  def test_join
    d = Deque[:x, :y, :z]

    assert_equal "xyz", d.join
    assert_equal "x, y, z", d.join(", ")
  end

  def test_hash
    assert_equal Deque[].hash, Deque[].hash
    assert_equal Deque[1].hash, Deque[1].hash
    assert_equal Deque[1, 2].hash, Deque[1, 2].hash
    assert_equal Deque[1, 2, 3].hash, Deque[1, 2, 3].hash

    refute_equal Deque[1].hash, Deque[2].hash
    refute_equal Deque[1, 2].hash, Deque[2, 1].hash
    refute_equal Deque[1, 2, 3].hash, Deque[3, 2, 1].hash
  end

  def test_clear
    d = Deque[:a, :b, :c, :d]
    d.clear
    assert_equal 0, d.size
    assert_equal Deque.new, d
  end

  def test_typical90_ar_044_example1
    deq = Deque[6, 17, 2, 4, 17, 19, 1, 7]
    deq.unshift(deq.pop)
    deq[6], deq[1] = deq[1], deq[6]
    deq[1], deq[5] = deq[5], deq[1]
    deq[3], deq[4] = deq[4], deq[3]
    assert_equal 4, deq[3]
  end

  def test_typical90_ar_044_example2
    deq = Deque[16, 7, 10, 2, 9, 18, 15, 20, 5]
    deq.unshift(deq.pop)
    deq[0], deq[3] = deq[3], deq[0]
    deq.unshift(deq.pop)
    deq[7], deq[4] = deq[4], deq[7]
    deq.unshift(deq.pop)
    assert_equal 18, deq[5]
  end

  def test_typical90_ar_044_example3
    deq = Deque[23, 92, 85, 34, 21, 63, 12, 9, 81, 44, 96]
    assert_equal 44, deq[9]
    assert_equal 21, deq[4]
    deq[2], deq[3] = deq[3], deq[2]
    deq.unshift(deq.pop)
    deq[3], deq[10] = deq[10], deq[3]
    assert_equal 34, deq[10]
    deq[2], deq[4] = deq[4], deq[2]
    deq.unshift(deq.pop)
    deq.unshift(deq.pop)
    assert_equal 63, deq[8]
    deq.unshift(deq.pop)
    assert_equal 85, deq[5]
    assert_equal 63, deq[9]
    deq.unshift(deq.pop)
    assert_equal 21, deq[9]
    assert_equal 34, deq[3]
    assert_equal 96, deq[4]
  end

  def test_typical90_ar_044_example1_details
    deq = Deque[6, 17, 2, 4, 17, 19, 1, 7]
    deq.unshift(deq.pop)
    assert_equal Deque[7, 6, 17, 2, 4, 17, 19, 1], deq
    deq[6], deq[1] = deq[1], deq[6]
    assert_equal Deque[7, 19, 17, 2, 4, 17, 6, 1], deq
    deq[1], deq[5] = deq[5], deq[1]
    assert_equal Deque[7, 17, 17, 2, 4, 19, 6, 1], deq
    deq[3], deq[4] = deq[4], deq[3]
    assert_equal Deque[7, 17, 17, 4, 2, 19, 6, 1], deq
    assert_equal 4, deq[3]
  end
end
