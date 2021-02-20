# frozen_string_literal: true

require_relative "fillers_remover/recognition_merger"
require_relative "fillers_remover/recognition"
require_relative "fillers_remover/transcript_parser"
require_relative "fillers_remover/version"
require_relative "fillers_remover/wav/reader"
require_relative "fillers_remover/wav/writer"

module FillersRemover
  DEFAULT_FILLERS = %w[あのー 干支 えーっと そのー なんか まあ].freeze
  public_constant :DEFAULT_FILLERS

  def self.call(src:, dest:, transcript:, fillers: DEFAULT_FILLERS)
    filler_recognitions = extract_filler_recognitions_from(
      ::File.read(transcript),
      fillers: fillers
    )

    ::File.open(src) do |file|
      wav = ::FillersRemover::Wav::Reader.call(file)
      fillers_removed = remove_fillers_from(wav, filler_recognitions: filler_recognitions)

      ::FillersRemover::Wav::Writer.call(
        dest,
        ::FillersRemover::Wav.from_unpacked(unpacked: fillers_removed, format: wav.format)
      )
    end
  end

  def self.extract_filler_recognitions_from(readable, fillers: [])
    ::FillersRemover::RecognitionMerger.call(
      ::FillersRemover::TranscriptParser
        .call(readable)
        .select { |recognition| fillers.include?(recognition.content) }
    )
  end

  def self.remove_fillers_from(wav, filler_recognitions: [])
    [
      ::FillersRemover::Recognition.start,
      *filler_recognitions,
      ::FillersRemover::Recognition.end(wav.length)
    ].each_cons(2).reduce([]) do |acc, (former, latter)|
      partial = wav.slice(former.end_time...latter.start_time)
      partial ? acc.concat(partial) : acc
    end
  end
end
