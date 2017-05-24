module Capybara::Accessible
  module Adapters
    class Selenium
      def failures_script
        'return axs.Audit.auditResults(results).getErrors();'
      end

      def create_report_script
        'return axs.Audit.createReport(results);'
      end

      def run_javascript(driver, script)
        driver.execute_script(script)
      rescue ::Selenium::WebDriver::Error::UnhandledAlertError
        puts 'Skipping accessibility audit: Modal dialog present'
        nil
      end
    end
  end
end
