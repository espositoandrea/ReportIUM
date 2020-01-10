require "asciidoctor"
require "yaml"
require "date"
require "ruby-progressbar"
require "roo"
require "zip"
require "fileutils"

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

def create_table_from_survey(entries)
  table = "[cols=\"<.^10h,^.^1\", options=\"header\"]\n|===\n| Domanda | Voto\n"
  entries.each { |question, answer| table += "| #{question} | #{answer}\n" }
  table += "|===\n"
end

def create_zip_file(zip_name, file_list ,relative=true)
    dirname = File.dirname zip_name
    FileUtils.mkdir_p dirname unless File.directory? dirname 
    File.delete(zip_name) if File.exist?(zip_name)
    Zip.on_exists_proc = true
    Zip.continue_on_exists_proc = true
    Zip::File.open(zip_name, Zip::File::CREATE) do |zipfile|
      file_list.each do |zip_filename, filename|
        zipfile.add zip_filename, File.join(File.dirname(__FILE__), filename)
      end
    end
end
