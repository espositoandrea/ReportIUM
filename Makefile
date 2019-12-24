TEXFILE=


.PHONY: clean alessandro davide andrea graziano regina build-latex euristica documentazione dist dist-copy

all: | euristica documentazione

clean:
	find . -type f \( -name "*.bcf" -o -name "*.run.xml" -o -name "*.aux" -o -name "*.glo" -o -name "*.idx" -o -name "*.log" -o -name "*.toc" -o -name "*.ist" -o -name "*.acn" -o -name "*.acr" -o -name "*.alg" -o -name "*.bbl" -o -name "*.blg" -o -name "*.dvi" -o -name "*.glg" -o -name "*.gls" -o -name "*.ilg" -o -name "*.ind" -o -name "*.lof" -o -name "*.lot" -o -name "*.maf" -o -name "*.mtc" -o -name "*.mtc1" -o -name "*.out" -o -name "*.synctex.gz" -o -name "*.synctex(busy)" -o -name "*.thm" \) -delete

documentazione:
	cd 'documentazione' && $(MAKE) -f '../Makefile' build-latex TEXFILE=ReportIUM

euristica: alessandro davide andrea graziano regina

alessandro:
	python3 generate.py valutazione-euristica/alessandro.csv --author 'Alessandro Annese'
	cd 'valutazione-euristica/alessandro/' && $(MAKE) -f '../../Makefile' build-latex TEXFILE=alessandro

davide:
	python3 generate.py valutazione-euristica/davide.csv --author 'Davide De Salvo'
	cd 'valutazione-euristica/davide/' && $(MAKE) -f '../../Makefile' build-latex TEXFILE=davide

andrea:
	python3 generate.py valutazione-euristica/andrea.csv --author 'Andrea Esposito'
	cd 'valutazione-euristica/andrea/' && $(MAKE) -f '../../Makefile' build-latex TEXFILE=andrea

graziano:
	python3 generate.py valutazione-euristica/graziano.csv --author 'Graziano Montanaro'
	cd 'valutazione-euristica/graziano/' && $(MAKE) -f '../../Makefile' build-latex TEXFILE=graziano

regina:
	python3 generate.py valutazione-euristica/regina.csv --author 'Regina Zaccaria'
	cd 'valutazione-euristica/regina/' && $(MAKE) -f '../../Makefile' build-latex TEXFILE=regina

build-latex:
	pdflatex -interaction=batchmode "$(TEXFILE).tex"
	biber "$(TEXFILE)"
	pdflatex -interaction=batchmode "$(TEXFILE).tex"
	pdflatex -interaction=batchmode "$(TEXFILE).tex"

dist: all
	find -type f -name "*.pdf" -exec mv {} ./out \;

dist-copy: all
	find -type f -name "*.pdf" -exec cp {} ./out \;

