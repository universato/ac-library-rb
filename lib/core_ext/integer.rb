require "prime"

class Integer
  # Returns the positive divisors of +self+ if +self+ is positive.
  #
  # == Example
  #   6.divisors   #=> [1, 2, 3, 6]
  #   7.divisors   #=> [1, 7]
  #   8.divisors   #=> [1, 2, 4, 8]
  def divisors
    if prime?
      [1, self]
    elsif self == 1
      [1]
    else
      xs = prime_division.map{ |p, n| Array.new(n + 1){ |e| p**e } }
      x = xs.pop
      x.product(*xs).map{ |t| t.inject(:*) }.sort
    end
  end

  # Iterates the given block for each divisor of +self+.
  #
  # == Example
  #   ds = []
  #   10.divisors{ |d| ds << d }
  #   ds  #=> [1, 2, 5, 10]
  def each_divisor(&block)
    block_given? ? divisors.each(&block) : enum_for(:each_divisor)
  end
end
