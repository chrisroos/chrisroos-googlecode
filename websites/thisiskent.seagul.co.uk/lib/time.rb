class Time
  class << Time
    
    def parse(date, now=Time.now)
      d = Date._parse(date, false)
      year = d[:year]
      year = yield(year) if year && block_given?
      make_time(year, d[:mon], d[:mday], d[:hour], d[:min], d[:sec], d[:sec_fraction], d[:zone], now)
    end
    
    def xmlschema(date)
      if /\A\s*
          (-?\d+)-(\d\d)-(\d\d)
          T
          (\d\d):(\d\d):(\d\d)
          (\.\d*)?
          (Z|[+-]\d\d:\d\d)?
          \s*\z/ix =~ date
        year = $1.to_i
        mon = $2.to_i
        day = $3.to_i
        hour = $4.to_i
        min = $5.to_i
        sec = $6.to_i
        usec = 0
        usec = $7.to_f * 1000000 if $7
        if $8
          zone = $8
          year, mon, day, hour, min, sec =
            apply_offset(year, mon, day, hour, min, sec, zone_offset(zone))
          Time.utc(year, mon, day, hour, min, sec, usec)
        else
          Time.local(year, mon, day, hour, min, sec, usec)
        end
      else
        raise ArgumentError.new("invalid date: #{date.inspect}")
      end
    end
    alias iso8601 xmlschema
    
    def make_time(year, mon, day, hour, min, sec, sec_fraction, zone, now)
      usec = nil
      usec = (sec_fraction * 1000000).to_i if sec_fraction
      if now
        begin
          break if year; year = now.year
          break if mon; mon = now.mon
          break if day; day = now.day
          break if hour; hour = now.hour
          break if min; min = now.min
          break if sec; sec = now.sec
          break if sec_fraction; usec = now.tv_usec
        end until true
      end

      year ||= 1970
      mon ||= 1
      day ||= 1
      hour ||= 0
      min ||= 0
      sec ||= 0
      usec ||= 0

      off = nil
      off = zone_offset(zone, year) if zone

      if off
        year, mon, day, hour, min, sec =
          apply_offset(year, mon, day, hour, min, sec, off)
        t = Time.utc(year, mon, day, hour, min, sec, usec)
        t.localtime if !zone_utc?(zone)
        t
      else
        self.local(year, mon, day, hour, min, sec, usec)
      end
    end
    private :make_time
    
  end
  
  def xmlschema(fraction_digits=0)
    sprintf('%d-%02d-%02dT%02d:%02d:%02d',
      year, mon, day, hour, min, sec) +
    if fraction_digits == 0
      ''
    elsif fraction_digits <= 6
      '.' + sprintf('%06d', usec)[0, fraction_digits]
    else
      '.' + sprintf('%06d', usec) + '0' * (fraction_digits - 6)
    end +
    if utc?
      'Z'
    else
      off = utc_offset
      sign = off < 0 ? '-' : '+'
      sprintf('%s%02d:%02d', sign, *(off.abs / 60).divmod(60))
    end
  end
  alias iso8601 xmlschema
  
end