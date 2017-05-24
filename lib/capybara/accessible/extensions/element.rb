require 'capybara/accessible/auditor'

module Capybara::Accessible
  module Extensions
    module Element
      def click
        super
        driver = @session.driver
        if driver.respond_to?(:accessible)
          Auditor.new(@session.driver).audit!
        end
      end
    end
  end
end

class Capybara::Node::Element
  prepend Capybara::Accessible::Extensions::Element
end
