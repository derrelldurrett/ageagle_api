mapboxgl.accessToken = 'pk.eyJ1IjoiZGRkLWFnZWFnbGUtdGVzdCIsImEiOiJjanhrcDE5aWQxeHdpM3JtZjhmNnQwdjk0In0.wLnCeTJyu71mXE8Nz1SIpg'

addGeoJsonLayer = (weatherData, map) ->
  weatherData = toGeoJson(weatherData)
  if map.getLayer('weather')?
    map.removeSource('temps') if map.getSource('temps')
    map.addSource('temps', weatherData)
  else
    map.addLayer
      'id': 'weather'
      'type': 'symbol'
      'source':
        'type': 'geojson'
        'data': weatherData
      'layout':
        'visibility': 'visible'
        'text-field': '{temp}'
  map.setLayoutProperty('weather', 'visibility', 'visible')

buildDat = (d) ->
    'type': 'Feature',
    'geometry':
      'type': 'Point'
      'coordinates': [d['coord']['lon'],d['coord']['lat']]
    'properties':
      'temp': d['main']['temp']


callForWeatherData = (inputField, map) ->
  # probably should clear the existing points?
  # call the /points endpoint with AJAX to get the weather data
  $.ajax "/points",
    type: 'GET'
    data: {'points': {'n_points': inputField.value}}
    dataType: 'json'
    success: (result) ->
      addGeoJsonLayer(result, map)
    error: (xhr,status,err) ->
      handleNoWeatherData(xhr,status,err)

handleNoWeatherData = (xhr,status,err) ->
  alert err

loadMap = () ->
  new mapboxgl.Map { container: 'map', style: 'mapbox://styles/mapbox/streets-v11'}

reduceWxData = (data) ->
  buildDat dat for dat in data

toGeoJson = (wxData) ->
  # turn the weather data into GeoJSON
  out =
    'type': 'FeatureCollection'
    'features': reduceWxData(wxData)

$ ->
  map = loadMap()
  $('button#enter-points-btn').on 'click', (b) => callForWeatherData($('input#enter-points-inp')[0], map)
