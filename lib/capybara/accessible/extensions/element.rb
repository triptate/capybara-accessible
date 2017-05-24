require 'capybara/accessible/auditor'

module Capybara::Accessible
  module Extensions
    module Element
      def click
        super
        Auditor.new(@session.driver).audit!
      end
    end
  end
end

class Capybara::Node::Element
  prepend Capybara::Accessible::Extensions::Element
end
