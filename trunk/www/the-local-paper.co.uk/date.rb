class Date
  def iso8601
    Time.parse(self.to_s).iso8601
  end
end