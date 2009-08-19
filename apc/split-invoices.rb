invoices = File.read('APC-INVOICES.txt')
# invoices = File.read('multipage-invoice.txt')

invoice = ''
invoices.each do |line|
  if line =~ /^\f/ and invoice =~ /PLEASE PAY BY/ # Form feed, page eject
    account_number = invoice[/ACCOUNT: (.*)$/, 1].chomp
    File.open(File.join('invoices', "#{account_number}.txt"), 'w') { |f| f.puts(invoice) }
    invoice = ''
  else
    invoice << line
  end
end