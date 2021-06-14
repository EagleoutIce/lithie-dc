%% lecture-fancy-paper documentclass
%% Florian Sihler, 10 Sep. 2020
%% Based on koma-script
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lecture-fancy-paper}[2020/09/10 The lecture-fancy-paper documentclass]
\def\LayoutName{lecture-fancy-paper}

% First we setup the document options
\LoadClass[%
  numbers=noenddot,ngerman,%
  fontsize=9pt,oneside,%
  titlepage=firstiscover,%
  footnotes=nomultiple,a4paper,%
  twocolumn%
]{scrartcl}
\KOMAoption{listof}{leveldown,totocnumbered}

%% Options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LEDI,prefix=LEDI@}

\DeclareBoolOption{userip}
\DeclareComplementaryOption{norip}{userip}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}
\ProcessKeyvalOptions*

%% Basic packages
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lecture-registers,lecture-coverpage,lithie-birb,pgfornament}

\RequirePackage[english]{babel}
\RequirePackage{tikz,etoolbox,calc,booktabs,pbox,scrhack,caption,stfloats,float}
\usetikzlibrary{decorations.text}

%% Fonts
% needed to allow compat opts
\AtEndPreamble{
\RequirePackage[sc,osf]{mathpazo}
\RequirePackage[euler-digits,small]{eulervm}
\AtBeginDocument{\renewcommand{\hbar}{\hslash}}
\RequirePackage[tabular,lining]{montserrat}
}

%% Microtype
\RequirePackage[activate={true,nocompatibility},final,kerning=true,spacing=true,stretch=50,factor=\@m,shrink=10,selected=true,babel]{microtype}
\SetTracking{encoding={*}, shape=sc}{42}

% we do not want protusion in table of*
\preto\tableofcontents{\microtypesetup{protrusion=false}}
\appto\tableofcontents{\microtypesetup{protrusion=true}}
\AtBeginDocument{\microtypesetup{protrusion=true}}

%% Line handling
\RequirePackage[all]{nowidow}
\RequirePackage{cuted}

%% General Layout & Packages
\RequirePackage{relsize,lastpage,datetime,fontawesome5,afterpage,xstring,graphicx}
\RequirePackage[draft=false]{scrlayer-scrpage}

\newlength\lecture@len@margin \lecture@len@margin=1.5cm
\RequirePackage[a4paper,margin=\lecture@len@margin,includefoot,vcentering]{geometry}
\flushbottom

%% Hyperlinks => Figures, Tables and refs
\RequirePackage[%
    unicode=true,pdfencoding=auto,psdextra,pdftex,%
    backref, pagebackref=false,%
    bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle,%
    pdfborder={0 0 0}, breaklinks=true,%
    colorlinks, hyperindex,%
    bookmarkstype=X@l@X% erase
]{hyperref}

\RequirePackage{bookmark}

% just erases color
\def\nohyper#1{\begingroup\lecture@disablehyper#1\endgroup}
\AtEndPreamble{%
\@ifpackageloaded{lecture-links}{%
\def\lecture@disablehyper{\DisableLinkStyle\hypersetup{allcolors=.}}}%
{\def\lecture@disablehyper{\hypersetup{allcolors=.}}}%
\let\disablehyper\lecture@disablehyper
}

%% Lists
\RequirePackage{lithie-dc@inlists}
\setlist{leftmargin=1.25em,labelwidth=1.25em}
\setlist[description]{labelwidth=*,font=\normalfont\itshape,topsep=\z@ \@plus 2pt,partopsep=\z@ \@plus 2pt}

%% Color-Palettes
\RequirePackage[enumitem,rect,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\LEDI@cpalette}
\UseTikzPalette{\LEDI@tpalette}

%% Footnotes
\deffootnote{2em}{1em}{%
    \makebox[2em][r]{\color{black}\nohyper{\hyperref[lecture@fn:\thesection:\csname lecture@footnoteref@\@mpfn\endcsname]{\thefootnotemark}}}~}

\renewcommand*\thefootnote{$\langle$\arabic{footnote}$\rangle$}
\renewcommand*\thempfootnote{$\langle$\alph{mpfootnote}$\rangle$}

\def\lecture@footnoteref@footnote{fn@\arabic{footnote}}
\def\lecture@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{lecture@fn:\thesection:\csname lecture@footnoteref@\@mpfn\endcsname}\disablehyper}

%% (non) Rectangular paragraphs & hyphenation
\newlength\segskipamount
\segskipamount=.35\baselineskip \@minus .1\baselineskip
\def\segskip{\vspace\segskipamount}

\parindent\z@ \parskip\segskipamount

\columnsep=2em
\renewcommand*{\arraystretch}{1.2}
\linespread{1.2}
\hbadness99999 \vbadness99999

\hyphenpenalty675
\lefthyphenmin\thr@@ \righthyphenmin\thr@@
% min 3 letters before and 2 after hyphen

%% Header and footer
\renewcommand*\sectionmark[1]{\markboth{#1}{}}

\DeclareNewLayer[%
topmargin,background,contents={%
  \rule[\baselineskip]{\layerwidth}{.2em}%
}%
]{lecture.fancy.paper.head.ruler}

\def\lecture@copyright@notice@upper{\iflecture@er{authority}{}{\lecture@r{authority}\iflecture@er{supervisor}{}{,\quad}}\iflecture@er{supervisor}{}{Supervisor: \lecture@r{supervisor}}}
\def\lecture@copyright@notice@lower{\iflecture@er{copyright}{}{\lecture@r{copyright}}}
\renewpairofpagestyles{scrheadings}{%
\ihead{\begingroup\normalsize\normalfont\linespread{1.25}\begin{tikzpicture}[remember picture,overlay]
  \node[below left,yshift=-.25cm,xshift=-\lecture@len@margin,font=\usekomafont{pageheadfoot}\scriptsize,inner sep=\z@,outer sep=\z@,align=right] at(current page.north east) {\lecture@disablehyper\lecture@copyright@notice@upper\\\disablehyper\lecture@copyright@notice@lower};
\end{tikzpicture}\endgroup}
\ofoot{\lecture@disablehyper\strut{\sbfamily\thepage}\thinspace/\thinspace\pageref{LastPage}}%
\ifoot{\lecture@disablehyper\strut\leftmark\iflecture@e{\leftmark}{}{\iflecture@subsecmark{~\paletteA{\faAngleRight}}{}~}\lecture@getsubsecmark\strut}%
}

\AddLayersAtBeginOfPageStyle{scrheadings}{lecture.fancy.paper.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{lecture.fancy.paper.head.ruler}
\colorlet{lecture@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{lecture@headfoot}}
\AtBeginDocument{\pagestyle{scrheadings}}
\newcommand\lecture@abutton[3][\z@]{\raisebox{#1}{\Acrobatmenu{#2}{#3}}}

%% Coverpage
\selectcoverpage{simple-half}
%% Table of contents & sectioning
\let\old@tableofcontents\tableofcontents
\preto\tableofcontents{%
\begingroup
\phantomsection\label{toc}\pdfbookmark[0]{\contentsname}{lecture@toc@@id@toc}%
}
\appto\tableofcontents{\endgroup}

\CloneTOCEntryStyle{tocline}{lecture@toc@section}
\TOCEntryStyleStartInitCode{lecture@toc@section}{%
    \expandafter\renewcommand\csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{##1}}%
}

\newlength\lecture@chapnumberboxwd
\lecture@chapnumberboxwd=2.25em
\def\lecture@chapnumberbox#1{\makebox[\lecture@chapnumberboxwd][r]{#1}}
\RedeclareSectionCommands[tocpagenumberbox=\lecture@chapnumberbox]
  {section,subsection,subsubsection,paragraph,subparagraph}

\renewcommand*\sectionlinesformat[4]{\hskip #2{\paletteA{\smaller#3}}{#4}}

\setkomafont{disposition}{\sffamily\sbfamily}
\RedeclareSectionCommand[runin=false,tocindent=1.85em,afterskip=\z@,%
  beforeskip=1\baselineskip \@plus .33\baselineskip \@minus .33\baselineskip
]{section}

\RedeclareSectionCommand[runin=false,tocindent=4.15em,afterskip=\z@,%
  beforeskip=1\baselineskip \@plus .33\baselineskip \@minus .33\baselineskip
]{subsection}

\RedeclareSectionCommand[%
  runin=on,tocindent=7.15em,afterskip=1ex,%
  beforeskip=\baselineskip
]{subsubsection}

\RedeclareSectionCommand[runin=on, afterskip=1ex, font=\mdseries\rmfamily\itshape,
  beforeskip=.75\baselineskip \@plus .25\baselineskip \@minus .25\baselineskip
]{paragraph}

%% Flexible Chapsums
\newenvironment{wide}{\strip\ignorespaces}{\endstrip{}}

\def\@lecture@c@pre#1{\phantomsection\nobreak#1\nobreak}
\def\lecture@firstoftwo#1#2{#1}
\def\lecture@secondoftwo#1#2{#2}

\DeclareRobustCommand*\lecture@subsecmark[1]{%
\begingroup
\let\label\relax \let\index\relax \let\glossary\relax
\expandafter\protected@xdef\csname lecture@subsec@\thesection @\endcsname{#1}%
\endgroup\if@nobreak\ifvmode\nobreak\fi\fi}

\def\lecture@getsubsecmark{\csname lecture@subsec@\thesection @\endcsname}
\def\iflecture@subsecmark{\ifcsname lecture@subsec@\thesection @\endcsname\expandafter\lecture@firstoftwo\else\expandafter\lecture@secondoftwo\fi}

\let\lecture@section\section
\def\section{\@ifstar{\lecture@star@section}{\@dblarg\lecture@nostar@section}}
\newcounter{lec@starsections}
\def\lecture@star@section#1{\setcounter{lecture@paragraph}0\stepcounter{lec@starsections}\pdfbookmark[1]{#1}{lecture@starsec@@id@\thelec@starsections}\lecture@section*{#1}}
\def\lecture@nostar@section[#1]#2{\lecture@section[#1]{%
  {\pdfbookmark[1]{\thesection)\space#1}{lecture@sec@@id@\thesection}}#2}}

\let\lecture@subsection\subsection
\def\subsection{\@ifstar{\lecture@star@subsection}{\@dblarg\lecture@nostar@subsection}}
\def\lecture@star@subsection#1{\lecture@subsection*{#1}\lecture@subsecmark{#1}}
\def\lecture@nostar@subsection[#1]#2{\lecture@subsection[#1]{%
  {\pdfbookmark[2]{\thesubsection)\space#1}{lecture@subsec@@id@\thesubsection}\lecture@subsecmark{#1}}#2}}

\newcounter{lecture@paragraph}[subsection]
\let\lecture@paragraph\paragraph
\def\paragraph{\@ifstar{\lecture@star@paragraph}{\@dblarg\lecture@nostar@paragraph}}
\def\lecture@star@paragraph#1{\lecture@paragraph*{#1}}
\def\lecture@nostar@paragraph[#1]#2{\stepcounter{lecture@paragraph}\@lecture@c@pre{\pdfbookmark[3]{\roman{lecture@paragraph})\space#1}{lecture@paragr@@id@\thesubsection @\thelecture@paragraph}}\lecture@paragraph[#1]{#2 \paletteA{\textbullet}}}

%% Listpatches
\preto\listoffigures{\begingroup\lecture@disablehyper}
\preto\listoftables{\begingroup\lecture@disablehyper}
\appto\listoffigures{\endgroup}
\appto\listoftables{\endgroup}

\DeclareTOCStyleEntry[]{lecture@toc@section}{section}
\DeclareTOCStyleEntry[]{lecture@toc@section}{subsection}

%% Special ref
% this is redefined by other classes and used as a simple interface
\def\lectureref#1#2{\hyperref[#1]{#2}}
\let\lautoref\autoref

%% Figures, Tables and refs
\addto\captionsngerman{\def\figurename{Abbildung}\def\figureautorefname{\figurename}\def\tablename{Tabelle}\def\tableautorefname{\tablename}}
\addto\captionsenglish{\def\figurename{Figure}\def\figureautorefname{\figurename}\def\tablename{Table}\def\tableautorefname{\tablename}}

\renewcommand*\captionformat{~~}

\def\lecturelinkcolor{%
% we do not use paletteA if we are in a box. we use the box-color instead!
\ifcsname libx@boxid\endcsname\libx@get{BoxColor}\else paletteA\fi
}
\def\lecturelinkfont{\relsize{-1}\sffamily}
\def\lecture@fig@style@nonbold#1{%
    {\hypersetup{allcolors=\lecturelinkcolor}\lecturelinkfont{#1}}%
}
\def\sbfamily{\fontseries{sb}\selectfont}
\def\lecture@fig@style#1{\lecture@fig@style@nonbold{{\sbfamily#1}}}

\DeclareCaptionLabelFormat{lecture-caption}{\lecture@fig@style{\paletteA{#1 #2:~~}}}
\captionsetup{format=plain,indention=1em,labelformat=lecture-caption,labelsep=none}

\AtBeginDocument{%
  \@ifpackageloaded{lecture-links}{%
    \SetAllLinkStyle{\lecture@fig@style{#1}}%
    \SetUrlLinkStyle{\lecture@fig@style@nonbold{#1}}%
    \SetHrefLinkStyle{\lecture@fig@style@nonbold{#1}}%
    \SetFootnoteLinkStyle{\lecture@fig@style@nonbold{#1}}%
    \SetCiteColor{\lecturelinkcolor}%
  }{% dirty patches
    \let\lecture@autoref\autoref
    \renewcommand*\autoref[1]{{\lecture@fig@style{\lecture@autoref{#1}}}}%
    \let\lecture@nameref\nameref
    \renewcommand*\nameref[1]{{\lecture@fig@style{\lecture@nameref{#1}}}}%
  }%
}

%% Extra -- divider
\def\lecturedivider{%
  \par\begingroup\centering\pgfornament[width=.6\linewidth,color=paletteA]{88}\smallskip\par\endgroup}
\renewenvironment{abstract}{\ignorespaces}{\unskip\lecturedivider\medskip\if@nobreak\ifvmode\nobreak\fi\fi}
\endinput