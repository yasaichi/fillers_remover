# frozen_string_literal: true

require "thor"
require_relative "../fillers_remover"

module FillersRemover
  class CLI < ::Thor
    package_name "FillersRemover"

    def self.exit_on_failure?
      true
    end

    desc "call SRC DEST TRANSCRIPT",
         "remove fillers using Transcript generated by Amazon Transcribe"
    option :fillers, type: :array, default: %w[あのー 干支 えーっと その、 そのー なんか まあ]
    def call(src, dest, transcript)
      ::FillersRemover.call(
        src: src,
        dest: dest,
        transcript: transcript,
        fillers: options[:fillers]
      )
    end
  end
end
