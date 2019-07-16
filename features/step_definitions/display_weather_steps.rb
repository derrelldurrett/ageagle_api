Given 'I have a page that has a form that accepts a number' do
  visit '/dashboard'
  expect(page).to have_content('Enter # of points to display')
end

When 'I enter {int} points to display' do |n_points|
  fill_in 'enter-points', with: n_points
  click_button 'See Weather'
  sleep 5
end

Then 'I expect to see {int} points with temperatures' do |n_points|
  temps = page.evaluate_script("window.map.getSource('temps')._data.features")
  expect(temps.length).to be(5) #
end