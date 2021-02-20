# frozen_string_literal: true

module FillersRemover
  class Wav
    Format =
      ::Struct.new(:id, :bit_depth, :channel, :hz, keyword_init: true) do
        def initialize(**kwargs)
          super(**kwargs)
          freeze
        end

        # NOTE: This method is only for compatibility with wav-file gem
        def to_bin
          [
            [id].pack("v"),
            [channel].pack("v"),
            [hz].pack("V"),
            [byte_per_second].pack("V"),
            [block_size].pack("v"),
            [bit_depth].pack("v")
          ].join
        end

        def block_size
          channel * bit_depth / 8
        end

        def byte_per_second
          hz * block_size
        end
      end
    public_constant :Format
  end
end
