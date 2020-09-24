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
    neos = NearEarthObjects.asteroids_list_data('2019-03-30')
    assert_equal Faraday::Response, neos.class
  end

  def test_it_has_an_array_hashes_of_neos
    neos = NearEarthObjects.parsed_asteroids_data('2019-03-30')
    assert_equal Array, neos.class
    assert_equal Hash, neos.first.class
    assert_equal "(2019 GD4)", neos.first[:name]
  end
  
  def test_a_date_returns_a_list_of_neos
    results = NearEarthObjects.find_neos_by_date('2019-03-30')
    assert_equal '(2019 GD4)', results[:astroid_list][0][:name]
  end
end
