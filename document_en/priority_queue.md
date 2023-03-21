# PriorityQueue

PriorityQueue

**Alias**

- `HeapQueue`

## Class Methods

### new(array = []) -> PriorityQueue

```ruby
PriorityQueue.new
pq = PriorityQueue.new([1, -1, 100])
pq.pop # => 100
pq.pop # => 1
pq.pop # => -1
```

It creates a `PriorityQueue` to initialized to `array`.

**Complexity**

- `O(n)` (`n` is the number of elements of `array`)

### new(array = []) {|x, y| ... } -> PriorityQueue

```ruby
PriorityQueue.new([1, -1, 100]) {|x, y| x < y }
pq.pop # => -1
pq.pop # => 1
pq.pop # => 100
```

Constructs a prioritized queue from an array given as an argument.
A comparison function can be passed in the block. When a comparison function is passed, it is used to calculate the priority of the elements.

Any object can be an element of the queue if it can be compared with the comparison function.

**Complexity**

- `O(n)` (`n` is the number of elements of `array`)

## Instance Methods

### push(item)

```ruby
pq.push(10)
```

It adds the element.

**Alias**

- `<<`
- `append`

**Complexity**

- `O(log n)` (`n` is the number of elements of priority queue)

### pop -> Highest priority element  | nil

```ruby
pq.pop # => 100
```

It removes the element with the highest priority from the queue and returns it. If the queue is empty, it rerurns `nil`.

**Complexity**

- `O(log n)` (`n` is the number of elements of priority queue)

### get -> Highest priority element | nil

```ruby
pq.get # => 10
```

It returns the value of the highest priority element without removing it.

If the queue is empty, it returns `nil`.

**Alias**

- `top`

**Complexity**

- `O(1)`

### empty? -> bool

```ruby
pq.empty? # => false
```

It returns `true` if the queue is empty, `false` otherwise.

**Complexity** `O(1)`

### heap -> Array[elements of priority queue]

```ruby
pq.heap
```

It returns the binary heap that the priority queue has internally.

## Verified

- [Aizu Online Judge ALDS1_9_C Priority Queue](https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_9_C)
  - [AC code](https://onlinejudge.u-aizu.ac.jp/solutions/problem/ALDS1_9_C/review/4835681/qsako6/Ruby)

## Links

- [cpython/heapq.py at main - python/cpython](https://github.com/python/cpython/blob/main/Lib/heapq.py)
