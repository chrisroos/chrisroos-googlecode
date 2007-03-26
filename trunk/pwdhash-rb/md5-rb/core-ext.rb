class NilClass
  def >>(number)
    0
  end
end

class Integer
  def to_binary
    str = ''
    (size_in_bits-1).downto(0) { |n| str << self[n].to_s }
    str
  end
  def size_in_bits
    self.size * 8
  end
  def zero_fill_right_shift(count)
    (self >> count) & ((2 ** (size_in_bits-count))-1)
  end
end