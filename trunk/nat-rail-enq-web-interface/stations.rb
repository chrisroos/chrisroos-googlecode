require 'json'

station_search_term = 'durham'

stations_json = File.open("/Users/chrisroos/Desktop/stations.js") { |file| file.read }
station_codes_and_stations = JSON.parse(stations_json)
STATIONS_BY_CODE = station_codes_and_stations.inject({}) { |hash, station_code_and_station| hash[station_code_and_station.keys.first] = station_code_and_station.values.first; hash }
CODES_BY_STATION = station_codes_and_stations.inject({}) { |hash, station_code_and_station| hash[station_code_and_station.values.first] = station_code_and_station.keys.first; hash }

# p STATIONS_BY_CODE.keys.select { |station_code| station_code =~ /ram/i }
CODES_BY_STATION.keys.select { |station| station =~ /#{station_search_term}/i }.sort.each { |station| p [station, CODES_BY_STATION[station]] }