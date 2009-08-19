invoices_file = ARGV.shift
unless invoices_file && File.exists?(invoices_file)
  puts ""
  puts "Split Invoices"
  puts "--------------"
  puts "Usage: split-invoices.rb all-invoices-file [output-directory]"
  puts ""
  puts "  * all-invoices-file (required): Path to the file containing all invoices exported from APC Depot software"
  puts "  * output-directory (optional): Directory to write the individual invoices to (defaults to same directory as all-invoices file)"
  puts ""
  exit
end

unless output_directory = ARGV.shift
  output_directory = File.dirname(invoices_file)
end

# Read all the invoices into memory
invoices = File.read(invoices_file)

invoice = ''
invoices.each do |line|
  # Form feed/page eject (\f) represents end of page (as this format is designed to be printed)
  # /PLEASE PAY BY/ ensures that we deal with multi-page invoices (rather than blindly splitting on form feed)
  if line =~ /^\f/ and invoice =~ /PLEASE PAY BY/
    account_number = invoice[/ACCOUNT: (.*)$/, 1].chomp
    File.open(File.join(output_directory, "#{account_number}.txt"), 'w') { |f| f.puts(invoice) }
    invoice = ''
  else
    invoice << line
  end
end