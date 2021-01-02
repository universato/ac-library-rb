# Disjoint Set Union
class DSU
  def initialize(n = 0)
    # root node: -1 * component size
    # otherwise: parent
    @parent_or_size = Array.new(n, -1)
  end

  attr_accessor :parent_or_size

  def merge(a, b)
    x = leader(a)
    y = leader(b)
    return x if x == y

    x, y = y, x if -@parent_or_size[x] < -@parent_or_size[y]
    @parent_or_size[x] += @parent_or_size[y]
    @parent_or_size[y] = x
  end
  alias unite merge

  def same(a, b)
    leader(a) == leader(b)
  end
  alias same? same

  def leader(a)
    @parent_or_size[a] < 0 ? a : (@parent_or_size[a] = leader(@parent_or_size[a]))
  end
  alias root leader
  alias find leader

  def size(a)
    -@parent_or_size[leader(a)]
  end

  def groups
    (0 ... @parent_or_size.size).group_by{ |i| leader(i) }.values
  end
end

UnionFind        = DSU
UnionFindTree    = DSU
DisjointSetUnion = DSU
