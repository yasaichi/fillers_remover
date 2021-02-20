# frozen_string_literal: true

module FillersRemover
  module RecognitionMerger
    def self.call(recognitions)
      recognitions
        .sort_by(&:start_time)
        .each
        .then do |enum|
          [].tap do |merged|
            loop do
              recognition = enum.next
              recognition = recognition.merge(enum.next) until recognition.overlap_with?(enum.peek)

              merged.push(recognition)
            rescue ::StopIteration
              break
            end
          end
        end
    end
  end
end
