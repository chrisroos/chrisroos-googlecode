require 'hpricot'

module NatRailEnq
  class Parser
    def initialize(html)
      @html = html
    end
    def parse_timetable
      doc = Hpricot(@html)

      departs, arrives = [], []
      (doc/'input#DepartsBTN').first.parent.parent.children_of_type('td').each { |e| departs << e.inner_text }
      (doc/'input#ArrivesBTN').first.parent.parent.children_of_type('td').each { |e| arrives << e.inner_text }

      departs.zip(arrives).collect { |from_to| from_to.join('->') }.join(', ')
    end
  end
end