# curl http://localhost:3001/files -v -X"POST" -d"my_data" -H"Content-Type: text/plain"

require 'net/http'

puts "** Attempting to GET a resource"
response = Net::HTTP.start('127.0.0.1', '3001') { |http| http.get('/files/') }
puts "Code: "    + response.code        #=> 405
puts "Message: " + response.message     #=> Method Not Allowed
puts "Allow: "   + response['allow']    #=> POST, DELETE
puts "Body: "    + response.body        #=> ''
puts ""

puts "** Attempting to PUT a resource"
response = Net::HTTP.start('127.0.0.1', '3001') { |http| http.put('/files/', 'my_data_here') }
puts "Code: "    + response.code        #=> 405
puts "Message: " + response.message     #=> Method Not Allowed
puts "Allow: "   + response['allow']    #=> POST, DELETE
puts "Body: "    + response.body        #=> ''
puts ""

puts "** Attempting to POST without specifying Content-Type"
response = Net::HTTP.start('127.0.0.1', '3001') { |http| response = http.post('/files/', 'my_data_here') }
puts "Code: "    + response.code        #=> 415
puts "Message: " + response.message     #=> Unsupported Media Type
puts "Body: "    + response.body        #=> 'Content-Type must be text/plain'
puts ""

puts "** Attempting to POST without any data"
response = Net::HTTP.start('127.0.0.1', '3001') { |http| http.post('/files/', '', 'Content-Type' => 'text/plain') }
puts "Code: "    + response.code        #=> 400
puts "Message: " + response.message     #=> Bad Request
puts "Body: "    + response.body        #=> You gotta submit a text file eh.
puts ""

puts "** Attemping to POST more than 5000 bytes of data"
alphabet = ('a'..'z').to_a
big_data = (0..5000).inject('') { |string, i| string + alphabet[rand(26)] }
response = Net::HTTP.start('127.0.0.1', '3001') { |http| http.post('/files/', big_data, 'Content-Type' => 'text/plain') }
puts "Code: "    + response.code        #=> 413
puts "Message: " + response.message     #=> Request Entity Too Large
puts "Body: "    + response.body        #=> Text files submitted to the server can have a maximum size of 5KB.
puts ""

puts "** Attempting to POST just a nice amount of data"
response = Net::HTTP.start('127.0.0.1', '3001') { |http| http.post('/files/', 'my_data_here', 'Content-Type' => 'text/plain') }
puts "Code: "    + response.code        #=> 201
puts "Message: " + response.message     #=> Created
puts "Message: " + response['location'] #=> http://127.0.0.1:3001/files/TIMESTAMP_HERE
puts "Body: "    + response.body        #=> Text files submitted to the server can have a maximum size of 5KB.
puts ""

puts "** Attempting to DELETE a non existent resource"
response = Net::HTTP.start('127.0.0.1', '3001') { |http| http.delete('/files/made_up_filename') }
puts "Code: "    + response.code        #=> 404
puts "Message: " + response.message     #=> Not Found
puts "Body: "    + response.body        #=> NOT FOUND
puts ""

puts "** Attempting to DELETE a resource"
response = Net::HTTP.start('127.0.0.1', '3001') { |http| http.delete('/files/TIMESTAMP_OF_CREATED_FILE') }
puts "Code: "    + response.code        #=> 200
puts "Message: " + response.message     #=> OK
puts "Body: "    + response.body        #=> CONTENT_OF_CREATED_FILE
puts ""