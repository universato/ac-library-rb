def ModInt(val)
  ModInt.new(val)
end

# Integer
class Integer
  def to_modint
    ModInt.new(self)
  end
  alias to_m to_modint
end

# String
class String
  def to_modint
    ModInt.new(to_i)
  end
  alias to_m to_modint
end
