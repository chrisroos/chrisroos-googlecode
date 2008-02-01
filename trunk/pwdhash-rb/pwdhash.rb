#!/usr/bin/env ruby

def next_extra_character(extras)
  next_extra(extras).chr
end

def next_extra(extras)
  extras.empty? ? 0 : extras.shift[0]
end

def rotate(array, amount)
  amount.downto(1) { array.push(array.shift) }
end

def between(min, interval, offset)
  min + offset % interval
end

def next_between(base, interval, extras)
  char_code = between(base[0], interval, next_extra(extras))
  char_code.chr
end

def contains(result, regex)
  result.match(regex)
end

def apply_constraints(hash, size, nonalphanumeric)
  startingSize = size - 4 # Leave room for some extra characters
  result = hash[0, startingSize]
  extras = hash[startingSize, hash.length].split('')
  
  # Add the extra characters
  result += (contains(result, /[A-Z]/) ? next_extra_character(extras) : next_between('A', 26, extras))
  result += (contains(result, /[a-z]/) ? next_extra_character(extras) : next_between('a', 26, extras))
  result += (contains(result, /[0-9]/) ? next_extra_character(extras) : next_between('0', 10, extras))
  result += (contains(result, /\W/) && nonalphanumeric ? next_extra_character(extras) : '+')
  while (contains(result, /\W/) && !nonalphanumeric) do
    result = result.sub(/\W/, next_between('A', 26, extras))
  end
  
  # Rotate the result to make it harder to guess the inserted locations
  result = result.split('')
  rotate(result, next_extra(extras))
  return result.join('')
end

expected = '1JMstxYHYz'
actual = apply_constraints(hash='MstxYHYzGq0jEjzfTbaFrQ', size=10, nonalphanumeric=false)
raise("apply_constraints is broken!") unless expected == actual

$: << '~/dev/lib/ruby-hmac-0.3'
require 'hmac-md5'
require 'base64'

class String
  def base64_hmac_md5(key)
    Base64.encode64(HMAC::MD5.digest(key, self))
  end
end

def get_hashed_password(password, realm)
  hash = realm.base64_hmac_md5(password)
  hash = hash.gsub(/=+$/, '') # remove base64 pad character (=) - not used by default in md5.js implementation
  size = password.length + '@@'.length
  nonalphanumeric = !password.match(/\W/).nil?
  apply_constraints(hash, size, nonalphanumeric)
end

print "Enter realm (usually the website domain): "
realm = gets
print "Enter password: "
password = gets
p get_hashed_password(password, realm)