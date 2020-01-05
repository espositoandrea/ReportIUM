require "asciidoctor"
require "csv"
require "date"
require "ruby-progressbar"
require_relative "./asciidoctor-pdf-extension"

def generate_euristic(input, author = "FSC -- Five Students of Computer Science")
  data = CSV.parse File.read input, headers: true
  template = File.read File.join(File.dirname(__FILE__), "./valutazione-euristica/_master/main.adoc")

  get_current_date = -> do
    date = Time.now
    months = [
      "gennaio", "febbraio", "marzo",
      "aprile", "maggio", "giugno",
      "luglio", "agosto", "settembre",
      "ottobre", "novembre", "dicembre",
    ]
    return "#{date.day} #{months[date.mon - 1]} #{date.year}"
  end

  template.sub! /~~AUTHOR~~/, author
  template.sub! /~~DATE~~/, get_current_date.call

  base_name = File.basename(input, File.extname(input))
  File.write File.join(File.dirname(__FILE__), "./valutazione-euristica/", base_name, base_name + ".adoc"), template

  process_string = ->(string) do
    string.gsub!(/\s['‘](.*?)['’]/, "'`\1`'")
    string.gsub!(/["“](.*?)["”]/, '"`\1`"')
    string.gsub!(/``(.*?)''/, '"`\1`"')
    string.gsub!("’", "'")
    return string
  end

  table = "[[tab-val-euristica-#{author.gsub(" ", "")}]]\n"
  table += ".Tabella dei risultati della valutazione euristica condotta sul sito del comune di Taranto da #{author}.\n"
  table += "[cols=\"6*^.^\", options=\"header\"]\n|===\n"
  table += "| N.ro | Locazione | Problema | Euristica violata | Possibile soluzione | Grado di severità{blank}footnote:[Scala +[1, 5]+, dove 1 indica un problema lieve e 5 un problema grave]\n"
  data.drop(1).each_with_index do |row, i|
    table += "| #{i + 1} "
    row.each { |column| table += "| #{process_string.call column} " }
    table += "\n"
  end
  table += "|===\n"

  File.write File.join(File.dirname(__FILE__), "./valutazione-euristica/", base_name, "table.adoc"), table
end

def convert_asciidoc(input_file)
  Asciidoctor.convert_file input_file, backend: "pdf", safe: :unsafe, to_dir: "out/", attributes: { "lang" => "it", "pdf-theme" => "basic", "pdf-themesdir" => "./themes" }, mkdirs: true
end

task :default => [:documentazione, :euristica]

desc "Genera il report completo"
task :documentazione do
  puts "Building documentation"
  convert_asciidoc "documentazione/ReportIUM.adoc"
end

namespace :euristica do
  desc "Genera la tabella di valutazione euristica di Andrea"
  task :andrea do
    generate_euristic "valutazione-euristica/andrea.csv", "Andrea Esposito"
    convert_asciidoc "valutazione-euristica/andrea/andrea.adoc"
  end

  desc "Genera la tabella di valutazione euristica di Alessandro"
  task :alessandro do
    generate_euristic "valutazione-euristica/alessandro.csv", "Alessandro Annese"
    convert_asciidoc "valutazione-euristica/alessandro/alessandro.adoc"
  end

  desc "Genera la tabella di valutazione euristica di Davide"
  task :davide do
    generate_euristic "valutazione-euristica/davide.csv", "Davide De Salvo"
    convert_asciidoc "valutazione-euristica/davide/davide.adoc"
  end

  desc "Genera la tabella di valutazione euristica di Graziano"
  task :graziano do
    generate_euristic "valutazione-euristica/graziano.csv", "Graziano Montanaro"
    convert_asciidoc "valutazione-euristica/graziano/graziano.adoc"
  end

  desc "Genera la tabella di valutazione euristica di Regina"
  task :regina do
    generate_euristic "valutazione-euristica/regina.csv", "Regina Zaccaria"
    convert_asciidoc "valutazione-euristica/regina/regina.adoc"
  end
end

desc "Genera tutte le tabelle di valutazione euristica"
task :euristica do
  puts "Building 'Andrea'"
  Rake::Task["euristica:andrea"].execute

  puts "Building 'Alessandro'"
  Rake::Task["euristica:alessandro"].execute

  puts "Building 'Davide'"
  Rake::Task["euristica:davide"].execute

  puts "Building 'Graziano'"
  Rake::Task["euristica:graziano"].execute

  puts "Building 'Regina'"
  Rake::Task["euristica:regina"].execute
end
