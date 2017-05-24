require 'capybara'
require 'capybara/accessible/auditor'
require 'capybara/accessible/extensions/element'
require 'capybara/accessible/extensions/driver'
require 'capybara/accessible/version'
require 'capybara/accessible/railtie' if defined?(Rails)

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
        driver.extend(Capybara::Accessible::Extensions::Driver)
        driver
      end
    end
  end
end

Capybara.register_driver :accessible do |app|
  require 'capybara/accessible/adapters/selenium'
  puts "DEPRECATED: Please register this driver as 'accessible_selenium'"
  driver = Capybara::Selenium::Driver.new(app)
  adaptor = Capybara::Accessible::Adapters::Selenium.new
  Capybara::Accessible.setup(driver, adaptor)
end

Capybara.register_driver :accessible_selenium do |app|
  require 'capybara/accessible/adapters/selenium'
  driver = Capybara::Selenium::Driver.new(app)
  adaptor = Capybara::Accessible::Adapters::Selenium.new
  Capybara::Accessible.setup(driver, adaptor)
end

Capybara.register_driver :accessible_webkit do |app|
  require 'capybara/accessible/adapters/webkit'
  driver = Capybara::Webkit::Driver.new(app)
  adaptor = Capybara::Accessible::Adapters::Webkit.new
  Capybara::Accessible.setup(driver, adaptor)
end

Capybara.register_driver :accessible_poltergeist do |app|
  require 'capybara/accessible/adapters/poltergeist'
  driver = Capybara::Poltergeist::Driver.new(app)
  adaptor = Capybara::Accessible::Adapters::Poltergeist.new
  Capybara::Accessible.setup(driver, adaptor)
end
