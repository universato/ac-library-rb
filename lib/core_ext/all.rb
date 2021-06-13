class Array
  def to_fenwick_tree
    FenwickTree.new(self)
  end
  alias to_fetree to_fenwick_tree

  def to_priority_queue
    PriorityQueue.new(self)
  end
  alias to_pq to_priority_queue
end
