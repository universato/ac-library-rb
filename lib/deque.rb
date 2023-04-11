class Deque
  include Enumerable

  def self.[](*args)
    new(args)
  end

  def initialize(arg = [], value = nil, initial_capacity: 0)
    ary = arg
    ary = Array.new(arg, value) if arg.is_a?(Integer)
    @n = [initial_capacity, ary.size].max + 1
    @buf = ary + [nil] * (@n - ary.size)
    @head = 0
    @tail = ary.size
    @reverse_count = 0
  end

  def empty?
    size == 0
  end

  def size
    (@tail - @head) % @n
  end
  alias length size

  def <<(x)
    reversed? ? __unshift(x) : __push(x)
  end

  def push(*args)
    args.each{ |x| self << x }
    self
  end
  alias append push

  def unshift(*args)
    if reversed?
      args.reverse_each{ |e|  __push(e) }
    else
      args.reverse_each{ |e| __unshift(e) }
    end
    self
  end
  alias prepend unshift

  def pop
    reversed? ? __shift : __pop
  end

  def shift
    reversed? ? __pop : __shift
  end

  def last
    self[-1]
  end

  def slice(idx)
    sz = size
    return nil if idx < -sz || sz <= idx

    @buf[__index(idx)]
  end

  def [](a, b = nil)
    if b
      slice2(a, b)
    elsif a.is_a?(Range)
      s = a.begin
      t = a.end
      t -= 1 if a.exclude_end?
      slice2(s, t - s + 1)
    else
      slice1(a)
    end
  end

  def at(idx)
    slice1(idx)
  end

  private def slice1(idx)
    sz = size
    return nil if idx < -sz || sz <= idx

    @buf[__index(idx)]
  end

  private def slice2(i, t)
    sz = size
    return nil if t < 0 || i > sz

    if i == sz
      Deque[]
    else
      j = [i + t - 1, sz].min
      slice_indexes(i, j)
    end
  end

  private def slice_indexes(i, j)
    i, j = j, i if reversed?
    s = __index(i)
    t = __index(j) + 1
    Deque.new(__to_a(s, t))
  end

  def []=(idx, value)
    @buf[__index(idx)] = value
  end

  def ==(other)
    return false unless size == other.size

    to_a == other.to_a
  end

  def hash
    to_a.hash
  end

  def reverse
    dup.reverse!
  end

  def reverse!
    @reverse_count += 1
    self
  end

  def reversed?
    @reverse_count & 1 == 1
  end

  def dig(*args)
    case args.size
    when 0
      raise ArgumentError.new("wrong number of arguments (given 0, expected 1+)")
    when 1
      self[args[0].to_int]
    else
      i = args.shift.to_int
      self[i]&.dig(*args)
    end
  end

  def each(&block)
    return enum_for(:each) unless block_given?

    if @head <= @tail
      if reversed?
        @buf[@head...@tail].reverse_each(&block)
      else
        @buf[@head...@tail].each(&block)
      end
    elsif reversed?
      @buf[0...@tail].reverse_each(&block)
      @buf[@head..-1].reverse_each(&block)
    else
      @buf[@head..-1].each(&block)
      @buf[0...@tail].each(&block)
    end
  end

  def clear
    @n = 1
    @buf = []
    @head = 0
    @tail = 0
    @reverse_count = 0
    self
  end

  def join(sep = $OFS)
    to_a.join(sep)
  end

  def rotate!(cnt = 1)
    return self if cnt == 0

    cnt %= size if cnt < 0 || size > cnt

    cnt.times{ push(shift) }
    self
  end

  def rotate(cnt = 1)
    return self if cnt == 0

    cnt %= size if cnt < 0 || size > cnt

    ret = dup
    @buf = @buf.dup
    cnt.times{ ret.push(ret.shift) }
    ret
  end

  def sample
    return nil if empty?

    self[rand(size)]
  end

  def shuffle
    Deque.new(to_a.shuffle)
  end

  def replace(other)
    ary = other.to_a
    @n = ary.size + 1
    @buf = ary + [nil] * (@n - ary.size)
    @head = 0
    @tail = ary.size
    @reverse_count = 0
    self
  end

  def swap(i, j)
    i = __index(i)
    j = __index(j)
    @buf[i], @buf[j] = @buf[j], @buf[i]
    self
  end

  def to_a
    __to_a
  end
  # alias to_ary to_a

  private def __to_a(s = @head, t = @tail)
    res = s <= t ? @buf[s...t] : @buf[s..-1].concat(@buf[0...t])
    reversed? ? res.reverse : res
  end

  def to_s
    "#{self.class}#{to_a}"
  end

  def inspect
    "Deque#{to_a}"
    # "Deque#{to_a}(@n=#{@n}, @buf=#{@buf}, @head=#{@head}, @tail=#{@tail}, "\
    # "size #{size}#{' full' if __full?}#{' rev' if reversed?})"
  end

  private def __push(x)
    __extend if __full?
    @buf[@tail] = x
    @tail += 1
    @tail %= @n
    self
  end

  private def __unshift(x)
    __extend if __full?
    @buf[(@head - 1) % @n] = x
    @head -= 1
    @head %= @n
    self
  end

  private def __pop
    return nil if empty?

    ret = @buf[(@tail - 1) % @n]
    @tail -= 1
    @tail %= @n
    ret
  end

  private def __shift
    return nil if empty?

    ret = @buf[@head]
    @head += 1
    @head %= @n
    ret
  end

  private def __full?
    size >= @n - 1
  end

  private def __index(i)
    l = size
    raise IndexError, "index out of range: #{i}" unless -l <= i && i < l

    i = -(i + 1) if reversed?
    i += l if i < 0
    (@head + i) % @n
  end

  private def __extend
    if @tail + 1 == @head
      tail = @buf.shift(@tail + 1)
      @buf.concat(tail).concat([nil] * @n)
      @head = 0
      @tail = @n - 1
      @n = @buf.size
    else
      @buf[(@tail + 1)..(@tail + 1)] = [nil] * @n
      @n = @buf.size
      @head += @n if @head > 0
    end
  end
end
