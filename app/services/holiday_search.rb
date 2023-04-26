class HolidaySearch

  def service
    NagerDateService.new
  end

  def holiday_info
    HolidayInfo.new(service.holidays)
  end
end