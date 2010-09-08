module Rackspace
  class << self
    if Fog.credentials[:rackspace_api_key] && Fog.credentials[:rackspace_username]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :compute
            Fog::Rackspace::Compute.new
          when :files
            location = caller.first
            warning = "[yellow][WARN] Rackspace[:files] is deprecated, use Rackspace[:storage] instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            Fog::Rackspace::Storage.new
          when :servers
            location = caller.first
            warning = "[yellow][WARN] Rackspace[:servers] is deprecated, use Rackspace[:compute] instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            Fog::Rackspace::Compute.new
          when :storage
            Fog::Rackspace::Storage.new
          end
        end
        @@connections[service]
      end

      def services
        [:compute, :storage]
      end

      for collection in Fog::Rackspace::Compute.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:compute].#{collection}
          end
        EOS
      end

      for collection in Fog::Rackspace::Storage.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:storage].#{collection}
          end
        EOS
      end

    else

      def initialized?
        false
      end

    end
  end
end
