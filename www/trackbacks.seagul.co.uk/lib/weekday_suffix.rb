class WeekdaySuffix
  
  def initialize(day)
    @day = day
  end
  
  def suffix
    case @day
    when 1, 21, 31 then 'st'
    when 2, 22 then 'nd'
    when 3, 23 then 'rd'
    else 'th'
    end
  end
  
end