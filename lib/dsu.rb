# Disjoint Set Union
class DSU
  def initialize(n = 0)
    @n = n
    @parent_or_size = Array.new(n, -1)
    # root node: -1 * component size
    # otherwise: parent
  end

  attr_accessor :parent_or_size

  def merge(a, b)
    raise ArgumentError if a < 0 || @n <= a
    raise ArgumentError if b < 0 || @n <= b

    x = leader(a)
    y = leader(b)
    return x if x == y

    x, y = y, x if -@parent_or_size[x] < -@parent_or_size[y]
    @parent_or_size[x] += @parent_or_size[y]
    @parent_or_size[y] = x
  end
  alias unite merge

  def same(a, b)
    raise ArgumentError if a < 0 || @n <= a
    raise ArgumentError if b < 0 || @n <= b

    leader(a) == leader(b)
  end
  alias same? same

  def leader(a)
    raise ArgumentError if a < 0 || @n <= a

    @parent_or_size[a] < 0 ? a : (@parent_or_size[a] = leader(@parent_or_size[a]))
  end
  alias root leader
  alias find leader

  def size(a)
    raise ArgumentError if a < 0 || @n <= a

    -@parent_or_size[leader(a)]
  end

  def groups
    (0 ... @parent_or_size.size).group_by{ |i| leader(i) }.values
  end
end

UnionFind        = DSU
UnionFindTree    = DSU
DisjointSetUnion = DSU
