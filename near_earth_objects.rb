require 'faraday'
require 'figaro'
require 'pry'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects

  def self.conn(date) 
    Faraday.new(url: 'https://api.nasa.gov',params: { start_date: date, api_key: ENV['nasa_api_key']})
  end

  def self.asteroids_list_data(date)
    conn(date).get('/neo/rest/v1/feed')
  end

  def self.parsed_asteroids_data(date)
    JSON.parse(asteroids_list_data(date).body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end

  def self.find_neos_by_date(date)
    largest_astroid_diameter = parsed_asteroids_data(date).map do |astroid|
      astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}

    total_number_of_astroids = parsed_asteroids_data(date).count
    formatted_asteroid_data = parsed_asteroids_data(date).map do |astroid|
      {
        name: astroid[:name],
        diameter: "#{astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{astroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end

    {
      astroid_list: formatted_asteroid_data,
      biggest_astroid: largest_astroid_diameter,
      total_number_of_astroids: total_number_of_astroids
    }
  end
end
