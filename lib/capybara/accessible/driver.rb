require 'capybara/accessible/auditor'

module Capybara::Accessible
  module Driver
    def self.wrap(underlying_driver)
      Class.new(underlying_driver) do
        include InstanceMethods

        def name
          "Capybara::Accessible::Driver(#{underlying_driver})".freeze
        end
        alias_method :inspect, :name
        alias_method :to_s, :name
      end
    end

    module InstanceMethods
      def visit(*args, &block)
        super(*args, &block)
        auditor.run(self)
      end

      private

      def auditor
        @auditor ||= Auditor.new(self)
      end
    end
    private_const :InstanceMethods
  end
end
