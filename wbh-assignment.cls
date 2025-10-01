% !TeX encoding = UTF-8
% wbh-assignment.sty
%
% Style-File zum Satz der Bachelor-Thesis an der "Wilhelm Büchner Hochschule
% Darmstadt (Pfungsstadt)" mit LaTeX. Alle Rechte liegen bei der Hochschule.
%
% Autor:    Markus Kwaśnicki (MK)
% Version:  v1.1 (Final release)
% Stand:    2016-01-25
% Korrekuren: M. Lammarsch, zuletzt 2023-25-04
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{wbh-assignment}[2024/09/15 WBH Assignment Template by Kilian Vogler based on HfTL-Thesis Template by Martin Meszaros] 

% ----------------------------------------------------
% define language options for automated translation of specific pages
\RequirePackage{etoolbox}
\preto\@classoptionslist{ngerman,}
\newcommand{\@thesisLanguage}{UKenglish,USenglish,main=ngerman}
\DeclareOption{ngerman}{\renewcommand{\@thesisLanguage}{UKenglish,USenglish,main=ngerman}}
\DeclareOption{UKenglish}{\renewcommand{\@thesisLanguage}{ngerman,USenglish,main=UKenglish}}
\DeclareOption{USenglish}{\renewcommand{\@thesisLanguage}{ngerman,UKenglish,main=USenglish}}
\DeclareOption{english}{\renewcommand{\@thesisLanguage}{ngerman,main=english}}

\newif\if@numeric\@numerictrue
\newif\if@authoryear
\newif\if@alphabetic
\DeclareOption{numeric}{
	\@numerictrue%
	\@authoryearfalse%
	\@alphabeticfalse%
}
\DeclareOption{authoryear}{
	\@numericfalse%
	\@authoryeartrue%
	\@alphabeticfalse%
}
\DeclareOption{alphabetic}{
	\@numericfalse%
	\@authoryearfalse%
	\@alphabetictrue%
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}}
\ProcessOptions\relax
\PackageInfo{hftlthesis}{Using language: \@thesisLanguage}
% ----------------------------------------------------

% ----------------------------------------------------
% Use scrbook as base document class
\LoadClass[
a4paper,
12pt,
toc=flat,
toc=listof,
toc=bibliography,
parskip=full,
\@thesisLanguage,
titlepage=firstiscover,
twoside=false,
numbers=noenddot,
DIV=13,
captions=figurebelow,
captions=tableabove
]
{scrbook}

% ----------------------------------------------------
% Load required packages
\RequirePackage[utf8]{inputenc} %Enable UTF-8 support
\RequirePackage{scrhack} % fixes listings and float environments for KOMA Classes
\RequirePackage{xifthen} %For internal use
\RequirePackage{XCharter} % XCharter as default serif font (Text)
\RequirePackage[defaultsans]{opensans} % OpenSans as default sans serif font (headings)
\RequirePackage[scale=.95]{sourcecodepro} % Source Code Pro as default monospace font (Code)
\RequirePackage[T1]{fontenc} % Select font encoding
\RequirePackage[\@thesisLanguage]{babel} %Package for label translation and hyphenation settings

\RequirePackage[
	backend=biber,
	backref,
	maxbibnames=5,
	toc=bib,
	sorting=none
]{biblatex}

\@ifpackagelater{biblatex}{2016/03/01}{%
	\ExecuteBibliographyOptions{
		giveninits=true%
	}%
}{%
	\ExecuteBibliographyOptions{%
		firstinits=true%
	}%
}

\if@numeric%
	\PassOptionsToPackage{
		style=numeric-comp,%
		sorting=none%
	}{biblatex}%
\else%
\if@authoryear%
	\PassOptionsToPackage{
		style=authoryear-comp,%
		uniquename=init
	}{biblatex}%
\else%
\if@alphabetic%
	\PassOptionsToPackage{
		style=alphabetic%
	}{biblatex}%
\fi\fi\fi%



\RequirePackage[final]{graphicx} % Needed in order to include graphics
\RequirePackage[svgnames]{xcolor} % support for colors. See https://www.latextemplates.com/svgnames-colors for available ones

\RequirePackage{csquotes} % Language dependend quotation marks with \enquote{text}
\RequirePackage{ragged2e} % more advanced text layout

\RequirePackage{amsmath} %For math environents
\RequirePackage{multirow} %Allows merging table cells
\RequirePackage{longtable} %For tables spanning multiple pages
\RequirePackage{tabularx}
\RequirePackage{needspace}
\RequirePackage{booktabs}
% nicer looking table rules like \toprule or \botomrule

\RequirePackage{microtype}
\RequirePackage[headsepline,footsepline,automark,plainheadsepline,plainfootsepline]{scrlayer-scrpage}


\RequirePackage[bookmarks,unicode]{hyperref}
\RequirePackage[acronym,shortcuts,toc,translate=babel]{glossaries}

%\RequirePackage{Ressources/glossaries-style-acronymlist}
% ----------------------------------------------------

% ----------------------------------------------------
% Settings for document layout
\clubpenalty = 10000				% prevent single lines at the beginning of a paragraph (Schusterjungen)
\widowpenalty = 10000				% prevent single lines at the end of a paragraph (Hurenkinder)
\displaywidowpenalty = 10000		%
% ----------------------------------------------------

% ----------------------------------------------------
% Definition of the glossarie style "acronymlist"
\newlength{\@thislen}
\newlength{\@tmplen}

\newcommand{\@updatelabeliflonger}[1]{
	\ifdim\@tmplen>\@thislen%
	\@thislen=\@tmplen%
	\edef\longestacrlabel{\glsentryname{\thislabel}}%
	\fi
}
\renewcommand*\glspostdescription{\dotfill}
\newcommand{\setlongestacrlabel}[1]{
	\newcommand{\longestacrlabel}{}
	\ifthenelse{\isempty{#1}}{
		% #1 is empty	
		\ifcsdef{@glsref@\acronymtype}{
			\forglsentries[\acronymtype]{\thislabel}
			{\xifinlistcs{\thislabel}{@glsref@\acronymtype}{%
					\settowidth{\@tmplen}%
					{\glsentryname{\thislabel}}%
					\@updatelabeliflonger{\thislabel}%
				}{}
			}%
		}{\@gls@noref@warn{\acronymtype}}		
	}{
		\renewcommand{\longestacrlabel}{#1}
	}
}
\newcommand{\acrlabelfont}[1]{\textbf{#1}}
\newglossarystyle{acronymlist}{%	
	\setglossarystyle{list}	
	
	
	\renewenvironment{theglossary}%	
	{	\ifdef{\longestacrlabel}%
		{\relax}{%	  
			\setlongestacrlabel{}
		}
		\raggedright\begin{list}{}
			{\settowidth{\labelwidth}{\acrlabelfont{\longestacrlabel}}
				\addtolength{\labelwidth}{1em}
				\setlength{\leftmargin}{\labelwidth}
				\setlength{\itemsep}{-.1em}
				\addtolength{\leftmargin}{\labelsep}						
		}}{\end{list}}%
	
	\renewcommand*{\glossentry}[2]{%
		\item[\acrlabelfont{\glsentryitem{##1}%
			\glstarget{##1}{\glossentryname{##1}}\hfill}]
		\glossentrydesc{##1}\glspostdescription\space ##2}%
} 

\setglossarystyle{acronymlist}
% ----------------------------------------------------

% ----------------------------------------------------
% Sets the layout of page footer and header
\pagestyle{scrheadings}
\clearpairofpagestyles
\renewcommand\chaptermarkformat{\chaptername\space\thechapter:\space}
\lofoot[\theThesisAuthor\space(861105)\space - \space B-EBF01-XX6]{\theThesisAuthor\space(861105)\space - \space B-EBF01-XX6}
\ofoot[\pagemark]{\pagemark}
\ohead[\headmark]{\headmark}
\setkomafont{pageheadfoot}{\footnotesize}
% ----------------------------------------------------


% ----------------------------------------------------
% Provide localized captions and renames labes
\addto\captionsngerman{
	\renewcommand{\acronymname}{Abkürzungsverzeichnis} % for some reason providecaptionname does not work for renaming the acronyms, so using the Babel way here
}
\addto\captionsUKenglish{
	\renewcommand{\acronymname}{List of Abbreviations} % for some reason providecaptionname does not work for renaming the acronyms, so using the Babel way here
}
\addto\captionsUSenglish{
	\renewcommand{\acronymname}{List of Abbreviations} % for some reason providecaptionname does not work for renaming the acronyms, so using the Babel way here
}
\addto\captionsenglish{
	\renewcommand{\acronymname}{List of Abbreviations} % for some reason providecaptionname does not work for renaming the acronyms, so using the Babel way here
}

\AtBeginDocument{%
	\providecaptionname{ngerman}{\lstlistlistingname}{Quellcodeverzeichnis} %rename list of listings
	\providecaptionname{ngerman}{\lstlistingname}{Quellcode} %rename label of listings
	
	\newcaptionname{ngerman}{\firstreviewercaption}{Erstprüfer}
	\newcaptionname{ngerman}{\secondreviewercaption}{Zweitprüfer}
	\newcaptionname{ngerman}{\submittedcaption}{Vorgelegt am}
	\newcaptionname{ngerman}{\topiccaption}{Thema}
	\newcaptionname{ngerman}{\submittedbycaption}{Vorgelegt von}
	\newcaptionname{ngerman}{\dateofbirthcaption}{Geboren am}
	\newcaptionname{ngerman}{\placeofbirthcaption}{Geboren in}
	
	\newcaptionname{ngerman}{\declarationofauthorshipcaption}{Selbstständigkeitserklärung}

	\newcaptionname{ngerman}{\declarationofauthorshipstatementonecaption}{Hiermit erkläre ich, \theThesisAuthor, dass die von mir an der \textit{\theUniversity} eingereichte Arbeit zum Thema}
	\newcaptionname{ngerman}{\declarationofauthorshipstatementtwocaption}{selbstständig verfasst wurde und von mir keine anderen als die angegebenen Quellen und Hilfsmittel verwendet wurden.}
	\newcaptionname{ngerman}{\dencaption}{den }

	\providecaptionname{british,UKenglish,USenglish,american}{\contentsname}{Table of Contents}% For some reason, all english variants have to be declared here
	\providecaptionname{USenglish,UKenglish}{\lstlistlistingname}{List of Sourcecodes} %rename list of listings
	\providecaptionname{USenglish,UKenglish}{\lstlistingname}{Sourcecode} %rename label of listings
	
	\newcaptionname{USenglish,UKenglish}{\firstreviewercaption}{First reviewer}
	\newcaptionname{USenglish,UKenglish}{\secondreviewercaption}{Second reviewer}
	\newcaptionname{USenglish,UKenglish}{\submittedcaption}{Submitted on}
	\newcaptionname{USenglish,UKenglish}{\topiccaption}{Topic}
	\newcaptionname{USenglish,UKenglish}{\submittedbycaption}{Submitted by}
	\newcaptionname{USenglish,UKenglish}{\dateofbirthcaption}{Born on}
	\newcaptionname{USenglish,UKenglish}{\placeofbirthcaption}{Born in}
	
	\newcaptionname{USenglish,UKenglish}{\declarationofauthorshipcaption}{Declaration of Authorship}
	\newcaptionname{USenglish,UKenglish}{\declarationofauthorshipstatementonecaption}{I, \theThesisAuthor, hereby declare that this thesis, submitted at \textit{\theUniversity}, with the topic}
	\newcaptionname{USenglish,UKenglish}{\declarationofauthorshipstatementtwocaption}{was composed indepently and no sources or tools other than those indicated were used.}
	\newcaptionname{USenglish,UKenglish}{\dencaption}{}
}

\DefineBibliographyStrings{ngerman}{%
	andothers = {{et\,al\adddot}}, % 'et al.' instead of 'u.a.'
	backrefpage = {{zitiert auf Seite}},%
	backrefpages = {{zitiert auf den Seiten}},%
	bibliography = {Literaturverzeichnis}
}
% ----------------------------------------------------

% ----------------------------------------------------
% Slight modifications to the bibliography:
% Only print URL, if DOI not present (https://tex.stackexchange.com/questions/424774/print-url-only-if-doi-not-present)
\renewbibmacro*{doi+eprint+url}{%
	\printfield{doi}%
	\newunit\newblock%
	\iftoggle{bbx:eprint}{%
		\usebibmacro{eprint}%
	}{}%
	\newunit\newblock%
	\iffieldundef{doi}{%
		\usebibmacro{url+urldate}}%
	{}%
}

% Unify style of title
\DeclareFieldFormat[inproceedings,article,misc]{title}{\textit{#1}}
% ----------------------------------------------------

% ----------------------------------------------------
%Set default Graphicspath to "Graphics"
\graphicspath{{./Images/}}
% ----------------------------------------------------

% ----------------------------------------------------
% Make space before and after chapter title smaller
\renewcommand*{\chapterheadstartvskip}{%
	\vspace*{2.3\baselineskip}%
}%
\renewcommand*{\chapterheadendvskip}{%
	\vspace{1.725\baselineskip
		\@plus .115\baselineskip \@minus .192\baselineskip}%
}%
% ----------------------------------------------------

% ----------------------------------------------------
% Use the same font for the labels of the labeling environment as for the description labels
\setkomafont{labelinglabel}{
	\usekomafont{descriptionlabel}
}
% ----------------------------------------------------

% ----------------------------------------------------
% Settings for hyperref package
\AtBeginDocument{
	\subject{\theDocumentKind\space\theForDegree}
	\hypersetup
	{
	 pdftitle={B-Prüfung},
	 pdfauthor={Kilian Vogler, Matrikelnummer:861105},
	 pdfsubject={Einführung und Anwendung der Künstlichen Intelligenz},
	 unicode = {true},
	 pdfcreator={LaTeX with hyperref package using WBH Assignment Template by Kilian Vogler},
	%  bookmarks = {true},
	 bookmarksopen = {true},
	 hidelinks
	}
}
% ----------------------------------------------------

% ----------------------------------------------------
% Variable definitions and default values
\newcommand{\theUniversity}{Wilhelm Büchner Hochschule (WBH)}
\newcommand{\theInstitute}{Institut für Telekommunikationsinformatik}
\newcommand{\theDocumentKind}{B-Aufgabe}
\newcommand{\theTopic}{Einführung und Anwendung der Künstlichen Intelligenz}
\title{\theTopic}
\newcommand{\theThesisAuthor}{Kilian Vogler}
\author{\theThesisAuthor}
\newcommand{\theAuthorDateOfBirth}{24.12.1998}
\newcommand{\theAuthorPlaceOfBirth}{Fulda}


\newcommand{\theHandInDate}{16.09.2024}
\date{\theHandInDate}

\newcommand{\theFirstReviewerName}{Prof. Dr. Detlef Musterdude}
\newcommand{\theFirstReviewerInstitution}{Hochschule für Telekommunikation Leipzig}
\newcommand{\theFirstReviewerInstitutionStreet}{Gustav-Freytag-Straße 43-45}
\newcommand{\theFirstReviewerInstitutionPlace}{04277 Leipzig}

\newcommand{\theSecondReviewerName}{Dipl.-Ing. (FH) Monika Musterfrau}
\newcommand{\theSecondReviewerInstitution}{Hochschule für Telekommunikation Leipzig}
\newcommand{\theSecondReviewerInstitutionStreet}{Gustav-Freytag-Straße 43-45}
\newcommand{\theSecondReviewerInstitutionPlace}{04277 Leipzig}

\newcommand{\university}[1]{\renewcommand{\theUniversity}{#1}}
\newcommand{\institute}[1]{\renewcommand{\theInstitute}{#1}}
\newcommand{\documentKind}[1]{\renewcommand{\theDocumentKind}{#1}}
\newcommand{\forDegree}[1]{\renewcommand{\theForDegree}{#1}}

\newcommand{\topic}[1]{\renewcommand{\theTopic}{#1}\title{#1}}
\newcommand{\thesisAuthor}[1]{\renewcommand{\theThesisAuthor}{#1}\author{#1}}


\newcommand{\authorDateOfBirth}[1]{\renewcommand{\theAuthorDateOfBirth}{#1}}
\newcommand{\authorPlaceOfBirth}[1]{\renewcommand{\theAuthorPlaceOfBirth}{#1}}

\newcommand{\handInDate}[1]{\renewcommand{\theHandInDate}{#1}\date{#1}}

\newcommand{\firstReviewerName}[1]{\renewcommand{\theFirstReviewerName}{#1}}
\newcommand{\firstReviewerInstitution}[1]{\renewcommand{\theFirstReviewerInstitution}{#1}}
\newcommand{\firstReviewerInstitutionStreet}[1]{\renewcommand{\theFirstReviewerInstitutionStreet}{#1}}
\newcommand{\firstReviewerInstitutionPlace}[1]{\renewcommand{\theFirstReviewerInstitutionPlace}{#1}}

\newcommand{\secondReviewerName}[1]{\renewcommand{\theSecondReviewerName}{#1}}
\newcommand{\secondReviewerInstitution}[1]{\renewcommand{\theSecondReviewerInstitution}{#1}}
\newcommand{\secondReviewerInstitutionStreet}[1]{\renewcommand{\theSecondReviewerInstitutionStreet}{#1}}
\newcommand{\secondReviewerInstitutionPlace}[1]{\renewcommand{\theSecondReviewerInstitutionPlace}{#1}}
% ----------------------------------------------------

% ----------------------------------------------------
% Definition of the declaration of authorship
\newcommand{\makedeclarationofauthorship}{
\addchap{\declarationofauthorshipcaption}
\declarationofauthorshipstatementonecaption 
\begin{center}
	\textbf{\theTopic}
\end{center}  
\declarationofauthorshipstatementtwocaption

\vspace{1cm}
Fulda, \dencaption \theHandInDate


\vspace{2cm}
\begin{flushright}
	\begin{tabular}{c}
		\hline
		\hspace{2em}\theThesisAuthor\hspace{2em}
	\end{tabular}
\end{flushright}
}
% ----------------------------------------------------

%von Kilian hinzugefügt, damit die URL nicht über den Seitenrand gehen
\usepackage{etoolbox}
\apptocmd{\UrlBreaks}{\do\f\do\m}{}{}
\setcounter{biburllcpenalty}{9000}% Kleinbuchstaben
\setcounter{biburlucpenalty}{9000}% Großbuchstaben

% ----------------------------------------------------