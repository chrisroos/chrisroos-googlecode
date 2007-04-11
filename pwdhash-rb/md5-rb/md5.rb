require 'core-ext'

def binl2b64(binarray)
  b64pad = ''
  tab = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  str = '';
  loop_size = binarray.length * 4
  (0...loop_size).step(3) do |i|
    a = (((binarray[i >> 2] >> 8 * (i%4)) & 0xFF) << 16)
    b = (((binarray[i+1 >> 2] >> 8 * ((i+1)%4)) & 0xFF) << 8 )
    c = ((binarray[i+2 >> 2] >> 8 * ((i+2)%4)) & 0xFF)
    triplet = a | b | c
    (0..3).each do |j|
      if ((i * 8 + j * 6) > (binarray.length * 32))
        str += b64pad
      else
        location_of_char = (triplet >> 6*(3-j)) & 0x3F
        ascii_code = tab[location_of_char]
        str += ascii_code.chr
      end
    end
  end
  str
end
expected = 'MstxYHYzGq0jEjzfTbaFrQ'
actual = binl2b64([1618070322, -1390791818, -549711325, -1383745971])
raise("binl2b64 is broken!  Expected #{expected} but got #{actual}") unless expected == actual

# Convert a string to an array of little-endian words
# If chrsz is ASCII, characters >255 have their hi-byte silently ignored.
def str2binl(str, chrsz = 8)
  bin = Array.new(0);
  mask = (1 << chrsz) - 1;
  (0...str.length * chrsz).step(chrsz) do |i|
    value = ((str[i / chrsz] & mask) << (i%32))
    bin[i>>5] ||= 0
    bin[i>>5] += value
  end
  bin
end
expected = [1936941424, 1685221239]
actual = str2binl('password')
raise("str2binl is broken!  Expected #{expected} but got #{actual}") unless expected == actual

# Add integers, wrapping at 2^32. This uses 16-bit operations internally
# to work around bugs in some JS interpreters.
def safe_add(x, y)
  lsw = (x & 0xFFFF) + (y & 0xFFFF);
  msw = (x >> 16) + (y >> 16) + (lsw >> 16);
  return (msw << 16) | (lsw & 0xFFFF);
end
expected = 1003244895
actual = safe_add(-729339298, 1732584193)
raise("safe_add is broken!  Expected #{expected} but got #{actual}") unless expected == actual

# TODO
def bit_rol(num, cnt)
  a = (num << cnt)
  b = (num.zero_fill_right_shift(32 - cnt))
  a | b
end
expected = 268435456
actual = bit_rol(2, -5)
raise("bit_rol is broken!  Expected #{expected} but got #{actual}") unless expected == actual

def md5_cmn(q, a, b, x, s, t)
end
expected = -1544314603
actual = md5_cmn(1732584194, 1732584193, -271733879, 1936941424, 7, -680876936)
raise("md5_cmn is broken!  Expected #{expected} but got #{actual}") unless expected == actual

# TODO
def md5_gg
end

# TODO
def md5_hh
end

# TODO
def md5_ii
end

def md5_ff(a, b, c, d, x, s, t)
end
expected = 1590730542
actual = md5_ff(1732584193, -271733879, -1732584194, 271733878, 1936941424, 7, -680876936)
raise("md5_ff is broken!  Expected #{expected} but got #{actual}") unless expected == actual

# Calculate the MD5 of an array of little-endian words, and a bit length
def core_md5(x, len)
end
expected = [1003244895, -697981094, -567835875, -1714453832]
actual = core_md5([1936941424, 1685221239], 'password'.length * (chrsz=8))
raise("core_md5 is broken!  Expected #{expected} but got #{actual}") unless expected == actual

def core_hmac_md5(key, data)
end
expected = [1618070322, -1390791818, -549711325, -1383745971]
actual = core_hmac_md5('password', 'realm')
raise("core_hmac_md5 is broken!  Expected #{expected} but got #{actual}") unless expected == actual
