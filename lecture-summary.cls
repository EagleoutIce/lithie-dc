%% lecture-summary documentclass
%% Florian Sihler, 10 Sep. 2020
%%
%% Based on koma-script
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lecture-summary}[2020/09/10 The lecture-summary documentclass]
\def\LayoutName{lecture-summary}

% First we setup the document options
\LoadClass[%
  numbers=noenddot,ngerman,%
  fontsize=10pt,oneside,%
  footnotes=nomultiple,a4paper,%
  twocolumn%
]{scrartcl}

\KOMAoption{listof}{totocnumbered}

%% Options
%% -----------------------------------------------------------------------------
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LEDI,prefix=LEDI@}

\DeclareBoolOption{userip}
\DeclareComplementaryOption{norip}{userip}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}

\ProcessKeyvalOptions*%

%% Basic packages
%% -----------------------------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lecture-registers,lecture-coverpage,lithie-birb,pgfornament}

\RequirePackage{babel}
\RequirePackage{tikz,etoolbox,calc,booktabs,pbox,scrhack,caption,stfloats,float,translations}
\usetikzlibrary{decorations.text}

%% Fonts
%% -----------------------------------------------------------------------------
% needed to allow compat opts
\AtEndPreamble{%
\RequirePackage[sc,osf]{mathpazo}
\RequirePackage[euler-digits,small]{eulervm}
\AtBeginDocument{\def\hbar{\hslash}}
\RequirePackage[tabular,lining]{montserrat}%
}

%% Microtype
%% -----------------------------------------------------------------------------

\RequirePackage[activate={true,nocompatibility},final,kerning=true,spacing=true,stretch=50,factor=1000,shrink=10,selected=true,babel]{microtype}

%% Line handling
%% -----------------------------------------------------------------------------
\RequirePackage[all]{nowidow}
\RequirePackage{cuted}

%% General Layout & Packages
%% -----------------------------------------------------------------------------
\RequirePackage{relsize,lastpage,datetime,fontawesome5,afterpage,xstring,graphicx}
\RequirePackage[draft=false]{scrlayer-scrpage}

\newlength\lecture@len@margin \lecture@len@margin=2cm
\RequirePackage[a4paper,margin=\lecture@len@margin,includefoot,vcentering]{geometry}
\flushbottom

%% Hyperlinks => Figures, Tables and refs
%% -----------------------------------------------------------------------------
\RequirePackage[%
    unicode=true,pdfencoding=auto,psdextra,pdftex, %
    backref, pagebackref=false, %
    bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle, %
    pdfborder={0 0 0}, breaklinks=true, %
    colorlinks, hyperindex, bookmarkstype=X@lecture@X% erase
]{hyperref}

\RequirePackage{bookmark}

% just erases color
\def\nohyper#1{\bgroup\lecture@disablehyper#1\egroup}
\AtEndPreamble{%
\@ifpackageloaded{lecture-links}{%
\def\lecture@disablehyper{\DisableLinkStyle\hypersetup{allcolors=.}}}%
{\def\lecture@disablehyper{\hypersetup{allcolors=.}}}%
\let\disablehyper\lecture@disablehyper
}

%% Lists
%% -----------------------------------------------------------------------------
\PassOptionsToPackage{inline}{enumitem}
\RequirePackage{enumitem}

\DeclareTranslationFallback{t-and}{, and}
\DeclareTranslation{English}{t-and}{, and}
\DeclareTranslation{German}{t-and}{und}

\DeclareTranslationFallback{t-or}{, or}
\DeclareTranslation{English}{t-or}{, or}
\DeclareTranslation{German}{t-or}{oder}

\setlist{leftmargin=1.25em,labelwidth=1.25em}
\newlist{inlist}{enumerate*}{1}
\setlist[inlist]{itemjoin={{, }},itemjoin*={{\GetTranslation{t-and} }},label=($\roman*$),mode=boxed}
\newlist{orlist}{enumerate*}{1}
\setlist[orlist]{itemjoin={{, }},itemjoin*={{\GetTranslation{t-or} }},label=($\alph*$),mode=boxed}
\setlist[description]{labelwidth=*,font=\normalfont\itshape,topsep=\z@ plus 2pt,partopsep=\z@ plus 2pt}

%% Color-Palettes
%% -----------------------------------------------------------------------------
\RequirePackage[enumitem,rect,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\LEDI@cpalette}
\UseTikzPalette{\LEDI@tpalette}

%% Footnotes
%% -----------------------------------------------------------------------------

\deffootnote{2em}{1em}{%
    \makebox[2em][r]{\nohyper{\hyperref[lecture@fn:\thesection:\@nameuse{lecture@footnoteref@\@mpfn}]{\thefootnotemark}}}~}

\renewcommand*{\thefootnote}{$\langle$\arabic{footnote}$\rangle$}
\renewcommand*{\thempfootnote}{$\langle$\alph{mpfootnote}$\rangle$}

\def\lecture@footnoteref@footnote{fn@\arabic{footnote}}
\def\lecture@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{lecture@fn:\thesection:\@nameuse{lecture@footnoteref@\@mpfn}}\disablehyper}

%% (non) Rectangular paragraphs & hyphenation
%% -----------------------------------------------------------------------------

\newlength\segskipamount
\segskipamount=.25\baselineskip plus .1\baselineskip minus .1\baselineskip
\def\segskip{\vspace\segskipamount}

\parindent=\z@
\parskip=\segskipamount

\columnsep=2em
\renewcommand*{\arraystretch}{1.25}
\linespread{1.2}
\hbadness=99999 \vbadness=99999

\hyphenpenalty=475
\lefthyphenmin=3 \righthyphenmin=3
% min 3 letters before and 2 after hyphen

%% Header and footer
%% -----------------------------------------------------------------------------

\renewcommand*{\sectionmark}[1]{\markboth{#1}{}}

\DeclareNewLayer[%
topmargin,background,contents={%
  \rule[\baselineskip]{\layerwidth}{0.2em}%
}%
]{lecture.fancy.paper.head.ruler}

\def\lecture@copyright@notice@upper{\lecture@r{title}, \lecture@r{subtitle}}
\def\lecture@copyright@notice@lower{\lecture@rs{brief}}
\renewpairofpagestyles{scrheadings}{%
\ihead{\begin{tikzpicture}[remember picture,overlay]
  \node[below left,yshift=-0.25cm,xshift=-\lecture@len@margin,font=\usekomafont{pageheadfoot}\scriptsize,inner sep=\z@,outer sep=\z@,align=right] at(current page.north east) {\disablehyper\lecture@copyright@notice@upper\\\disablehyper\lecture@copyright@notice@lower};
\end{tikzpicture}}
\ofoot{\strut\nohyper{{\sbfamily\thepage}\thinspace/\thinspace\pageref{LastPage}}}%
\ifoot{\strut\nohyper{\leftmark\iflecture@e{\leftmark}{}{\iflecture@subsecmark{~\paletteA{\faAngleRight}}{}~}\lecture@getsubsecmark}\strut}%
}

\newpairofpagestyles{initial@scrheadings}{%
\ofoot{\strut\nohyper{{\sbfamily\thepage}\thinspace/\thinspace\pageref{LastPage}}}%
\ifoot{\strut\nohyper{\leftmark\iflecture@e{\leftmark}{}{\iflecture@subsecmark{~\paletteA{\faAngleRight}}{}~}\lecture@getsubsecmark}\strut}%
}

\AddLayersAtBeginOfPageStyle{scrheadings}{lecture.fancy.paper.head.ruler}
\AddLayersAtBeginOfPageStyle{initial@scrheadings}{lecture.fancy.paper.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{lecture.fancy.paper.head.ruler}

\colorlet{lecture@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{lecture@headfoot}}

\AtBeginDocument{\thispagestyle{initial@scrheadings}\pagestyle{scrheadings}}

%% Coverpage
%% -----------------------------------------------------------------------------

\selectcoverpage{compact-upper}%


%% Table of contents & sectioning
%% -----------------------------------------------------------------------------

\unsettoc{toc}{onecolumn}
\setuptoc{toc}{noprotrusion}
\let\old@tableofcontents\tableofcontents
\preto\tableofcontents{%
\bgroup%
\phantomsection\label{toc}\pdfbookmark[0]{\contentsname}{lecture@toc@@id@toc}%
}
\appto\tableofcontents{\egroup}
\deftocheading{toc}{}

\CloneTOCEntryStyle{tocline}{lecture@toc@section}
\TOCEntryStyleStartInitCode{lecture@toc@section}{%
    \expandafter\renewcommand%
    \csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{##1}}%
}

\newlength\lecture@chapnumberboxwd
\lecture@chapnumberboxwd=2.25em
\def\lecture@chapnumberbox#1{\makebox[\lecture@chapnumberboxwd][r]{#1}}
\RedeclareSectionCommands[tocpagenumberbox=\lecture@chapnumberbox]
  {section,subsection,subsubsection,paragraph,subparagraph}

\renewcommand*\sectionlinesformat[4]{\hskip #2{\paletteA{\smaller#3}}{#4}}

\setkomafont{disposition}{\sffamily\sbfamily}

\RedeclareSectionCommand[%
  runin=false,tocindent=1.85em,%
  beforeskip=1.5\baselineskip plus 0.33\baselineskip minus 0.33\baselineskip,%
  afterskip=\z@%
]{section}

\RedeclareSectionCommand[%
  runin=false,tocindent=4.15em,%
  beforeskip=1.5\baselineskip plus 0.33\baselineskip minus 0.33\baselineskip,%
  afterskip=\z@,%
]{subsection}

\RedeclareSectionCommand[%
  runin=on,tocindent=7.15em,%
  beforeskip=1.5\baselineskip,%
  afterskip=1ex%
]{subsubsection}

% \setkomafont{paragraph}{\mdseries\sffamily}
\RedeclareSectionCommand[%
  runin=on,%
  beforeskip=0.75\baselineskip plus 0.25\baselineskip minus 0.25\baselineskip,%
  afterskip=1ex, font=\mdseries\rmfamily\itshape%
]{paragraph}

%% Flexible Chapsums
%% -----------------------------------------------------------------------------

\newenvironment{wide}{\strip{}\ignorespaces}{\endstrip{}}

\def\@lecture@c@pre#1{\phantomsection\nobreak#1\nobreak}

\def\lecture@firstoftwo#1#2{#1}
\def\lecture@secondoftwo#1#2{#2}

\def\lecture@subsecmark#1{%
\begingroup%
\let\label\relax \let\index\relax \let\glossary\relax%
\expandafter\protected@xdef\csname lecture@subsec@\thesection @\endcsname{#1}%
\endgroup\if@nobreak\ifvmode\nobreak\fi\fi}
\robustify\lecture@subsecmark

\def\lecture@getsubsecmark{\csname lecture@subsec@\thesection @\endcsname}
\def\iflecture@subsecmark{\ifcsname lecture@subsec@\thesection @\endcsname\expandafter\lecture@firstoftwo\else\expandafter\lecture@secondoftwo\fi}

\let\lecture@section\section
\def\section{\@ifstar{\lecture@star@section}{\@dblarg\lecture@nostar@section}}
\def\lecture@star@section#1{\lecture@section*{#1}}
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
%% -----------------------------------------------------------------------------

\preto\listoffigures{\bgroup\lecture@disablehyper}
\preto\listoftables{\bgroup\lecture@disablehyper}
\appto\listoffigures{\egroup}
\appto\listoftables{\egroup}

\DeclareTOCStyleEntry[]{lecture@toc@section}{section}
\DeclareTOCStyleEntry[]{lecture@toc@section}{subsection}

%% Special ref
%% -----------------------------------------------------------------------------

% this is redefined by other classes and used as a simple interface
\def\lectureref#1#2{\hyperref[#1]{#2}}
\let\lautoref\autoref

%% Figures, Tables and refs
%% -----------------------------------------------------------------------------

\addto\captionsngerman{\def\figurename{Abbildung}\def\figureautorefname{\figurename}\def\tablename{Tabelle}\def\tableautorefname{\tablename}}
\addto\captionsenglish{\def\figurename{Figure}\def\figureautorefname{\figurename}\def\tablename{Table}\def\tableautorefname{\tablename}}

\renewcommand*{\captionformat}{~~}

\def\lecturelinkcolor{%
% we do not use paletteA if we are in a box. we use the box-color instead!
\ifcsname libx@boxid\endcsname\libx@get{BoxColor}\else paletteA\fi%
}
\def\lecturelinkfont{\sffamily}
\def\lecture@fig@style@nonbold#1{%
    {\hypersetup{allcolors=\lecturelinkcolor}\lecturelinkfont{#1}}%
}
\def\sbfamily{\fontseries{sb}\selectfont}
\def\lecture@fig@style#1{\lecture@fig@style@nonbold{{\sbfamily#1}}}

\DeclareCaptionLabelFormat{lecture-caption}{\lecture@fig@style{\paletteA{#1 #2:~~}}}
\captionsetup{format=plain,indention=1em,labelformat=lecture-caption,labelsep=none}

\AtBeginDocument{%
  \@ifpackageloaded{lecture-links}{%
    \SetAllLinkStyle{\lecture@fig@style@nonbold{#1}}%
  }{% dirty patches
    \let\lecture@autoref\autoref%
    \renewcommand*{\autoref}[1]{{\lecture@fig@style{\lecture@autoref{#1}}}}%
    \let\lecture@nameref\nameref%
    \renewcommand*{\nameref}[1]{{\lecture@fig@style{\lecture@nameref{#1}}}}%
  }\SetCiteColor{\lecturelinkcolor}%
}

%% Extra -- divider
%% -----------------------------------------------------------------------------

\def\lecturedivider{%%
  \par\centering\pgfornament[width=0.6\linewidth,color=paletteA]{89}\par}

\renewenvironment{abstract}{\ignorespaces}{\unskip\lecturedivider\smallskip\if@nobreak\ifvmode\nobreak\fi\fi}

\endinput