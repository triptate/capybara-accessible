require 'capybara'
require 'capybara/accessible/adapters'
require 'capybara/accessible/auditor'
require 'capybara/accessible/capybara_extensions'
require 'capybara/accessible/driver_extensions'
require "capybara/accessible/version"
require "capybara/accessible/railtie" if defined?(Rails)

module Capybara
  module Accessible
    class << self
      def skip_audit
        Capybara::Accessible::Auditor.disable
        yield
      ensure
        Capybara::Accessible::Auditor.enable
      end

      def driver_adapter
        @driver_adapter
      end

      def setup(driver, adaptor)
        @driver_adapter = adaptor
        driver.extend(Capybara::Accessible::DriverExtensions)
        driver
      end
    end
  end
end

Capybara.register_driver :accessible do |app|
  puts "DEPRECATED: Please register this driver as 'accessible_selenium'"
  Capybara::Accessible.driver.wrap(Capubara::Selenium::Driver).new(app)
  driver = Capybara::Selenium::Driver.new(app)
  adaptor = Capybara::Accessible::SeleniumDriverAdapter.new
  Capybara::Accessible.setup(driver, adaptor)
end

Capybara.register_driver :accessible_selenium do |app|
  driver = Capybara::Selenium::Driver.new(app)
  adaptor = Capybara::Accessible::SeleniumDriverAdapter.new
  Capybara::Accessible.setup(driver, adaptor)
end

Capybara.register_driver :accessible_webkit do |app|
  driver = Capybara::Webkit::Driver.new(app)
  adaptor = Capybara::Accessible::WebkitDriverAdapter.new
  Capybara::Accessible.setup(driver, adaptor)
end

Capybara.register_driver :accessible_poltergeist do |app|
  driver = Capybara::Poltergeist::Driver.new(app)
  adaptor = Capybara::Accessible::PoltergeistDriverAdapter.new
  Capybara::Accessible.setup(driver, adaptor)
end
