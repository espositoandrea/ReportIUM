require 'asciidoctor'
require 'yaml'
require 'date'
require 'ruby-progressbar'
require 'roo'
require 'zip'
require 'fileutils'

require_relative './surveys'

def generate_euristic(input, author = 'FSC -- Five Students of Computer Science')
  data = YAML.load_file input
  template = File.read File.join(File.dirname(__FILE__), './valutazione-euristica/_master/main.adoc')

  template.gsub!(/~~AUTHOR~~/, author)
  template.gsub!(/~~DATE~~/, data['data'])

  base_name = File.basename(input, File.extname(input))
  File.write File.join(File.dirname(__FILE__), './valutazione-euristica/', base_name, base_name + '.adoc'), template

  process_string = lambda do |string|
    string = string[1].to_s unless string.kind_of? String
    string.gsub!(/([^a-zA-Z])['‘](.*?)['’]/, '\1\'`\2`\'')
    string.gsub!(/["“](.*?)["”]/, '"`\1`"')
    string.gsub!(/``(.*?)''/, '"`\1`"')
    string.gsub! '’', "'"
    return string
  end

  table = author != 'FSC -- Five Students of Computer Science' ? "[[tab-valutazione-euristica-#{author.gsub(" ", "")}]]\n" : "[[tab-valutazione-euristica]]\n"
  table += ".Tabella dei risultati della valutazione euristica condotta sul sito del comune di Taranto da #{author}.\n"
  table += "[cols=\"^.^1h,^.^2,^.^3,^.^2,^.^3,^.^2\", options=\"header\"]\n|===\n"
  table += "| N.ro | Locazione | Problema | Euristica violata | Possibile soluzione | Grado di severità{blank}footnote:[Scala +[1, 5]+, dove 1 indica un problema lieve e 5 un problema grave]\n"
  data['problemi'].each_with_index do |row, i|
    table += "| #{i + 1} "
    row.each { |column| table += "| #{process_string.call column} " }
    table += "\n"
  end
  table += "|===\n"

  File.write File.join(File.dirname(__FILE__), './valutazione-euristica/', base_name, 'table.adoc'), table

  return unless data['commenti']

  comments = ''
  data['commenti'].each { |comment| comments += "* #{process_string.call comment}\n" }
  File.write File.join(File.dirname(__FILE__), './valutazione-euristica/', base_name, 'comments.adoc'), comments
end

def create_table_from_survey(entries)
  table = "[cols=\"<.^10h,^.^1\", options=\"header\"]\n|===\n| Domanda | Voto\n"
  entries.each { |question, answer| table += "| #{question} | #{answer}\n" }
  table += "|===\n"
end

def create_zip_file(zip_name, file_list, relative = true)
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

def create_sus_from_excel
  out = []
  ratings = Roo::Excelx.new File.join(File.dirname(__FILE__), 'risultati-google-form.xlsx')
  ratings.sheet(0).each_row_streaming(offset: 1) { |rating| out.push sus(rating, out.size + 1) }
  out
end

def create_nps_from_excel(column)
  xlsx = Roo::Excelx.new File.join(File.dirname(__FILE__), 'risultati-google-form.xlsx')
  ratings = []
  xlsx.column(column).drop(1).each { |x| ratings.push x.to_i }

  nps_results = nps ratings

  graph = <<~EOS
    {
      "$schema": "https://vega.github.io/schema/vega/v5.json",
      "height": 200,
      "width":200,
      "autosize": "pad",
  
      "signals": [
        {
          "name": "startAngle", "value": 0
        },
        {
          "name": "endAngle", "value": 6.29
        },
        {
          "name": "padAngle", "value": 0
        },
        {
          "name": "innerRadius", "value": 0
        },
        {
          "name": "cornerRadius", "value": 0
        },
        {
          "name": "sort", "value": false
        }
      ],
  
      "data": [
        {
          "name": "table",
          "values": [
            {"id": "Promotori", "field": #{nps_results[:promoters]}},
            {"id": "Neutri", "field": #{nps_results[:neutrals]}},
            {"id": "Detrattori", "field": #{nps_results[:detractors]}}
          ],
          "transform": [
            {
              "type": "pie",
              "field": "field",
              "startAngle": {"signal": "startAngle"},
              "endAngle": {"signal": "endAngle"},
              "sort": {"signal": "sort"}
            }
          ]
        }
      ],
  
      "legends": [
        {
          "fill": "color",
          "title": "Legenda",
          "orient": "none",
          "padding": {"value": 20},
          "encode": {
            "legend": {
              "update": {
                "x": {
                  "offset": 200
                },
                "y": {"signal": "(height / 2)", "offset": -50}
              }
            }
          }
        }
      ],
  
      "scales": [
        {
          "name": "color",
          "type": "ordinal",
          "domain": {"data": "table", "field": "id"},
          "range": {"scheme": "category20"}
        }
      ],
  
      "marks": [
        {
          "type": "arc",
          "from": {"data": "table"},
          "encode": {
            "enter": {
              "fill": {"scale": "color", "field": "id"},
              "x": {"signal": "width / 2"},
              "y": {"signal": "height / 2"}
            },
            "update": {
              "startAngle": {"field": "startAngle"},
              "endAngle": {"field": "endAngle"},
              "padAngle": {"signal": "padAngle"},
              "innerRadius": {"signal": "innerRadius"},
              "outerRadius": {"signal": "width / 2"},
              "cornerRadius": {"signal": "cornerRadius"}
            }
          }
        }
      ]
    }
  EOS

  File.write File.join(File.dirname(__FILE__), 'grafici/fig-risultati-nps.json'), graph

end

def standard_deviation(array)
  mean = array.sum / array.size
  sum = array.inject(0) { |accum, i| accum + ((i - mean) ** 2) }
  Math.sqrt(sum / (array.size).to_f)
end