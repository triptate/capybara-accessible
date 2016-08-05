require 'capybara'
require 'capybara/accessible'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/webkit'

require 'accessible_app'

RSpec.configure do |c|
  c.around(:each, :inaccessible => true) do |example|
    Capybara::Accessible.skip_audit { example.run }
  end
end

Capybara.app = AccessibleApp
