# frozen_string_literal: true

module FillersRemover
  Recognition =
    ::Struct.new(:start_time, :end_time, :content, keyword_init: true) do
      def self.start
        new(
          start_time: 0,
          end_time: 0,
          content: "START"
        )
      end

      def self.end(time)
        new(
          start_time: time,
          end_time: time,
          content: "END"
        )
      end

      def merge(other)
        raise("Not overlaps with #{other}") unless overlap_with?(other) # rubocop:disable Style/ImplicitRuntimeError

        former, latter = end_time >= other.start_time ? [self, other] : [other, self]

        self.class.new(
          start_time: former.start_time,
          end_time: latter.end_time,
          content: [former.content, latter.content].join
        )
      end

      def overlap_with?(other)
        start_time <= other.end_time || end_time >= other.start_time
      end
    end
  public_constant :Recognition
end
