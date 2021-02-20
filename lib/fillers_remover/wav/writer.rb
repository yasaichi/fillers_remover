# frozen_string_literal: true

require "wav-file"

module FillersRemover
  class Wav
    module Writer
      def self.call(dest, wav)
        ::File.open(dest, "w") do |file|
          ::WavFile.write(file, wav.format, [wav.data])
        end
      end
    end
  end
end
