# frozen_string_literal: true

module FillersRemover
  class Wav
    class Data
      attr_reader :body

      # NOTE: This method is only for compatibility with wav-file gem
      alias data body

      def initialize(body)
        @body = body
      end

      # NOTE: This method is only for compatibility with wav-file gem
      def to_bin
        [
          "data",
          [body.size].pack("V"),
          body
        ].join
      end
    end
  end
end
