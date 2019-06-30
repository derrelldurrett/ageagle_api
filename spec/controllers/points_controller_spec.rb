require 'rails_helper'

RSpec.describe PointsController, type: :controller do
  context 'get points' do
    it 'defaults to returning one point' do
      get :show
      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an Array
      expect(json_response.length).to eq(1)
    end

    it 'returns a defined number of points' do
      points_expected = 5
      get :show, params: {points: {num: points_expected}}
      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an Array
      expect(json_response.length).to eq(points_expected)
    end

    def noop
    end

    COORD_K = 'coord'
    LAT_K = 'lat'
    LON_K = 'lon'
    MAIN_K = 'main'
    TEMP_K = 'temp'
    TMIN_K = 'temp_min'
    TMAX_K = 'temp_max'

    it 'returns weather data along with the coordinates' do
      get :show
      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an Array
      expect(json_response.length).to eq(1)
      wx_data = json_response.first
      expect(wx_data).to be_a Hash
      expect(wx_data.key? COORD_K).to be_truthy
      expect(wx_data[COORD_K]).to be_a Hash
      expect(wx_data[COORD_K].key? LAT_K).to be_truthy
      expect(wx_data[COORD_K].key? LON_K).to be_truthy
      expect(wx_data.key? MAIN_K).to be_truthy
      expect(wx_data[MAIN_K].key? TEMP_K).to be_truthy
      expect(wx_data[MAIN_K].key? TMIN_K).to be_truthy
      expect(wx_data[MAIN_K].key? TMAX_K).to be_truthy
    end
  end
end
