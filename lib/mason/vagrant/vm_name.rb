require 'log4r'

module Mason
  module Vagrant
    # This component replaces
    # <tt>Vagrant::Action::VM::DefaultName</tt> in
    # <tt>Vagrant.actions.get(:up)</tt> to allow Mason to give the
    # VirtualBox VM a friendlier name.
    class VMName
      def self.install
        @installed ||= begin
                         builder = ::Vagrant.actions.get(:up)
                         builder.replace(::Vagrant::Action::VM::DefaultName, self)
                       end
      end

      def initialize(app, env)
        @logger = Log4r::Logger.new("mason::vagrant::vm_name")
        @app = app
      end

      def call(env)
        @logger.info("Setting the name of the VM")
        name = "mason_#{env[:vm].name}_#{Time.now.to_i}"
        env[:vm].driver.set_name(name)
        @app.call(env)
      end
    end
  end
end
