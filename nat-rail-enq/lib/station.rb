require 'json'

DATA_STORE = File.join(File.dirname(__FILE__), '..', 'data')

module NatRailEnq

  StationsVsCodes, CodesVsStations = {}, {}
  Stations = []
  StationData = File.open(File.join(DATA_STORE, 'stations.json')) { |f| JSON.parse(f.read) }

  StationData.each do |code_and_station|
    code, station = code_and_station.to_a.flatten
    code, station = code.downcase, station.downcase # Normalisation
    StationsVsCodes[code] = station
    CodesVsStations[station] = code
    Stations << station
  end

  class Station
    class << self
      def exists?(station_or_code)
        station_or_code.downcase!
        StationsVsCodes[station_or_code] || CodesVsStations[station_or_code]
      end
      def find(name)        
        Stations.select { |station| 
          station =~ /#{name}/i 
        }.collect { |station| 
          code = CodesVsStations[station]
          "#{station} [#{code}]"
        }
      end
    end
  end
  
end