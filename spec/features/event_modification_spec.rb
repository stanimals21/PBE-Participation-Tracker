require 'rails_helper'

admin_email = 'admin@example.com'
admin_password = 'p'

# Make sure that the new event page is visitable.
RSpec.describe 'Visit the new event page' do

  it 'Goes to the new event page.' do

    Customer.create(:first_name => 'John', :last_name => 'Smith', :role => 'admin', :email => admin_email, :password => admin_password)
    
    visit('/')
    click_on('Login')
  
    fill_in('email', :with => admin_email)
    fill_in('password', :with => admin_password)
    click_on('Log In')
    expect(current_path).to eql('/events')

    visit('/events')
    click_on('Add new event')
    expect(current_path).to eql('/events/new')
    expect(page).to have_content('Title')
    expect(page).to have_content('Description')
    expect(page).to have_content('Date')
    expect(page).to have_content('Location')
    expect(page).to have_content('Mandatory')

  end

end

# Fill out form contents.
RSpec.describe 'Create a new event.' do
  
  it 'Displays a new event in the index.' do
  
    # Log in
    Customer.create(:first_name => 'John', :last_name => 'Smith', :role => 'admin', :email => admin_email, :password => admin_password)
    
    visit('/')
    click_on('Login')
  
    fill_in('email', :with => admin_email)
    fill_in('password', :with => admin_password)
    click_on('Log In')
    expect(current_path).to eql('/events')

    # Create new event.
    click_on('Add new event')
    fill_in('event_title', :with => 'TEST EVENT ONE')
    fill_in('event_location', :with => 'TEST LOCATION ONE')
    click_on('Submit')

    # Look for event in the index.
    expect(current_path).to eql('/events')
    expect(page).to have_content('TEST EVENT ONE')

  end

end

# Successfully edit event.
RSpec.describe 'Edit an event.' do

  it 'Changes the name of the created event.' do
  
    # Login
    Customer.create(:first_name => 'John', :last_name => 'Smith', :role => 'admin', :email => admin_email, :password => admin_password)
    
    visit('/')
    click_on('Login')
  
    fill_in('email', :with => admin_email)
    fill_in('password', :with => admin_password)
    click_on('Log In')
    expect(current_path).to eql('/events')

    # Setting up event:
    click_on('Add new event')
    fill_in('event_title', :with => 'TEST EVENT ONE')
    fill_in('event_location', :with => 'TEST LOCATION ONE')
    click_on('Submit')

    expect(current_path).to eql('/events')
    expect(page).to have_content('TEST EVENT ONE')

    # Editing:
    all('a', :text => 'Edit')[0].click
    expect(page).to have_content('Title')
    fill_in('event_title', :with => 'EDITED EVENT TITLE')
    click_on('Submit')

    expect(current_path).to eql('/events')
    expect(page).to have_content('EDITED EVENT TITLE')	

  end

end

# Attempt to pass a null value into title (a required field). This
# should prevent the user from creating the event and return them
# back to the new event page.
# Only appears to work if js == true, but fails otherwise.
RSpec.describe 'Attempt to make an event title null.' do

  it 'Redirects user back to new event page.' do

    # Login
    Customer.create(:first_name => 'John', :last_name => 'Smith', :role => 'admin', :email => admin_email, :password => admin_password)
    
    visit('/')
    click_on('Login')
  
    fill_in('email', :with => admin_email)
    fill_in('password', :with => admin_password)
    click_on('Log In')
    expect(current_path).to eql('/events')

    # Attempt to create a new event.
    visit('/events/new')
    click_on('Submit')

    expect(current_path).to eql('/events')

  end
end



# Attempt to edit an event such that the title now has a null value.
# Similarly to the previous test, it also only appears to work if
# js == true.
RSpec.describe 'Change title to null.' do

  it 'Redirects the user back to the edit page.' do
  
    # Login
    Customer.create(:first_name => 'John', :last_name => 'Smith', :role => 'admin', :email => admin_email, :password => admin_password)
    
    visit('/')
    click_on('Login')
  
    fill_in('email', :with => admin_email)
    fill_in('password', :with => admin_password)
    click_on('Log In')
    expect(current_path).to eql('/events')
  
  
    # Edit the title to become null.
    visit('/events/new')
    fill_in('event_title', :with => 'TEST EVENT ONE')
    fill_in('event_location', :with => 'TEST LOCATION ONE')
    click_on('Submit')

    expect(current_path).to eql('/events')
    all('a', :text => 'Edit')[0].click
    fill_in('event_title', :with => '')
    click_on('Submit')

    expect(current_path).to eql('/events')

  end

end

# Attempt to delete an event.
RSpec.describe 'Delete an event.' do

  it 'Removes an event from the index.' do
  
    # Login
    Customer.create(:first_name => 'John', :last_name => 'Smith', :role => 'admin', :email => admin_email, :password => admin_password)
    
    visit('/')
    click_on('Login')
  
    fill_in('email', :with => admin_email)
    fill_in('password', :with => admin_password)
    click_on('Log In')
    expect(current_path).to eql('/events')

    # Create the event.
    visit('/events/new')
    fill_in('event_title', :with => 'TEST EVENT ONE')
    fill_in('event_location', :with => 'TEST LOCATION ONE')
    click_on('Submit')

    expect(current_path).to eql('/events')
    expect(page).to have_content('TEST EVENT ONE')

    # Delete the event.
    all('a', :text => 'Delete')[0].click
    expect(current_path).to include('delete')
    click_on('Delete Event')

    # Make sure event is no longer in the index.
    expect(current_path).to eql('/events')
    expect(page).to have_no_content('TEST EVENT ONE')


  end

end



# Show an event.
RSpec.describe 'Show an event.' do

  it 'Displays event details.' do
  
    # Login
    Customer.create(:first_name => 'John', :last_name => 'Smith', :role => 'admin', :email => admin_email, :password => admin_password)
    
    visit('/')
    click_on('Login')
  
    fill_in('email', :with => admin_email)
    fill_in('password', :with => admin_password)
    click_on('Log In')
    expect(current_path).to eql('/events')

    # Create the event.
    visit('/events/new')
    fill_in('event_location', :with => 'TEST LOCATION ONE')
    fill_in('event_title', :with => 'TEST EVENT ONE')
    click_on('Submit')
    expect(current_path).to eql('/events')

    # Show the event.
    all('a', :text => 'Show')[0].click
	
    expect(page).to have_content('Event name')
    expect(page).to have_content('TEST LOCATION ONE')

    expect(page).to have_content('Location')
    expect(page).to have_content('TEST LOCATION ONE')

  end
end


# Set the date of an event.
RSpec.describe 'Set date of an event.' do

  it 'Shows a different date.' do
  
    # Login
    Customer.create(:first_name => 'John', :last_name => 'Smith', :role => 'admin', :email => admin_email, :password => admin_password)
    
    visit('/')
    click_on('Login')
  
    fill_in('email', :with => admin_email)
    fill_in('password', :with => admin_password)
    click_on('Log In')
    expect(current_path).to eql('/events')

    # Create event.
    visit('/events/new')
    fill_in('event_location', :with => 'TEST LOCATION ONE')
    fill_in('event_title', :with => 'TEST EVENT ONE')
    select('2024', :from => 'event_date_1i')
    select('February', :from => 'event_date_2i')
    select('15', :from => 'event_date_3i')
    select('17', :from => 'event_date_4i')
    select('30', :from => 'event_date_5i')
    click_on('Submit')	
    expect(current_path).to eql('/events')

    # Show event.
    all('a', :text => 'Show')[0].click
    expect(page).to have_content('2024-02-15 17:30:00 UTC')

  end

end
