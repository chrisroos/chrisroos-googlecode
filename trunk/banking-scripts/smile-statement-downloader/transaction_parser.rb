require 'hpricot'
require 'date'

class Parser
  def initialize(html)
    @doc = Hpricot(html)
  end
  def each
    (@doc/'table.summarytable'/'tbody'/'tr').each do |table_row|
      date, description, deposit, withdrawal = (table_row/'td').collect { |e| e.inner_text }
      # Ignore the last line of the transaction table, it just displays the balance from the last statement
      next if description == '*LAST STATEMENT*'
      # Date's are in day/month/year format
      date = Date.strptime(date, '%d/%m/%Y')
      # Strip the british pound sign from the amounts
      deposit, withdrawal = [deposit, withdrawal].collect { |amount| amount.gsub(/\243/, '') }
      # The amount should be negative (reflecting a withdrawal) or positive (reflecting a deposit)
      amount = deposit == '?' ? -Float(withdrawal) : Float(deposit)
      yield [date, description, amount]
    end
  end
end

html = File.read(File.join(File.dirname(__FILE__), 'pages', 'current-account-overview.html'))
Parser.new(html).each do |date, description, amount|
  puts [date, description, amount].join("\t")
end
