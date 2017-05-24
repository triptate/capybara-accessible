module Capybara::Accessible
  module Adapters
    class Selenium
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
  end
end
