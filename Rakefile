require "asciidoctor"
require "yaml"
require "date"
require "ruby-progressbar"
require_relative "./asciidoctor-pdf-extension"

def generate_euristic(input, author = "FSC -- Five Students of Computer Science")
  data = YAML.load_file input
  template = File.read File.join(File.dirname(__FILE__), "./valutazione-euristica/_master/main.adoc")

  template.gsub! /~~AUTHOR~~/, author
  template.gsub! /~~DATE~~/, data["data"]

  base_name = File.basename(input, File.extname(input))
  File.write File.join(File.dirname(__FILE__), "./valutazione-euristica/", base_name, base_name + ".adoc"), template

  process_string = ->(string) do
    string = string[1].to_s unless string.kind_of? String
    string.gsub! /([^a-zA-Z])['‘](.*?)['’]/, '\1\'`\2`\''
    string.gsub! /["“](.*?)["”]/, '"`\1`"'
    string.gsub! /``(.*?)''/, '"`\1`"'
    string.gsub! "’", "'"
    return string
  end

  table = "[[tab-val-euristica-#{author.gsub(" ", "")}]]\n"
  table += ".Tabella dei risultati della valutazione euristica condotta sul sito del comune di Taranto da #{author}.\n"
  table += "[cols=\"6*^.^\", options=\"header\"]\n|===\n"
  table += "| N.ro | Locazione | Problema | Euristica violata | Possibile soluzione | Grado di severità{blank}footnote:[Scala +[1, 5]+, dove 1 indica un problema lieve e 5 un problema grave]\n"
  data["problemi"].each_with_index do |row, i|
    table += "| #{i + 1} "
    row.each { |column| table += "| #{process_string.call column} " }
    table += "\n"
  end
  table += "|===\n"

  File.write File.join(File.dirname(__FILE__), "./valutazione-euristica/", base_name, "table.adoc"), table

  if data["commenti"]
    comments = ""
    data["commenti"].each { |comment| comments += "* #{process_string.call comment}\n" }
    File.write File.join(File.dirname(__FILE__), "./valutazione-euristica/", base_name, "comments.adoc"), comments
  end
end

def convert_asciidoc(input_file, theme = "basic")
  Asciidoctor.convert_file input_file, backend: "pdf", safe: :unsafe, to_dir: "out/", attributes: { "lang" => "it", "pdf-theme" => theme, "pdf-themesdir" => "./themes" }, mkdirs: true
end

task :default => [:documentazione, :euristica]

desc "Genera il report completo"
task :documentazione do
  puts "Building documentation"
  convert_asciidoc "documentazione/ReportIUM.adoc", "book"
end

namespace :euristica do
  desc "Genera la tabella di valutazione euristica di Andrea"
  task :andrea do
    generate_euristic "valutazione-euristica/andrea.yml", "Andrea Esposito"
    convert_asciidoc "valutazione-euristica/andrea/andrea.adoc", "article"
  end

  desc "Genera la tabella di valutazione euristica di Alessandro"
  task :alessandro do
    generate_euristic "valutazione-euristica/alessandro.yml", "Alessandro Annese"
    convert_asciidoc "valutazione-euristica/alessandro/alessandro.adoc", "article"
  end

  desc "Genera la tabella di valutazione euristica di Davide"
  task :davide do
    generate_euristic "valutazione-euristica/davide.yml", "Davide De Salvo"
    convert_asciidoc "valutazione-euristica/davide/davide.adoc", "article"
  end

  desc "Genera la tabella di valutazione euristica di Graziano"
  task :graziano do
    generate_euristic "valutazione-euristica/graziano.yml", "Graziano Montanaro"
    convert_asciidoc "valutazione-euristica/graziano/graziano.adoc", "article"
  end

  desc "Genera la tabella di valutazione euristica di Regina"
  task :regina do
    generate_euristic "valutazione-euristica/regina.yml", "Regina Zaccaria"
    convert_asciidoc "valutazione-euristica/regina/regina.adoc", "article"
  end

  desc "Genera la tabella di valutazione complessiva"
  task :complessiva do
    generate_euristic "valutazione-euristica/complessiva.yml"
    convert_asciidoc "valutazione-euristica/complessiva/complessiva.adoc", "article"
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

  puts "Building 'Complessiva'"
  Rake::Task["euristica:complessiva"].execute
end
