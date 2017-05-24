require 'capybara/accessible/auditor'

module Capybara::Accessible
  module Extensions
    module Driver
      def self.wrap(underlying_driver)
        Class.new(underlying_driver) do
          include Extensions::Driver

          def self.name
            "Capybara::Accessible::Extensions::Driver(wrap: #{underlying_driver}"
          end
          class << self
            alias_method :inspect, :name
            alias_method :to_s, :name
          end
        end
      end

      attr_accessor :accessible

      def visit(path)
        super
        Auditor.new(self).audit!
      end
    end
  end
end
