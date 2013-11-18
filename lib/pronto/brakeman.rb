require 'pronto'
require 'brakeman'

module Pronto
  class Brakeman < Runner
    def run
      return [] unless patches

      files = ruby_patches.map { |patch| patch.new_file_full_path.to_s }

      if files.any?
        output = ::Brakeman.run(app_path: '.',
                                output_formats: [:to_s],
                                only_files: files)
        messages_for(output).compact
      else
        []
      end
    end

    def messages_for(output)
      output.checks.all_warnings.map do |warning|
        patch = patch_for_warning(warning)

        if patch
          line = patch.added_lines.find do |added_line|
            added_line.new_lineno == warning.line
          end

          new_message(line, warning) if line
        end
      end
    end

    def new_message(line, warning)
      Message.new(line.patch.delta.new_file[:path], line, :warning,
                  "Possible security vulnerability: #{warning.message}")
    end

    def patch_for_warning(warning)
      ruby_patches.find do |patch|
        patch.new_file_full_path.to_s == warning.file
      end
    end
  end
end
