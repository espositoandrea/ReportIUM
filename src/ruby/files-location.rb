# frozen_string_literal: true

# A list of useful constants that represents various file's path used in the
# report
module ReportFiles
  def self.relative_path(path)
    File.expand_path File.join(File.dirname(__FILE__), path)
  end

  REPORT = relative_path '../documentazione/ReportIUM.adoc'

  module Data
    GOOGLE_FORM = ReportFiles.relative_path '../data/risultati-google-form.xlsx'
    TASKS = ReportFiles.relative_path '../data/tasks.yml'
    TESTERS = ReportFiles.relative_path '../data/tester.yml'
  end

  module Heuristic
    BASE_FOLDER = ReportFiles.relative_path '../heuristic'

    ALESSANDRO = File.join BASE_FOLDER, 'alessandro.yml'
    ANDREA = File.join BASE_FOLDER, 'andrea.yml'
    TOTAL = File.join BASE_FOLDER, 'complessiva.yml'
    DAVIDE = File.join BASE_FOLDER, 'davide.yml'
    GRAZIANO = File.join BASE_FOLDER, 'graziano.yml'
    REGINA = File.join BASE_FOLDER, 'regina.yml'

    TEMPLATE = File.join BASE_FOLDER, '_master/main.adoc'

    def self.get_folder(author)
      File.join BASE_FOLDER, author
    end

    module Generated
      def self.get_comments(author)
        File.join(ReportFiles::Heuristic.get_folder(author), 'comments.adoc')
      end

      def self.get_table(author)
        File.join(ReportFiles::Heuristic.get_folder(author), 'table.adoc')
      end

      def self.get_main(author)
        File.join(ReportFiles::Heuristic.get_folder(author), "#{author}.adoc")
      end
    end
  end
end
