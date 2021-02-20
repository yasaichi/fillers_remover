# frozen_string_literal: true

require "wav-file"
require_relative "../wav"
require_relative "data"
require_relative "format"

module FillersRemover
  class Wav
    module Reader
      def self.call(readable)
        format = ::WavFile.readFormat(readable)

        ::FillersRemover::Wav.new(
          data: ::FillersRemover::Wav::Data.new(
            ::WavFile.readDataChunk(readable).data
          ),
          format: ::FillersRemover::Wav::Format.new(
            id: format.id,
            bit_depth: format.bitPerSample,
            channel: format.channel,
            hz: format.hz
          )
        )
      end
    end
  end
end
