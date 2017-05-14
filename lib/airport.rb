require './lib/weather'
require './lib/airplane'

class Airport

  attr_accessor :current_capacity
  attr_reader :airplanes

  def initialize(capacity = 20)
    @current_capacity = capacity
    @airplanes = []
    @weather = Weather.new
  end

  def show_status_of_airplanes
    "Grounded: #{check_number_of_grounded_planes}, Airborne: #{check_number_of_airborne_planes}"
  end

  def allow_airplane_to_land
    contact_approaching_airplane
    fail "Permission to land denied" if permission_to_land? == false
    @approaching_airplane.land
    @airplanes << @approaching_airplane
  end

  def allow_airplane_to_take_off
    fail "Permission to take off denied" if permission_to_take_off? == false
    contact_departing_airplane
    @departing_airplane.take_off
    @airplanes << @departing_airplane
  end

  def at_capacity?
    if check_number_of_grounded_planes >= @current_capacity
      true
    else
      false
    end
  end

  def permission_to_land?
    if @weather.check_current_weather_condition == "sunny" && at_capacity? == false
      true
    else
      false
    end
  end

  def permission_to_take_off?
    if @weather.check_current_weather_condition == "sunny"
      true
    else
      false
    end
  end

  private

  def contact_approaching_airplane
    @approaching_airplane = Airplane.new
  end

  def contact_departing_airplane
    @departing_airplane = pop_first_grounded_airplane
  end

  def pop_first_grounded_airplane
    first_grounded_airplane = @airplanes.find do
      |airplane| airplane.check_current_status == "grounded"
    end
    @airplanes.delete_if do
      |target_airplane| target_airplane == @airplanes.find do
        |airplane| airplane.check_current_status == "grounded"
      end
    end
    first_grounded_airplane
  end

  def check_number_of_grounded_planes
    @airplanes.count { |airplane| airplane.check_current_status == "grounded" }
  end

  def check_number_of_airborne_planes
    @airplanes.count { |airplane| airplane.check_current_status == "airborne" }
  end
end
