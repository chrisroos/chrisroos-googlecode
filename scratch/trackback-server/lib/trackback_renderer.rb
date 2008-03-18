require File.join(File.dirname(__FILE__), 'weekday_suffix')

class TrackbackRenderer
  
  def initialize(trackback)
    @trackback = trackback
  end
  
  def received_on
    weekday, month = @trackback['received_at'].strftime("%A %B").split(' ')
    "#{weekday} #{received_at_day_with_suffix} #{month}"
  end
  
  def received_at
    hour, am_or_pm = @trackback['received_at'].strftime("%I %p").split(' ')
    hour = hour.gsub(/^0/, '') # Remove leading zero, so 08 becaomes 8
    am_or_pm = am_or_pm.downcase
    [hour, am_or_pm].join('')
  end
  
private

  def received_at_day_with_suffix
    day = @trackback['received_at'].day
    suffix = WeekdaySuffix.new(day).suffix
    [day, suffix].join('')
  end
  
end