require 'capybara/accessible/auditor'

module Capybara::Accessible
  module Extensions
    module Driver
      def visit(path)
        super
        Auditor::Driver.new(self).audit!
      end
    end
  end
end
