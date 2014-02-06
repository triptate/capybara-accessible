require 'capybara'
require 'capybara/accessible/auditor'
require 'capybara/accessible/element'
require 'capybara/accessible/driver_extensions'
require "capybara/accessible/version"
require "capybara/accessible/railtie" if defined?(Rails)

module Capybara
  module Accessible
    class SeleniumDriverAdapter
      def modal_dialog_present?(driver)
        begin
          driver.browser.switch_to.alert
          true
        rescue ::Selenium::WebDriver::Error::NoAlertOpenError, ::NoMethodError
          false
        end
      end

      def failures_script
        "return axs.Audit.auditResults(results).getErrors();"
      end

      def create_report_script
        "return axs.Audit.createReport(results);"
      end

      def run_javascript(driver, script)
        driver.execute_script(script)
      end
    end

    class WebkitDriverAdapter
      def modal_dialog_present?(driver)
        driver.alert_messages.any?
      end

      def failures_script
        "axs.Audit.auditResults(results).getErrors();"
      end

      def create_report_script
        "axs.Audit.createReport(results);"
      end

      def run_javascript(driver, script)
        driver.evaluate_script(script)
      end
    end

    class << self
      def skip_audit
        @disabled = true
        yield
      ensure
        @disabled = false
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
  driver = Capybara::Selenium::Driver.new(app)
  adaptor = Capybara::Accessible::SeleniumDriverAdapter.new
  Capybara::Accessible.setup(driver, adaptor)
end

Capybara.register_driver :webkit_accessible do |app|
  driver = Capybara::Webkit::Driver.new(app)
  adaptor = Capybara::Accessible::WebkitDriverAdapter.new
  Capybara::Accessible.setup(driver, adaptor)
end
