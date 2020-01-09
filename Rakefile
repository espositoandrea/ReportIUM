require "asciidoctor"
require "yaml"
require "date"
require "ruby-progressbar"
require "roo"
require "zip"
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

  table = author != "FSC -- Five Students of Computer Science" ? "[[tab-valutazione-euristica-#{author.gsub(" ", "")}]]\n" : "[[tab-valutazione-euristica]]\n"
  table += ".Tabella dei risultati della valutazione euristica condotta sul sito del comune di Taranto da #{author}.\n"
  table += "[cols=\"^.^1h,^.^2,^.^3,^.^2,^.^3,^.^2\", options=\"header\"]\n|===\n"
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
task :documentazione => ["parziale:questionari"] do
  puts "Building documentation"
  convert_asciidoc "documentazione/ReportIUM.adoc", "book"
end

namespace :euristica do
  desc "Genera la tabella di valutazione di Andrea"
  task :andrea do
    generate_euristic "valutazione-euristica/andrea.yml", "Andrea Esposito"
    convert_asciidoc "valutazione-euristica/andrea/andrea.adoc", "article"
  end

  desc "Genera la tabella di valutazione di Alessandro"
  task :alessandro do
    generate_euristic "valutazione-euristica/alessandro.yml", "Alessandro Annese"
    convert_asciidoc "valutazione-euristica/alessandro/alessandro.adoc", "article"
  end

  desc "Genera la tabella di valutazione di Davide"
  task :davide do
    generate_euristic "valutazione-euristica/davide.yml", "Davide De Salvo"
    convert_asciidoc "valutazione-euristica/davide/davide.adoc", "article"
  end

  desc "Genera la tabella di valutazione di Graziano"
  task :graziano do
    generate_euristic "valutazione-euristica/graziano.yml", "Graziano Montanaro"
    convert_asciidoc "valutazione-euristica/graziano/graziano.adoc", "article"
  end

  desc "Genera la tabella di valutazione di Regina"
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

namespace :parziale do
  def create_table_from_survey(entries)
    table = "[cols=\"<.^10h,^.^1\", options=\"header\"]\n|===\n| Domanda | Voto\n"
    entries.each { |question, answer| table += "| #{question} | #{answer}\n" }
    table += "|===\n"
  end

  desc "Porta i risultati dei questionari nella documentazione"
  task :questionari do
    xlsx = Roo::Excelx.new File.join(File.dirname(__FILE__), "risultati-google-form.xlsx")
    i = 0
    header = xlsx.row 1
    xlsx.each_row_streaming offset: 1 do |row|
      i += 1
      nps = create_table_from_survey({ "Con quanta probabilità consiglieresti questo sito ad un amico o ad un conoscente?" => "#{row[7].value.to_i}/10" })

      sus = Hash.new
      header[8..17].each_with_index { |question, index| sus[question] = "#{row[index + 8].value.to_i}/5" }
      File.write File.join(File.dirname(__FILE__), "./documentazione/chapters/tester-#{i}/nps.adoc"), nps
      File.write File.join(File.dirname(__FILE__), "./documentazione/chapters/tester-#{i}/sus.adoc"), create_table_from_survey(sus)
    end
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

namespace :dist do
  desc "Crea ZIP per valutazione euristica"
  task :euristica => ["euristica"] do
    File.delete("euristica.zip") if File.exist?("euristica.zip")
    Zip.on_exists_proc = true
    Zip.continue_on_exists_proc = true
    Zip::File.open("euristica.zip", Zip::File::CREATE) do |zipfile|
      ["alessandro.pdf", "andrea.pdf", "complessiva.pdf", "davide.pdf", "graziano.pdf", "regina.pdf"].each do |filename|
        zipfile.add filename, File.join(File.dirname(__FILE__), "out/", filename)
      end
    end
  end
end
