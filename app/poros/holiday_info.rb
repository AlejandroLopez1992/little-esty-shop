class HolidayInfo
  attr_reader :first_upcoming_holiday_name,
              :first_upcoming_holiday_date,
              :second_upcoming_holiday_name,
              :second_upcoming_holiday_date,
              :third_upcoming_holiday_name,
              :third_upcoming_holiday_date

  def initialize(data)
    @first_upcoming_holiday_name = data[0]["name"]
    @first_upcoming_holiday_date = data[0]["date"]
    @second_upcoming_holiday_name = data[1]["name"]
    @second_upcoming_holiday_date = data[1]["date"]
    @third_upcoming_holiday_name = data[2]["name"]
    @third_upcoming_holiday_date = data[2]["date"]
  end

end