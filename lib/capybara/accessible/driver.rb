module Capybara::Accessible
  class Driver
    def self.wrap(underlying_driver)
      Class.new(underlying_driver) do
        include InstanceMethods
    end

    module InstanceMethods
      attr_writer :accessible

      def visit(path)
        super
        Auditor.audit(self)
      end
    end
  end
end
