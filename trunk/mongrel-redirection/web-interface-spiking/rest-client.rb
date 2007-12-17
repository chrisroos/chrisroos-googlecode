require 'json'

HOST, PORT = 'localhost', '4001'

# Creating a new redirection
path, redirect_to = '/wem', 'http://foo.com/wem'

request = Net::HTTP::Put.new(path)
request.body = {'url' => redirect_to}.to_json
response = Net::HTTP.start(HOST, PORT) do |http|
  http.request(request)
end
p response

# Listing all redirections
response = Net::HTTP.start(HOST, PORT) do |http|
  http.get("/")
end
p JSON.parse(response.body)