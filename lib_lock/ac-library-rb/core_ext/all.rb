class Array
  def to_fenwick_tree
    AcLibraryRb::FenwickTree.new(self)
  end
  alias to_fetree to_fenwick_tree

  def to_priority_queue
    AcLibraryRb::PriorityQueue.new(self)
  end
  alias to_pq to_priority_queue
end
