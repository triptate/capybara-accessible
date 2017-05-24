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

      def create_driver(base_driver, driver_adaptor, app)
        driver_class = Capybara::Accessible::Extensions::Driver.wrap(base_driver)
        driver = driver_class.new(app)
        driver.accessible = driver_adaptor.new
        driver
      end
    end
  end
end

Capybara.register_driver :accessible do |app|
  puts "DEPRECATED: Please register this driver as 'accessible_selenium'"
  require 'capybara/accessible/adapters/selenium'
  Capybara::Accessible.create_driver(
    Capybara::Selenium::Driver,
    Capybara::Accessible::Adapters::Selenium,
    app,
  )
end

Capybara.register_driver :accessible_selenium do |app|
  require 'capybara/accessible/adapters/selenium'
  Capybara::Accessible.create_driver(
    Capybara::Selenium::Driver,
    Capybara::Accessible::Adapters::Selenium,
    app,
  )
end

Capybara.register_driver :accessible_webkit do |app|
  require 'capybara/accessible/adapters/webkit'
  Capybara::Accessible.create_driver(
    Capybara::Webkit::Driver,
    Capybara::Accessible::Adapters::Webkit,
    app,
  )
end

Capybara.register_driver :accessible_poltergeist do |app|
  require 'capybara/accessible/adapters/poltergeist'
  Capybara::Accessible.create_driver(
    Capybara::Poltergeist::Driver,
    Capybara::Accessible::Adapters::Poltergeist,
    app,
  )
end
