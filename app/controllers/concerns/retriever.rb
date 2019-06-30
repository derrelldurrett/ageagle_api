module Retriever
  extend ActiveSupport::Concern

  def weather_for_random_locations(points)
    random_lat_longs = get_random_lat_longs how_many_points(points)
    weather_for(random_lat_longs)
  end

  private

  DENSITY = 5000 # RNG produces integers, so max integer size
  LAT_SCALE = 90.0 # 90 degrees pole-to-pole
  LONG_SCALE = 180.0 # +/- 180 degrees of longitude
  MAX_PTS_PER_REQ = 5000 # get 2 points each, and the API limits to 10k results

  def build_rng_url(n)
    "https://www.random.org/integers/?num=#{n*2}&min=-#{DENSITY}&max=#{DENSITY}&col=2&base=10&format=plain&rnd=new"
  end

  def get_random_lat_longs(n_points)
    out = []
    while n_points > 0 do
      points_to_get = n_points > MAX_PTS_PER_REQ ? MAX_PTS_PER_REQ : n_points
      extract_from_response(out, points_to_get)
      n_points -= 5000
    end
    out.map { |o| [rand_to_lat(o[0].to_f), rand_to_lon(o[1].to_i)] }
  end

  def extract_from_response(out, points_to_get)
    response = nil
    until not response.nil? and response.code == 200 do
      response = RestClient.get build_rng_url(points_to_get)
    end
    response.body.split("\n").each_with_object(out) {|dat, res| res << dat.split(' ')}
  end

  def how_many_points(p)
    ((not p.nil? and p.key?(:num)) and not p[:num].nil?) ? p[:num].to_i : 1
  end

  # This way we modify the distribution of points so it's equally distributed over the surface of a sphere
  # acos([-1,1])*180.0/PI - 90.0 => [90.0,-90.0]
  # cf: https://corysimon.github.io/articles/uniformdistn-on-sphere/
  def rand_to_lat(r)
    Math.acos(r/DENSITY)*LONG_SCALE/Math::PI - LAT_SCALE
  end

  def rand_to_lon(r)
    r*LONG_SCALE/DENSITY
  end

  def weather_for(locations)
    out = []
    locations.each do |lat_long|
      lat, long = lat_long
      response = nil
      until not response.nil? and response.code == 200  do
        response = RestClient.get "api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{long}&APPID=#{ENV['APPID']}"
      end
      out << JSON.parse(response.body)
    end
    out
  end
end