import argparse
import pandas as pd
import os
import datetime
from babel.dates import format_date, format_datetime, format_time


def setup_args():
    parser = argparse.ArgumentParser("Generate a table for HCI's report.")
    parser.add_argument(
        'input',
        metavar='INPUT',
        help='The input file'
    )

    parser.add_argument(
        '--author',
        metavar='author',
        help='The author of the table',
        default='FSC --- Five Students of Computer Science'
    )

    return parser.parse_args()


def get_data_from_file(file_name):
    extension = os.path.splitext(file_name)[1]
    if extension == '.csv':
        data = pd.read_csv(file_name)
    elif extension in ['.xls', '.xlsx']:
        data = pd.read_excel(file_name)
    else:
        raise AssertionError(
            "The input ile must be either an Excel or a CSV file")

    return data

def latex_table_from_data(data, author):
    table = list()
    for index, row in data.iterrows():
        table += list('\t' + str(index + 1) + ' & ')
        table += list(' & '.join([str(l[1]) for l in row.iteritems()]) + ' \\\\\n')
        # table += '&'.join()

    table[-3:] = "\\\\*"
    table = ''.join(table)
    latex = f'''\\begin{{longtable}}[c]{{@{{}}m{{1cm}}llllm{{2cm}}@{{}}}}
\t\\caption{{Tabella dei risultati della valutazione euristica condotta sul sito del comune di Taranto da {author}.}}
\t\\label{{tab:val-euristica-{author.replace(' ', '')}}}\\\\
\t\\toprule
\tN.ro & Locazione & Problema & Euristica violata & Possibile soluzione & Grado di severità\\footnotemark \\\\* \\midrule
\t\\endhead
{table}
\t\\bottomrule
\end{{longtable}}
\\footnotetext{{Scala $\left [1, 5 \\right ]$, dove $1$ indica un problema lieve e $5$ un problema grave}}'''
    return latex


def fill_template(author, data, input_file_name):
    with open(os.path.join(os.path.dirname(__file__), 'valutazione-euristica/_master/main.tex'), "r") as f:
        content = f.read()
    
    content = content.replace('~~AUTHOR~~', author)
    content = content.replace('~~DATE~~', format_date(datetime.datetime.now(), format='long', locale='it'))

    base_name = os.path.splitext(os.path.split(input_file_name)[-1])[0]
    with open(os.path.join(os.path.dirname(__file__), 'valutazione-euristica/',base_name,base_name + '.tex'), "w") as f:
        f.write(content)

    with open(os.path.join(os.path.dirname(__file__), 'valutazione-euristica/',base_name,'table.tex'), "w") as f:
        f.write(latex_table_from_data(data, author))


def main():
    args = setup_args()
    data = get_data_from_file(args.input)

    fill_template(args.author, data, args.input)


if __name__ == "__main__":
    main()
