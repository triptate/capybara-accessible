module Capybara
  module Accessible
    class PoltergeistDriverAdapter
      def modal_dialog_present?(driver)
        false
      end

      def failures_script
        'return axs.Audit.auditResults(results).getErrors()'
      end

      def create_report_script
        'return axs.Audit.createReport(results)'
      end

      def run_javascript(driver, script)
        # Have to wrap in an anonymous function because of https://github.com/jonleighton/poltergeist/issues/198
        driver.evaluate_script %{ (function() {#{script}})() }
      end
    end

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
        'return axs.Audit.auditResults(results).getErrors();'
      end

      def create_report_script
        'return axs.Audit.createReport(results);'
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
        'axs.Audit.auditResults(results).getErrors();'
      end

      def create_report_script
        'axs.Audit.createReport(results);'
      end

      def run_javascript(driver, script)
        driver.evaluate_script(script)
      end
    end
  end
end
