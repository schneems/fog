require 'fog/collection'
require 'fog/bluebox/models/compute/server'

module Fog
  module Bluebox
    class Compute

      class Servers < Fog::Collection

        model Fog::Bluebox::Compute::Server

        def all
          data = connection.get_blocks.body
          load(data)
        end

        def get(server_id)
          if server_id && server = connection.get_block(server_id).body
            new(server)
          end
        rescue Fog::Bluebox::Compute::NotFound
          nil
        end

      end

    end
  end
end
