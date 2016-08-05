require 'rspec'
require 'capybara'
require 'capybara/spec/spec_helper'
require 'capybara/accessible'
require 'capybara/poltergeist'
require 'capybara/webkit'

require 'accessible_app'

RSpec.configure do |c|
  Capybara::SpecHelper.configure(c)
  c.around(:each, :inaccessible => true) do |example|
    Capybara::Accessible.skip_audit { example.run }
  end
end

Capybara.current_driver = :accessible
