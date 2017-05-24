module Capybara::Accessible
  module Adapters
    class Webkit
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
