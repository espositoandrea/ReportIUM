\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fsc-document}[2019/11/11 FSC's document]
\LoadClass[a4paper,twoside,openright,11pt]{book}
\RequirePackage[inner=3.5cm, outer=2.5cm]{geometry}
\RequirePackage[italian]{babel}
\RequirePackage{amssymb}
\RequirePackage[utf8]{inputenc}
\RequirePackage[table,xcdraw]{xcolor}
\RequirePackage[explicit]{titlesec}
\RequirePackage{calc}
\RequirePackage{soul}
\RequirePackage{fourier}
\RequirePackage{booktabs}
\RequirePackage{colortbl}
\RequirePackage{float}
\RequirePackage{wrapfig}
\RequirePackage[labelfont=bf]{caption}
\RequirePackage[labelfont=bf]{subcaption}
\providecommand{\abstract}{}
\RequirePackage{abstract}
\RequirePackage{fancyhdr}
\RequirePackage{hyperref}
\RequirePackage{graphicx}
\RequirePackage{translations}
\DeclareTranslationFallback{the-team}{The team}
\DeclareTranslation{Italian}{the-team}{Il team}
\DeclareTranslation{English}{the-team}{The team}
\newcommand\course[1]{\renewcommand\@course{#1}}
\newcommand\@course{{}}
\newcommand\doctype[1]{\renewcommand\@doctype{#1}}
\newcommand\@doctype{}
\newcommand\license[1]{\renewcommand\@license{#1}}
\newcommand\@license{}
\newcommand\version[1]{\renewcommand\@version{#1}}
\newcommand\@version{}
\newcommand\authorsid[1]{\renewcommand\@authorsid{#1}}
\newcommand\@authorsid{}
\newcommand\authorsmail[1]{\renewcommand\@authorsmail{#1}}
\newcommand\@authorsmail{}
\newcommand\@subtitle{}
\newcommand{\subtitle}[1]{\renewcommand{\@subtitle}{#1}}

\makeatletter
\def\maketitle{
    \null
    \pagestyle{empty}
    \begin{center}
      
      \vspace*{0.5 cm}
      \textsc{\Large \@doctype{}}\\[0.5 cm]
      \textsc{\large \@course{}}\\[1 cm]
    % University or Project Logo:
    \includegraphics[height=4cm]{logo.png}\\[0.5 cm]
    
    \rule{\linewidth}{0.2 mm}\\[0.4 cm]
    % Document Title:
    { \huge \bfseries \textsc{\@title}}\\
	{\large \textsc{\@subtitle}}\\
    \rule{\linewidth}{0.2 mm}\\[0.5 cm]
    % \vspace{1cm}
    % \vspace*{\fill}
    
    {\large \@date}\\[2 cm]
    
    \vspace*{\fill}
    
    \begin{center} \large %originally flushleft
    	{\large Prof.ssa Rosa Lanzilotti}\\[0.5cm]
      \begin{tabular}{@{}lcr@{}}
        Nome e Cognome & Matricola & E-Mail\\
        \midrule
        Alessandro Annese & \texttt{676964} & \texttt{a.annese23@studenti.uniba.it}\\
        Davide De Salvo & \texttt{676502} & \texttt{d.desalvo@studenti.uniba.it}\\
        Andrea Esposito & \texttt{677021} & \texttt{a.esposito39@studenti.uniba.it}\\
        Graziano Montanaro & \texttt{677909} & \texttt{g.montanaro16@studenti.uniba.it}\\
        Regina Zaccaria & \texttt{675888} & \texttt{r.zaccaria14@studenti.uniba.it}
      \end{tabular}
    %   \textbf{\underline{\GetTranslation{the-team}}}\\
    % \@author
  \end{center}
%        \begin{minipage}{0.4\textwidth}
  %            \begin{flushright} \large % Your Student Number
    %                \textbf{\underline{Matricole:}} \\
    %                675888\\
    %                676502\\
    %                676964\\
    %                677021\\
    %                677909
  %            \end{flushright}
%        \end{minipage}
% \\[2 cm]
% Date or Degree Course:
    \clearpage
    \topskip0pt
    \vspace*{\fill}
    \includegraphics[height=0.4\textwidth]{Logo_FSC_WhiteBg.png}\\[0.5cm]
    \textit{\textbf{F.S.C.} --- Five Students of Computer Science}
    
    \vspace*{5cm}
    
    \begin{flushleft}
      \begin{minipage}{\textwidth}%0.75
        \begin{quote}
          {Versione \@version, pubblicata il: \@date}
          \vskip15pt
          \@license{}
        \end{quote}
    \end{minipage}
  \end{flushleft}
  
  \vspace*{\fill}
\end{center}
  }
  \makeatother
  
  \pagestyle{fancy}
  \fancyhf{}
  \fancyhead[LE,RO]{\leftmark}
  \fancyhead[RE,LO]{\rightmark}
  \fancyfoot[CE,CO]{}
  \fancyfoot[LE,RO]{\thepage}
  \renewcommand{\headrulewidth}{1pt}
  \renewcommand{\footrulewidth}{1pt}
  
  \fancypagestyle{plain}{ %
  \fancyhf{} % remove everything
  \fancyfoot[LE,RO]{\thepage}
  \renewcommand{\headrulewidth}{0pt} % remove lines as well
  \renewcommand{\footrulewidth}{1pt}
}

%\RequirePackage[explicit]{titlesec}
%\RequirePackage[outline]{contour}
%\contourlength{0.15pt}
%\newcommand*\chapterlabel{}
%\titleformat{\chapter}
%{\gdef\chapterlabel{}
%	\normalfont\Huge\bfseries\scshape}
%{\gdef\chapterlabel{\thechapter.\ }}{0pt}
%{\begin{tikzpicture}[remember picture,overlay]
%	\node[yshift=-3cm] at (current page.north west)
%	{\begin{tikzpicture}[remember picture, overlay]
%		\draw[fill=secondary-color, draw=none] (0,0) rectangle
%    (\paperwidth,3cm);
%    \draw[draw=black, line width=1.5pt] (0,0)--(\paperwidth,0);
%		\node[anchor=east,xshift=.95\paperwidth,rectangle,
%		rounded corners=20pt,inner sep=15pt,
%		fill=emotionally-color, draw=black, line width=1.5pt]
%		{\contour{black}{\color{white}\chapterlabel#1}};
%		\end{tikzpicture}
%	};
%\end{tikzpicture}
%}
%\titlespacing*{\chapter}{0pt}{50pt}{-60pt}
