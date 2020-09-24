require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def test_it_exists
    neos = NearEarthObjects.new
    assert_instance_of NearEarthObjects, neos
  end

  def test_it_has_a_connection
    neos = NearEarthObjects.conn('2019-03-30')
    assert_equal Faraday::Connection, neos.class
  end

  def test_it_has_a_response
    # skip
    neos = NearEarthObjects.asteroids_list_data('2019-03-30')
    assert_equal Faraday::Response, neos.class
  end

  def test_it_has_an_array_hashes_of_neos
    # skip
    neos = NearEarthObjects.parsed_asteroids_data('2019-03-30')
    assert_equal Array, neos.class
    assert_equal Hash, neos.first.class
    assert_equal "(2019 GD4)", neos.first[:name]
  end

  def test_it_can_find_asteroids_diameter
    neos_diameter = NearEarthObjects.estimated_diameter_feet('2019-03-30')
    assert_equal Hash, neos_diameter.first.class
    assert_equal 27, neos_diameter.first[:estimated_diameter_min].floor
  end

  def test_it_can_find_the_largest_astroid
    neos_largest = NearEarthObjects.largest_astroid_diameter('2019-03-30')
    assert_equal 10233, neos_largest
  end

  def test_it_can_find_total_number_of_astroids
    neos_count = NearEarthObjects.total_number_of_astroids('2019-03-30')
    assert_equal 12, neos_count
  end

  def test_astroids_has_attributes
    neo = NearEarthObjects.formatted_asteroid_data('2019-03-30')
    assert_equal "(2019 GD4)", neo.first[:name]
    assert_equal "61 ft", neo.first[:diameter]
    assert_equal "911947 miles", neo.first[:miss_distance]
  end

  def test_a_date_returns_a_list_of_neos
    results = NearEarthObjects.find_neos_by_date('2019-03-30')
    assert_equal '(2019 GD4)', results[:astroid_list][0][:name]
  end
end
