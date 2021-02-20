# frozen_string_literal: true

require "json"
require_relative "recognition"

module FillersRemover
  module TranscriptParser
    def self.call(readable)
      ::JSON
        .load(readable) # rubocop:disable Security/JSONLoad
        .dig("results", "channel_labels", "channels")
        .flat_map do |channel|
          channel["items"].reduce([]) do |acc, item|
            next acc unless item.key?("start_time")

            acc.push(
              ::FillersRemover::Recognition.new(
                start_time: Float(item["start_time"]),
                end_time: Float(item["end_time"]),
                content: item["alternatives"].first["content"]
              )
            )
          end
        end
    end
  end
end
