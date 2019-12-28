@echo off

SET TEXFILE=""

IF /I "%1"=="all" GOTO all
IF /I "%1"=="clean" GOTO clean
IF /I "%1"=="documentazione" GOTO documentazione
IF /I "%1"=="euristica" GOTO euristica
IF /I "%1"=="alessandro" GOTO alessandro
IF /I "%1"=="davide" GOTO davide
IF /I "%1"=="andrea" GOTO andrea
IF /I "%1"=="graziano" GOTO graziano
IF /I "%1"=="regina" GOTO regina
IF /I "%1"=="build-latex" GOTO build-latex
IF /I "%1"=="dist" GOTO dist
IF /I "%1"=="dist-copy" GOTO dist-copy
IF /I "%1"=="" GOTO all
GOTO error

:all
	CALL make.bat euristica
	CALL make.bat documentazione
	GOTO :EOF

:clean
	find . -type f \( -name "*.bcf" -o -name "*.run.xml" -o -name "*.aux" -o -name "*.glo" -o -name "*.idx" -o -name "*.log" -o -name "*.toc" -o -name "*.ist" -o -name "*.acn" -o -name "*.acr" -o -name "*.alg" -o -name "*.bbl" -o -name "*.blg" -o -name "*.dvi" -o -name "*.glg" -o -name "*.gls" -o -name "*.ilg" -o -name "*.ind" -o -name "*.lof" -o -name "*.lot" -o -name "*.maf" -o -name "*.mtc" -o -name "*.mtc1" -o -name "*.out" -o -name "*.synctex.gz" -o -name "*.synctex(busy)" -o -name "*.thm" \) -delete
	GOTO :EOF

:documentazione
	PUSHD 'documentazione' && CALL ../make.bat build-latex TEXFILE=ReportIUM && POPD
	GOTO :EOF

:euristica
	CALL make.bat alessandro
	CALL make.bat davide
	CALL make.bat andrea
	CALL make.bat graziano
	CALL make.bat regina
	GOTO :EOF

:alessandro
	py -3 generate.py valutazione-euristica/alessandro.csv --author 'Alessandro Annese'
	PUSHD 'valutazione-euristica/alessandro/' && CALL ../../make.bat build-latex TEXFILE=alessandro && POPD
	GOTO :EOF

:davide
	py -3 generate.py valutazione-euristica/davide.csv --author 'Davide De Salvo'
	PUSHD 'valutazione-euristica/davide/' && CALL ../../make.bat build-latex TEXFILE=davide && POPD
	GOTO :EOF

:andrea
	py -3 generate.py valutazione-euristica/andrea.csv --author 'Andrea Esposito'
	PUSHD 'valutazione-euristica/andrea/' && CALL ../../make.bat build-latex TEXFILE=andrea && POPD
	GOTO :EOF

:graziano
	py -3 generate.py valutazione-euristica/graziano.csv --author 'Graziano Montanaro'
	PUSHD 'valutazione-euristica/graziano/' && CALL ../../make.bat build-latex TEXFILE=graziano && POPD
	GOTO :EOF

:regina
	py -3 generate.py valutazione-euristica/regina.csv --author 'Regina Zaccaria'
	PUSHD 'valutazione-euristica/regina/' && CALL ../../make.bat build-latex TEXFILE=regina && POPD
	GOTO :EOF

:build-latex
	pdflatex -interaction=batchmode "%TEXFILE%.tex"
	biber "%TEXFILE%"
	pdflatex -interaction=batchmode "%TEXFILE%.tex"
	pdflatex -interaction=batchmode "%TEXFILE%.tex"
	GOTO :EOF

:dist
	CALL make.bat all
	find -type f -name "*.pdf" -exec mv {} ./out \;
	GOTO :EOF

:dist-copy
	CALL make.bat all
	find -type f -name "*.pdf" -exec cp {} ./out \;
	GOTO :EOF

:error
    IF "%1"=="" (
        ECHO make: *** No targets specified and no makefile found.  Stop.
    ) ELSE (
        ECHO make: *** No rule to make target '%1%'. Stop.
    )
    GOTO :EOF
