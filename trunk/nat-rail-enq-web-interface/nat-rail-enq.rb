require 'rubygems'
require 'hpricot'

CURL_CMD = '/usr/bin/curl'

class NationalRailEnquiries
  
  COOKIE_JAR = File.expand_path(File.dirname(__FILE__) + '/national-rail-enquiries.cookie')
  
  class Parameters
    attr_reader :depart_station, :arrive_station
    attr_reader :depart_day, :depart_month, :depart_hour, :depart_minute
    def initialize(depart_station, arrive_station, depart_day, depart_month, depart_hour, depart_minute)
      @depart_station, @arrive_station = depart_station, arrive_station
      @depart_day, @depart_month = depart_day, depart_month
      @depart_hour, @depart_minute = depart_hour, depart_minute
    end
  end
  
  def self.search(parameters)
    new(parameters).search
  end
  def initialize(parameters)
    @parameters = parameters
  end
  def search
    curl_cmd = <<-EndCurl
#{CURL_CMD} http://ojp1.nationalrail.co.uk/en/pj/jp \
-X"POST" \
-d"from.searchTerm=#{@parameters.depart_station}" \
-d"to.searchTerm=#{@parameters.arrive_station}" \
-d"timeOfOutwardJourney.day=#{@parameters.depart_day}" \
-d"timeOfOutwardJourney.month=#{@parameters.depart_month}" \
-d"hidYear=" \
-d"timeOfOutwardJourney.hour=#{@parameters.depart_hour}" \
-d"timeOfOutwardJourney.minute=#{@parameters.depart_minute}" \
-d"timeOfOutwardJourney.arrivalOrDeparture=DEPART" \
-d"timeOfOutwardJourney.firstOrLast=FIRST" \
-d"timeOfReturnJourney.day=" \
-d"timeOfReturnJourney.month=" \
-d"timeOfReturnJourney.hour=19" \
-d"timeOfReturnJourney.minute=45" \
-d"timeOfReturnJourney.arrivalOrDeparture=DEPART" \
-d"timeOfReturnJourney.firstOrLast=FIRST" \
-d"maxChanges=-1" \
-d"planjourney=SEARCH" \
-c"#{COOKIE_JAR}" \
-s
    EndCurl

    `#{curl_cmd}`
    html = `#{CURL_CMD} http://ojp1.nationalrail.co.uk/en/pj/tt -b"#{COOKIE_JAR}" -s`

    doc = Hpricot(html)
    
    departs, arrives = [], []
    (doc/'input#DepartsBTN').first.parent.parent.children_of_type('td').each { |e| departs << e.inner_text }
    (doc/'input#ArrivesBTN').first.parent.parent.children_of_type('td').each { |e| arrives << e.inner_text }
    
    `rm #{COOKIE_JAR}`
    
    departs.zip(arrives).collect { |from_to| from_to.join('->') }.join(', ')
  end
end