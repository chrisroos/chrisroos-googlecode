require 'rubygems'
require 'hpricot'

html = File.open('/Users/chrisroos/Desktop/ingdirect-b1.html') { |f| f.read }

# The request for our PIN digits appears within the following text
# <b>Using the Key Pad, please enter the 3rd, 5th and 2nd digits from your PIN</b>
pin_a, pin_b, pin_c = html.scan(/Using the Key Pad, please enter the (\d).+?(\d).+?(\d).*?<\/b>/).flatten

# Ok, now let's find the order of the keypad (hey, it's in a div with id pin-pad - cool)
# This has turned out quite trivial.  The keypad is rendered within an html table, where each cell contains a button (input)
# that has a value of the number displayed on the button.  Hpricot makes it very easy to say 'get me all buttons (input)
# that appear in cells within the table that is in the div with an id of pin-pad'.  As hpricot will parse the html table
# 'in order', i.e. from top-left to bottom right, we just have to append each button value into an array, preserving the
# order of the keypad.
doc = Hpricot(html)
keypad = (doc/'div#pin-pad/table/tr/td/input').inject([]) { |array, btn| array << btn.attributes['value'].to_i; array }
# The last value read from the html keypad table will appear at index 9 (our array is 0 based), where we actually want it to 
# appear at index 0 (keypad is in phone keypad order, i.e. 0 at bottom).  Luckily, we can just pop it off the end and
# prepend it to the array
keypad.unshift(keypad.pop)
# So, we can now convert a keypad like this
# 5 1 2
# 4 7 3
# 0 8 9
#   6
# into the equivalent ruby array [6, 5, 1, 2, 4, 7, 3, 0, 8, 9]
# We can then use Array#index to dive in grab the keypad position of a number
# keypad.index(5) #=> 1
# keypad.index(7) #=> 5