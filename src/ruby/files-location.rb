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
    ALESSANDRO = ReportFiles.relative_path '../valutazione-euristica/alessandro.yml'
    ANDREA = ReportFiles.relative_path '../valutazione-euristica/andrea.yml'
    TOTAL = ReportFiles.relative_path '../valutazione-euristica/complessiva.yml'
    DAVIDE = ReportFiles.relative_path '../valutazione-euristica/davide.yml'
    GRAZIANO = ReportFiles.relative_path '../valutazione-euristica/graziano.yml'
    REGINA = ReportFiles.relative_path '../valutazione-euristica/regina.yml'
  end
end
