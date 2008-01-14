require 'fileutils'

stop_at_revision = ARGV[0]
raise "Please specify the revision that you wish to go back to as the only argument to this script." unless stop_at_revision
stop_at_revision = Integer(stop_at_revision)

class Time
  def friendly_format
    strftime("%Y-%m-%d %H:%M:%S")
  end
end

def msg(message)
  puts "#{Time.now.friendly_format} - #{message}"
end

def produce_diff(revisions, earlier_revision = nil)
  if revisions.empty?
    msg "All finished."
    exit
  end
  
  later_revision = earlier_revision ? earlier_revision : revisions.shift
  earlier_revision = revisions.shift

  msg "Creating diff from revision #{earlier_revision} to #{later_revision}."
  `svn diff -r#{earlier_revision}:#{later_revision} > patches/#{later_revision}.patch`
  produce_diff(revisions, earlier_revision)
end

FileUtils.mkdir_p 'patches'

msg "Scanning output of svn log to find all revisions that we care about..."
log = `svn log -rHEAD:#{stop_at_revision} -q`
revisions = log.scan(/^r(\d+)/)
revisions = revisions.flatten.collect { |revision| Integer(revision) }

produce_diff(revisions)