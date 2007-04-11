require 'test/unit'
require 'core-ext'

class FixnumTest < Test::Unit::TestCase
  
  def setup
    @fixnum = 2
  end
  
  def test_should_ensure_integer_uses_4_bytes
    assert_equal 4, @fixnum.size
  end
  
  def test_should_return_size_of_fixnum_in_bits
    assert_equal (4 * 8), @fixnum.size_in_bits
  end
  
  def test_should_display_binary_number_with_as_many_bits_as_fixnum_requires
    assert_equal (4 * 8), @fixnum.to_binary.length
  end
  
  def test_should_display_fixnum_2_as_binary
    assert_equal '00000000000000000000000000000010', @fixnum.to_binary
  end
  
end

class BignumTest < Test::Unit::TestCase
  
  def setup
    @bignum = 2 ** 40
  end
  
  def test_should_ensure_bignum_uses_8_bytes
    assert_equal 8, @bignum.size
  end
  
  def test_should_return_size_of_bignum_in_bits
    assert_equal (8 * 8), @bignum.size_in_bits
  end
  
  def test_should_display_binary_number_with_as_many_bits_as_bignum_requires
    assert_equal (8 * 8), @bignum.to_binary.length
  end
  
  def test_should_display_bignum_2_to_power_of_40_as_binary
    expected_binary = '0' * 64
    expected_binary[63 - 40] = '1'
    assert_equal expected_binary, @bignum.to_binary
  end
  
end

class IntegerTest < Test::Unit::TestCase
  # Expected answers from Javascript >>> operator
  
  def test_should_zero_fill_right_shift_9_by_2
    assert_equal 2, 9.zero_fill_right_shift(2)
  end
  
  def test_should_zero_fill_right_shift_negative_9_by_1
    assert_equal 2147483643, -9.zero_fill_right_shift(1)
  end
  
  def test_should_zero_fill_right_shift_negative_9_by_1
    assert_equal 1073741821, -9.zero_fill_right_shift(2)
  end
  
  def test_should_zero_fill_right_shift_negative_9_by_1
    assert_equal 536870910, -9.zero_fill_right_shift(3)
  end
  
  def test_should_zero_fill_right_shift_negative_9_by_1
    assert_equal 268435455, -9.zero_fill_right_shift(4)
  end
  
end

class NilTest < Test::Unit::TestCase
  
  def test_should_return_0_if_we_try_to_right_shift_nil
    assert_equal 0, nil >> 99
  end
  
end
