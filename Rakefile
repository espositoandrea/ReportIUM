require 'asciidoctor'
require 'yaml'
require 'date'
require 'ruby-progressbar'
require 'roo'
require 'zip'

require_relative './src/ruby/asciidoctor-pdf-extension'
require_relative './src/ruby/generation-utils'
require_relative './src/ruby/files-location'

task default: :documentazione

desc 'Genera il report completo'
task documentazione: %w[parziale euristica charts] do
  puts 'Building documentation'
  Asciidoctor.convert_file ReportFiles::REPORT, backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'book', 'pdf-themesdir' => './src/themes'}, mkdirs: true
end

namespace :euristica do
  desc 'Genera la tabella di valutazione di Andrea'
  task :andrea do
    generate_euristic ReportFiles::Heuristic::ANDREA, 'Andrea Esposito'
    Asciidoctor.convert_file ReportFiles::Heuristic::Generated.get_main('andrea'), backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './src/themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione di Alessandro'
  task :alessandro do
    generate_euristic ReportFiles::Heuristic::ALESSANDRO, 'Alessandro Annese'
    Asciidoctor.convert_file ReportFiles::Heuristic::Generated.get_main('alessandro'), backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './src/themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione di Davide'
  task :davide do
    generate_euristic ReportFiles::Heuristic::DAVIDE, 'Davide De Salvo'
    Asciidoctor.convert_file ReportFiles::Heuristic::Generated.get_main('davide'), backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './src/themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione di Graziano'
  task :graziano do
    generate_euristic ReportFiles::Heuristic::GRAZIANO, 'Graziano Montanaro'
    Asciidoctor.convert_file ReportFiles::Heuristic::Generated.get_main('graziano'), backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './src/themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione di Regina'
  task :regina do
    generate_euristic ReportFiles::Heuristic::REGINA, 'Regina Zaccaria'
    Asciidoctor.convert_file ReportFiles::Heuristic::Generated.get_main('regina'), backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './src/themes'}, mkdirs: true
  end

  desc 'Genera la tabella di valutazione complessiva'
  task :complessiva do
    generate_euristic ReportFiles::Heuristic::TOTAL
    Asciidoctor.convert_file ReportFiles::Heuristic::Generated.get_main('complessiva'), backend: 'pdf', safe: :unsafe, to_dir: 'out/', attributes: {'lang' => 'it', 'pdf-theme' => 'article', 'pdf-themesdir' => './src/themes'}, mkdirs: true
  end
end

task :parziale do
  Rake.application.in_namespace(:parziale) { |x| x.tasks.each(&:invoke) }
end

namespace :parziale do
  desc 'Porta i risultati dei questionari nella documentazione'
  task :questionari do
    xlsx = Roo::Excelx.new ReportFiles::Data::GOOGLE_FORM
    i = 0
    header = xlsx.row 1
    xlsx.each_row_streaming offset: 1 do |row|
      i += 1
      nps = create_table_from_survey('Con quanta probabilità consiglieresti questo sito ad un amico o ad un conoscente?' => "#{row[7].value.to_i}/10")

      sus = {}
      header[8..17].each_with_index { |question, index| sus[question] = "#{row[index + 8].value.to_i}/5" }
      File.write File.join(File.dirname(__FILE__), "./src/documentazione/chapters/tester-#{i}/nps.adoc"), nps
      File.write File.join(File.dirname(__FILE__), "./src/documentazione/chapters/tester-#{i}/sus.adoc"), create_table_from_survey(sus)
    end
  end

  desc 'Genera la lista dei partecipanti e altro'
  task :partecipanti do
    data = YAML.load_file ReportFiles::Data::TESTERS

    out = ".Tabella dei partecipanti alle sessioni di test. Per ogni partecipante è riportato un numero intero che funge da identificatore.\n"
    out += "[[tab-lista-partecipanti]]\n"
    out += "[cols=\"^.^1h, ^.^4, ^.^4, ^.^2\", options=\"header\"]\n"
    out += "|===\n"
    out += "|N.ro|Nome|Cognome|Categoria\n"
    data.each_with_index { |elem, i| out += "| #{i + 1} | #{elem['nome']} | #{elem['cognome']} | #{elem['categoria']}\n" }
    out += "|===\n"

    File.write File.join(File.dirname(__FILE__), 'src/documentazione/tables/tab-lista-partecipanti.adoc'), out

    out = ".Tabella dei partecipanti alle sessioni di test con le loro informazioni demografiche.\n"
    out += "[[tab-demografica-partecipanti]]\n"
    out += "[cols=\"^.^1h, ^.^4,^.^2,^.^4,^.^4,^.^3\", options=\"header\"]\n"
    out += "|===\n"
    out += "|#|Partecipante|Età|Esperienza internet|Esperienza sito|Data/Ora sessione\n"
    data.each_with_index { |elem, i| out += "| #{i + 1} | #{elem['nome']} #{elem['cognome']} | #{elem['eta']} | #{elem['uso_internet']} | #{elem['visiti_sito']} | #{elem['inizio_sessione']}\n" }
    out += "|===\n"

    File.write File.join(File.dirname(__FILE__), 'src/documentazione/tables/tab-demografica-partecipanti.adoc'), out
  end

  desc 'Genera la la lista dei task'
  task :task do
    data = YAML.load_file ReportFiles::Data::TASKS

    out = ''
    data.each { |el| out += ". #{el['task']}\n" }
    out += "\n"

    File.write File.join(File.dirname(__FILE__), './src/documentazione/lists/tasks.adoc'), out
  end

  desc 'Crea la tabella di successo dei task'
  task :successo_task do
    yaml = YAML.load_file ReportFiles::Data::TASKS

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
    File.write File.join(File.dirname(__FILE__), './src/documentazione/chapters/tasks/successo.adoc'), table
  end

  task :nps do
    create_nps_from_excel 8
  end

  task :sus do
    results = create_sus_from_excel

    questions = [
        'Penso che mi piacerebbe utilizzare questo sito frequentemente',
        'Ho trovato il sito inutilmente complesso',
        'Ho trovato il sito molto semplice da usare',
        'Penso che avrei bisogno del supporto di una persona già in grado di utilizzare il sito',
        'Ho trovato le varie funzionalità del sito bene integrate',
        'Ho trovato incoerenze tra le varie funzionalità del sito',
        'Penso che la maggior parte delle persone possano imparare ad utilizzare il sito facilmente',
        'Ho trovato il sito molto difficile da utilizzare',
        "Mi sono sentito a mio agio nell'utilizzare il sito",
        'Ho avuto bisogno di imparare molti processi prima di riuscire ad utilizzare al meglio il sito'
    ]

    results.each do |res|
      path = File.join(File.dirname(__FILE__), './src/documentazione/tables/sus', "tester#{res[:code]}.adoc")
      table = ".Tabella dei risultati del questionario SUS del tester #{res[:code]}\n"
      table += "[[tab-sus-tester#{res[:code]}]]\n"
      table += "[cols=\"^.^1h,<.^4,^.^1,^.^1\"]\n"
      table += "|===\n"
      table += "2.2+h|Domande 2+^h|Codice tester: #{res[:code]} ^h|Voto ^h|Punteggio\n"
      (0..questions.size - 1).each do |i|
        table += "|#{i + 1}|#{questions[i]}|#{res[:answers][i]}|#{res[:results][i]}\n"
      end
      table += "3+h|Valutazione totale ^.^h|#{res[:total]}\n"
      table += "|===\n"

      File.write path, table
    end

    path = File.join(File.dirname(__FILE__), './src/documentazione/tables/sus', "complessiva.adoc")
    table = ".Tabella dei risultati medi del questionario SUS\n"
    table += "[[tab-sus-complessiva]]\n"
    table += "[cols=\"^.^1h,<.^4,^.^1,^.^1\"]\n"
    table += "|===\n"
    table += "2+h|Domande ^h|Voto medio ^h|Punteggio medio\n"

    average_answers = Array.new questions.size
    average_ratings = Array.new questions.size
    (0..questions.size - 1).each do |i|
      temp_answers = results.map { |x| x[:answers][i] }
      temp_ratings = results.map { |x| x[:results][i] }
      average_answers[i] = (temp_answers.sum.to_f / results.size).round 2
      average_ratings[i] = (temp_ratings.sum.to_f / results.size).round 2
    end
    (0..questions.size - 1).each do |i|
      table += "|#{i + 1}|#{questions[i]}|#{average_answers[i]}|#{average_ratings[i]}\n"
    end
    sus_score = ((results.map { |x| x[:total] }).sum.to_f / results.size).round(2)
    table += "3+h|Valutazione totale ^.^h|#{sus_score}\n"
    table += "3+h|Deviazione standard ^.^h|#{standard_deviation(results.map { |x| x[:total] }).round(2)}\n"
    table += "|===\n"
    File.write path, table

    score = <<~EOS
  .Risultato System Usability Scale
  ***************
  [.lead.text-center]
  #{sus_score}
  ***************
    EOS

    File.write File.join(dirname, 'documentazione/tables/sus-score.adoc'), score
  end
end

desc 'Genera tutti i diagrammi'
task charts: ['parziale:nps'] do
  sh 'npm run charts --silent'
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
        'alessandro.pdf' => 'out/ alessandro.pdf ',
        'andrea.pdf' => 'out/andrea.pdf',
        'complessiva.pdf' => 'out/complessiva.pdf',
        'davide.pdf' => 'out/davide.pdf',
        'graziano.pdf' => 'out/graziano.pdf',
        'regina.pdf' => 'out/regina.pdf'
    }
    create_zip_file ' out / euristica.zip ', file_list
  end

  desc ' Crea ZIP per la consegna '
  task zip: [' documentazione '] do
    # TODO: Implement
    Asciidoctor.convert_file ' README.adoc ', backend: ' html ', safe: :unsafe, attributes: {' lang ' => ' it '}, mkdirs: true
    file_list = {
        'README.html' => 'README.html',
        'report/ReportIUM.pdf' => 'out/ReportIUM.pdf',
        'report/euristica/alessandro.pdf' => 'out/alessandro.pdf',
        'report/euristica/andrea.pdf' => 'out/andrea.pdf',
        'report/euristica/complessiva.pdf' => 'out/complessiva.pdf',
        'report/euristica/davide.pdf' => 'out/davide.pdf',
        'report/euristica/graziano.pdf' => 'out/graziano.pdf',
        'report/euristica/regina.pdf' => 'out/regina.pdf',
        'Presentazione.pptx' => 'presentation/Presentazione IUM.pptx'
    }
    create_zip_file 'out/fsc.zip ', file_list
    File.delete ' README.html '
    puts ' NOT YET IMPLEMENTED '
  end
end

desc ' Crea ZIP per la consegna '
task dist: [' dist : zip ']

task :install do
  sh ' bundle install '
  sh ' npm install '
end
