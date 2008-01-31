require 'json'

class StationsParser
  def self.from_file(stations_as_json_path)
    stations_as_json = File.open(stations_as_json_path) { |file| file.read }
    JSON.parse(stations_as_json)
  end
end

class Stations
  def initialize(station_codes_and_stations)
    @stations = station_codes_and_stations.inject({}) do |hash, station_code_and_station|
      hash[station_code_and_station.values.first] = station_code_and_station.keys.first
      hash
    end
  end
  def [](code)
    @stations[code]
  end
end

stations_json_path = File.dirname(__FILE__) + '/stations.js'
station_codes_and_stations = StationsParser.from_file(stations_json_path)


# STATIONS_BY_CODE = station_codes_and_stations.inject({}) { |hash, station_code_and_station| hash[station_code_and_station.keys.first] = station_code_and_station.values.first; hash }
# p STATIONS_BY_CODE
# STATION_CODES = 
# STATIONS = STATION_CODES.keys
# 
# # CODES_BY_STATION.keys.select { |station| station =~ /#{station_search_term}/i }.sort.each { |station| p [station, CODES_BY_STATION[station]] }