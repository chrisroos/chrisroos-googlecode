# DOWNLOAD RUBY 1.8.5 ONE CLICK INSTALLER
# DONWLOAD 7ZIP COMMAND LINE ONLY

require 'net/ftp'
require 'date'

today = Date.today.strftime
yesterday = (Date.today - 1).strftime

ZIP_PROG = 'c:/bin/7za.exe'
APC_DIR = 'c:/documents and settings/chris/desktop/'
DATA_DIR = APC_DIR + 'data'
BACKUP_DIR = APC_DIR + 'backup'
BACKUP_FILENAME = "#{BACKUP_DIR}/#{today}.7z"
FTP_SITE = 'FTP_SITE'
FTP_USERNAME = 'FTP_USERNAME'
FTP_PASSWORD = 'FTP_PASSWORD'
FTP_BACKUP_DIR = 'FTP_BACKUP_DIR'

cmd = %Q[#{ZIP_PROG} a "#{BACKUP_FILENAME}" "#{DATA_DIR}"]
cmd_output = `#{cmd}`
if cmd_output =~ /Everything is Ok/
  puts "* Compressed data directory..."
  Net::FTP.open(FTP_SITE) do |ftp|
    begin
      ftp.passive = true
      ftp.login(FTP_USERNAME, FTP_PASSWORD)
      ftp.chdir(FTP_BACKUP_DIR)
      puts "* Copying compressed data directory to ftp..."
      ftp.putbinaryfile(BACKUP_FILENAME)
      puts "* Deleting yesterdays backup..."
      ftp.delete("#{yesterday}.7z")
    rescue Net::FTPPermError => e
      if e.message =~ /^550 Could not delete/
        puts "* Couldn't find yesterday's backup file.  Skipping delete..."
      else
        puts "*** FTP Error: #{e}"
      end
    rescue Exception => e
      puts "*** Error: #{e}"
    ensure
      puts "* Backup complete."
    end
  end
else
  puts "* There was an error compressing the data directory..."
end