module Capybara
  module Accessible
    module Element
      def click
        super
        Capybara::Accessible::Auditor::Node.new(@session).audit!
      end
    end
  end
end
