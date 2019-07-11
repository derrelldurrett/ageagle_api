Given 'I have a page that has a form that accepts a number' do
  visit '/dashboard'
  expect(page).to have_content('Enter # of points to display')
end

When 'I enter {int} points to display' do |n_points|
  fill_in 'enter-points', with: n_points
  click_button 'See Weather'
end

Then 'I expect to see {int} points with temperatures' do |n_points|
  # This cannot (at the moment) be done, because the map interface doesn't allow us to query the data.
  expect('.map').to have_content('some content') # ?
end