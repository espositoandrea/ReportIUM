#!/usr/bin/python3

import glob
import os
import shutil
import subprocess
import colorama
import progressbar
import sys

import generate

__TARGETS__ = {}

__progressbar_widgets = [
    f'{colorama.Fore.YELLOW} [', progressbar.Timer(), '] ',
    progressbar.Bar(),
    ' (', progressbar.ETA(), f') {colorama.Style.RESET_ALL}',
]


def target(func):
    def wrapper(*args, **kwargs):
        func(*args, **kwargs)

    __TARGETS__[func.__name__] = func
    return wrapper


def build_latex(texfile):
    pdflatex = ['pdflatex', '-interaction=batchmode', f'{texfile}.tex']
    biber = ['biber', texfile]

    for command in progressbar.progressbar([pdflatex, biber, pdflatex, pdflatex], redirect_stdout=True, redirect_stderr=True, widgets=__progressbar_widgets):
        try:
            subprocess.run(command, check=True,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        except subprocess.CalledProcessError as e:
            print(f"{colorama.Fore.RED}ERROR: {str(e)}{colorama.Style.RESET_ALL}")


@target
def all():
    euristica()
    documentazione()


@target
def clean():
    files_grabbed = []
    for ext in [
        "bcf", "run.xml", "aux", "glo",
        "idx", "log", "toc", "ist", "acn",
        "acr", "alg", "bbl", "blg", "dvi",
        "glg", "gls", "ilg", "ind", "lof",
        "lot", "maf", "mtc", "mtc1", "out",
        "synctex.gz", "synctex(busy)", "thm"
    ]:
        files_grabbed.extend(glob.glob(f'**/*.{ext}', recursive=True))

    for files in files_grabbed:
        os.remove(files)


@target
def documentazione():
    print("Building documentation")
    os.chdir('documentazione')
    build_latex('ReportIUM')
    os.chdir('..')


@target
def euristica():
    print("Building 'Alessandro'")
    alessandro()
    print("Building 'Davide'")
    davide()
    print("Building 'Andrea'")
    andrea()
    print("Building 'Graziano'")
    graziano()
    print("Building 'Regina'")
    regina()


def build_euristica(filename, author):
    generate.run_externally(filename, author)


@target
def alessandro():
    build_euristica('valutazione-euristica/alessandro.csv',
                    'Alessandro Annese')
    os.chdir('valutazione-euristica/alessandro/')
    build_latex('alessandro')
    os.chdir('../../')


@target
def davide():
    build_euristica('valutazione-euristica/davide.csv', 'Davide De Salvo')
    os.chdir('valutazione-euristica/davide/')
    build_latex('davide')
    os.chdir('../../')


@target
def andrea():
    build_euristica('valutazione-euristica/andrea.csv', 'Andrea Esposito')
    os.chdir('valutazione-euristica/andrea/')
    build_latex('andrea')
    os.chdir('../../')


@target
def graziano():
    build_euristica('valutazione-euristica/graziano.csv', 'Graziano Montanaro')
    os.chdir('valutazione-euristica/graziano/')
    build_latex('graziano')
    os.chdir('../../')


@target
def regina():
    build_euristica('valutazione-euristica/regina.csv', 'Regina Zaccaria')
    os.chdir('valutazione-euristica/regina/')
    build_latex('regina')
    os.chdir('../../')


def grab_pdf():
    return glob.glob('**/*.pdf', recursive=True)


@target
def dist():
    all()
    for file in grab_pdf():
        shutil.move(file, os.path.join('out/', os.path.basename(file)))


if __name__ == "__main__":
    if len(sys.argv) <= 1:
        all()
    else:
        for target in sys.argv[1:]:
            try:
                __TARGETS__[target]()
            except KeyError:
                print(
                    f"{colorama.Fore.RED}ERROR: The specified target ('{target}') could not be found.{colorama.Style.RESET_ALL}")
