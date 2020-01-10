require "asciidoctor"
require "yaml"
require "date"
require "ruby-progressbar"
require "roo"
require "zip"

require_relative "./asciidoctor-pdf-extension"
require_relative "./generation-utils"

task :default => :documentazione

desc "Genera il report completo"
task :documentazione => ["parziale:questionari", "euristica"] do
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
    file_list = {
      "alessandro.pdf" => "out/alessandro.pdf",
      "andrea.pdf" => "out/andrea.pdf",
      "complessiva.pdf" => "out/complessiva.pdf",
      "davide.pdf" => "out/davide.pdf",
      "graziano.pdf" => "out/graziano.pdf",
      "regina.pdf" => "out/regina.pdf",
    }
    create_zip_file "out/euristica.zip", file_list
  end

  desc "Crea ZIP per la consegna"
  task :zip => ["documentazione"] do
    # TODO: Implement
    Asciidoctor.convert_file "README.adoc", backend: "html", safe: :unsafe, attributes: { "lang" => "it" }, mkdirs: true
    file_list = {
      "README.html" => "README.html",
      "report/ReportIUM.pdf" => "out/ReportIUM.pdf",
      "report/euristica/alessandro.pdf" => "out/alessandro.pdf",
      "report/euristica/andrea.pdf" => "out/andrea.pdf",
      "report/euristica/complessiva.pdf" => "out/complessiva.pdf",
      "report/euristica/davide.pdf" => "out/davide.pdf",
      "report/euristica/graziano.pdf" => "out/graziano.pdf",
      "report/euristica/regina.pdf" => "out/regina.pdf"
    }
    create_zip_file "out/fsc.zip", file_list
    File.delete "README.html"
    puts "NOT YET IMPLEMENTED"
  end
end

desc "Crea ZIP per la consegna"
task :dist => ["dist:zip"]
