require 'asciidoctor'
require 'yaml'
require 'date'
require 'ruby-progressbar'
require 'roo'
require 'zip'

require_relative './asciidoctor-pdf-extension'
require_relative './generation-utils'

task default: :documentazione

desc 'Genera il report completo'
task documentazione: ['parziale', 'euristica'] do
  puts 'Building documentation'
  Asciidoctor.convert_file 'documentazione/ReportIUM.adoc', backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'book', 'pdf-themesdir' => './themes'}, mkdirs: true
end

namespace :euristica do
  desc 'Genera la tabella di valutazione di Andrea'
  task :andrea do
    generate_euristic 'valutazione-euristica/andrea.yml', 'Andrea Esposito'
    Asciidoctor.convert_file 'valutazione-euristica/andrea/andrea.adoc', backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione di Alessandro'
  task :alessandro do
    generate_euristic 'valutazione-euristica/alessandro.yml', 'Alessandro Annese'
    Asciidoctor.convert_file 'valutazione-euristica/alessandro/alessandro.adoc', backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione di Davide'
  task :davide do
    generate_euristic 'valutazione-euristica/davide.yml', 'Davide De Salvo'
    Asciidoctor.convert_file 'valutazione-euristica/davide/davide.adoc', backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione di Graziano'
  task :graziano do
    generate_euristic 'valutazione-euristica/graziano.yml', 'Graziano Montanaro'
    Asciidoctor.convert_file 'valutazione-euristica/graziano/graziano.adoc', backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione di Regina'
  task :regina do
    generate_euristic 'valutazione-euristica/regina.yml', 'Regina Zaccaria'
    Asciidoctor.convert_file 'valutazione-euristica/regina/regina.adoc', backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione complessiva'
  task :complessiva do
    generate_euristic 'valutazione-euristica/complessiva.yml'
    Asciidoctor.convert_file 'valutazione-euristica/complessiva/complessiva.adoc', backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './themes'}, mkdirs: true
  end
end

task :parziale do
  Rake.application.in_namespace(:parziale) { |x| x.tasks.each { |t| t.invoke } }
end

namespace :parziale do
  desc 'Porta i risultati dei questionari nella documentazione'
  task :questionari do
    xlsx = Roo::Excelx.new File.join(File.dirname(__FILE__), 'risultati-google-form.xlsx')
    i = 0
    header = xlsx.row 1
    xlsx.each_row_streaming offset: 1 do |row|
      i += 1
      nps = create_table_from_survey({'Con quanta probabilità consiglieresti questo sito ad un amico o ad un conoscente?' => "#{row[7].value.to_i}/10"})

      sus = {}
      header[8..17].each_with_index { |question, index| sus[question] = "#{row[index + 8].value.to_i}/5" }
      File.write File.join(File.dirname(__FILE__), "./documentazione/chapters/tester-#{i}/nps.adoc"), nps
      File.write File.join(File.dirname(__FILE__), "./documentazione/chapters/tester-#{i}/sus.adoc"), create_table_from_survey(sus)
    end
  end

  desc 'Crea la tabella di successo dei task'
  task :successo_task do
    yaml = YAML.load_file File.join(File.dirname(__FILE__), 'tasks.yml')

    number_of_testers = yaml[0]['esiti'].size

    table = "[[tab-successo-task]]\n"
    table += ".Tabella del tasso di successo dei task.\n"
    table += "[cols=\"^.^1h,6*^.^1,^.^1\", options=\"header\"]\n"
    table += "|===\n"
    table += '|'
    (1..number_of_testers).each { |i| table += " | Tester #{i}" }
    table += "| Tasso di successo medio per task\n"
    tester_success = Array.new(number_of_testers) { 0 }
    yaml.each do |task|
      table += "| Task #{task['id']}"
      # Uncomment for UTF-8 Tick/Cross sign
      # task["esiti"].each {|esito| table += " | #{esito[1]? '&#10003;' : '&#10007;'}"}
      done = 0
      task['esiti'].each_with_index do |esito, index|
        if esito[1]
          tester_success[index] += 1
          done += 1
        end
        table += " | #{esito[1] ? '[green]#Sì#' : '[red]#No#'}"
      end
      table += "|#{(done.to_f / number_of_testers * 100).round(2)}%\n"
    end

    table += '|Tasso di successo medio per tester'
    tester_success.each { |x| table += "|#{(x.to_f / number_of_testers * 100).round(2)}%" }
    table += "| *Media: #{(tester_success.sum.to_f / (number_of_testers * yaml.size) * 100).round(2)}%*\n"

    table += "|===\n"
    File.write File.join(File.dirname(__FILE__), './documentazione/chapters/tasks/successo.adoc'), table
  end

  task :nps do
    create_nps_from_excel 8
  end
end

desc 'Genera tutte le tabelle di valutazione euristica'
task :euristica do
  puts "Building 'Andrea'"
  Rake::Task['euristica:andrea'].execute

  puts "Building 'Alessandro'"
  Rake::Task['euristica:alessandro'].execute

  puts "Building 'Davide'"
  Rake::Task['euristica:davide'].execute

  puts "Building 'Graziano'"
  Rake::Task['euristica:graziano'].execute

  puts "Building 'Regina'"
  Rake::Task['euristica:regina'].execute

  puts "Building 'Complessiva'"
  Rake::Task['euristica:complessiva'].execute
end

namespace :dist do
  desc 'Crea ZIP per valutazione euristica'
  task euristica: ['euristica'] do
    file_list = {
      'alessandro.pdf' => 'out/alessandro.pdf',
      'andrea.pdf' => 'out/andrea.pdf',
      'complessiva.pdf' => 'out/complessiva.pdf',
      'davide.pdf' => 'out/davide.pdf',
      'graziano.pdf' => 'out/graziano.pdf',
      'regina.pdf' => 'out/regina.pdf',
    }
    create_zip_file 'out/euristica.zip', file_list
  end

  desc 'Crea ZIP per la consegna'
  task zip: ['documentazione'] do
    # TODO: Implement
    Asciidoctor.convert_file 'README.adoc', backend: 'html', safe: :unsafe, attributes: {'lang' => 'it'}, mkdirs: true
    file_list = {
      'README.html' => 'README.html',
      'report/ReportIUM.pdf' => 'out/ReportIUM.pdf',
      'report/euristica/alessandro.pdf' => 'out/alessandro.pdf',
      'report/euristica/andrea.pdf' => 'out/andrea.pdf',
      'report/euristica/complessiva.pdf' => 'out/complessiva.pdf',
      'report/euristica/davide.pdf' => 'out/davide.pdf',
      'report/euristica/graziano.pdf' => 'out/graziano.pdf',
      'report/euristica/regina.pdf' => 'out/regina.pdf',
    }
    create_zip_file 'out/fsc.zip', file_list
    File.delete 'README.html'
    puts 'NOT YET IMPLEMENTED'
  end
end

desc 'Crea ZIP per la consegna'
task dist: ['dist:zip']
