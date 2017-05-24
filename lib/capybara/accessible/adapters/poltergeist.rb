module Capybara::Accessible
  module Adapters
    class Poltergeist
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
  end
end
