# frozen_string_literal: true

require_relative "wav/data"

module FillersRemover
  class Wav
    attr_reader :data, :format

    PACK_TEMPLATE_BY_BIT_DEPTH = {
      8 => "C*",
      16 => "s*",
      32 => "i*"
    }.freeze
    private_constant :PACK_TEMPLATE_BY_BIT_DEPTH

    def self.from_unpacked(format:, unpacked:)
      new(
        data: ::FillersRemover::Wav::Data.new(
          unpacked.pack(PACK_TEMPLATE_BY_BIT_DEPTH[format.bit_depth])
        ),
        format: format
      )
    end

    def initialize(data:, format:)
      @format = format
      unless PACK_TEMPLATE_BY_BIT_DEPTH.keys.include?(format.bit_depth)
        raise("#{format.bit_depth} Bit depth is not supported") # rubocop:disable Style/ImplicitRuntimeError
      end

      @data = data
    end

    # NOTE: The unit of return value is second
    def length
      (data.body.bytesize / (format.bit_depth / 8) / format.channel).fdiv(format.hz)
    end

    # NOTE: The unit of `range` is second
    def slice(time_range)
      unpacked[::Range.new(
        time_to_index(time_range.begin),
        time_to_index(time_range.end),
        time_range.exclude_end?
      )]
    end

    private

    # NOTE: The unit of `time` is second
    def time_to_index(time)
      index = Integer(time * format.channel * format.hz)
      index + index % (format.bit_depth / 8 * format.channel)
    end

    def unpacked
      @unpacked ||= data.body.unpack(PACK_TEMPLATE_BY_BIT_DEPTH[format.bit_depth])
    end
  end
end
