html = File.read('lloyds-tsb')

require 'hpricot'
doc = Hpricot(html)

# Get the following account details
# * Selected account
# * Account balance
# * Available balance
# * Sort code
# * Account number
account_details = {}
(doc/"#accountTable"/'td').each do |table_cell|
  divs = (table_cell/'div')
  if divs.length == 2
    label = divs.first.inner_text
    value = divs.last.inner_text
    account_details[label] = value if label and value
  end
end
p account_details

# Transactions
(doc/'table#striped'/'tr').each do |table_row|
  table_row_cells = (table_row/'td')
  next unless table_row_cells.length == 8 # not a transaction row
  date, type, debit, credit, balance = [1, 2, 4, 5, 6].map { |index| table_row_cells[index].inner_text.strip }
  details = table_row_cells[3].inner_html.gsub(/\r\n/, '').gsub(/<br \/>/, "/")
  p [date, type, details, debit, credit, balance]
end
