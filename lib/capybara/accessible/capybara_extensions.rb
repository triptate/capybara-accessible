require 'capybara/accessible/element'

class Capybara::Node::Element
  prepend Capybara::Accessible::Element
end
