%% lecture-summary documentclass
%% Florian Sihler, 10 Sep. 2020
%% Based on koma-script
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lecture-summary}[2020/09/10 The lecture-summary documentclass]
\def\LayoutName{lecture-summary}
% First we setup the document options
\LoadClass[%
  numbers=noenddot,ngerman,fontsize=10pt,oneside,%
  footnotes=nomultiple,a4paper,twocolumn%
]{scrartcl}

%% Options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LESU,prefix=LESU@}
\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}

\DeclareBoolOption{index}\DeclareComplementaryOption{noindex}{index}
\DeclareBoolOption{parskip}\DeclareComplementaryOption{noparskip}{parskip}
\DeclareBoolOption[true]{shortfloat}\DeclareComplementaryOption{longfloat}{shortfloat}
\DeclareBoolOption{sflinks}\DeclareComplementaryOption{nosflinks}{sflinks}
\DeclareBoolOption[true]{mathskip}\DeclareComplementaryOption{nomathskip}{mathskip}
\ProcessKeyvalOptions*

%% Basic packages
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[english,main=ngerman]{babel}
\RequirePackage{lecture-registers,lecture-coverpage,lithie-birb,pgfornament,tikz,etoolbox,calc,booktabs,pbox,scrhack,caption,stfloats,float,needspace,wrapfig,lithie-profiles}
\usetikzlibrary{decorations.text}

%% Fonts
\AtEndPreamble{%
\RequirePackage[sc,osf]{mathpazo}
\RequirePackage[euler-digits,small]{eulervm}
\RequirePackage[tabular,lining]{montserrat}}
\AtBeginDocument{\def\hbar{\hslash}}

%% Microtype
\RequirePackage[activate={true,nocompatibility},final,kerning=true,spacing=true,stretch=50,factor=\@m,shrink=10,selected=true,babel]{microtype}

%% General Packages
\RequirePackage{cuted,relsize,afterpage,xstring,graphicx,datetime,scrlayer-scrpage}
\RequirePackage[all]{nowidow}

\ifLESU@index\else\RequirePackage{lastpage}\fi
\newlength\lecture@len@margin \lecture@len@margin=2cm
\RequirePackage[a4paper,margin=\lecture@len@margin,includefoot,marginpar=1.15cm,vcentering]{geometry}

%% Hyperlinks => Figures, Tables and refs
\ifLESU@index\RequirePackage{lecture-index}\fi % enforce loading before hyperref
\RequirePackage[%
    unicode,pdfencoding=auto,psdextra,pdftex,%
    backref, pagebackref=false,bookmarks,bookmarksopen=false,pdfdisplaydoctitle,%
    pdfborder={0 0 0},breaklinks,colorlinks,hyperindex,bookmarkstype=X@l@X% erase
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
\setlist{leftmargin=1.25em,labelwidth=1.25em,nosep}
\setlist[description]{leftmargin=*,labelwidth=*,font=\normalfont\itshape}
\def\lsumenumi#1{#1{\tiny\raisebox{.275ex}{$\blacksquare$}}}
\setlist[itemize,1]{label={\lsumenumi\relax}}%
\setlist[itemize,2]{label={\relsize{-1}\raisebox{.5ex}{$\blacktriangleright$}}}%
\setlist[itemize,3]{label={\textbullet}}%
\setlist[itemize,4]{label={\textendash}}%

%% suppress indent after environments
% https://tex.stackexchange.com/questions/514127/incompatibility-between-noindentafter-and-etoolbox-v2-5f/515465#515465
\newcommand*\@NoIndentAfter{%
\@ifnextchar\par{\def\par{%
  \everypar{\setbox\z@\lastbox\everypar{}}%
  \@restorepar}}{}%
}
\newrobustcmd*\NoIndentAfterThis{\@NoIndentAfter\par\par}

\ifLESU@parskip\else
\@for\env:={enumerate,itemize,description,wrapfigure,wraptable,align,align*}\do{%
\AfterEndEnvironment\env{\NoIndentAfterThis}}
\fi

%% Color-Palettes
\RequirePackage[rect,lithieboxes,hyperref,nodefaults]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette\LESU@cpalette \UseTikzPalette\LESU@tpalette

%% Footnotes
\deffootnote{2em}{1em}{%
    \makebox[2em][r]{\color{black}\nohyper{\hyperref[lecture@fn:\thesection:\@nameuse{lecture@footnoteref@\@mpfn}]{\thefootnotemark}}}~}

\renewcommand*\thefootnote{$\langle$\arabic{footnote}$\rangle$}
\renewcommand*\thempfootnote{$\langle$\alph{mpfootnote}$\rangle$}

\def\lecture@footnoteref@footnote{fn@\arabic{footnote}}
\def\lecture@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{lecture@fn:\thesection:\@nameuse{lecture@footnoteref@\@mpfn}}\disablehyper}

%% (non) Rectangular paragraphs & hyphenation
\newlength\segskipamount
\segskipamount=.5\baselineskip \@plus .15\baselineskip \@minus .15\baselineskip
\def\segskip{\vspace\segskipamount}

\ifLESU@parskip
\parindent\z@ \parskip\segskipamount
\else
\parindent=1em \parskip\z@
\fi

\abovecaptionskip=3\p@ \@plus \p@ \@minus 2\p@
\belowcaptionskip=3\p@ \@plus \p@ \@minus 2\p@
\floatsep=2\p@ \@plus \p@ \@minus 2\p@
\textfloatsep=16\p@ \@plus 5\p@ \@minus 2\p@

\ifLESU@parskip \else
\let\@afterindenttrue\@afterindentfalse
\@afterindentfalse\fi

\columnsep1.5em
\def\arraystretch{1.215} \linespread{1.2}
\hbadness99999 \vbadness99999
\hyphenpenalty475 \lefthyphenmin\tw@ \righthyphenmin\tw@

%% Header and footer
\renewcommand*\sectionmark[1]{\markboth{#1}{}}

\DeclareNewLayer[%
topmargin,background,contents={%
  \rule[\baselineskip]{\layerwidth}{.2em}%
}]{lecture.fancy.paper.head.ruler}

\def\lecture@copyright@notice@upper{\lecture@r{title}, \lecture@r{subtitle}}
\def\lecture@copyright@notice@lower{\lecture@rs{brief}}
\ifprofile{print}{\def\lecture@summary@headi{}
\def\lecture@summary@foot@{%
\ofoot{\strut\nohyper{{\sbfamily\thepage}\thinspace/\thinspace\pageref{LastPage}}}%
\ifoot{\strut\nohyper{\lecture@rs{title}~\faAngleRight~\leftmark\iflecture@e{\leftmark}{}{\iflecture@subsecmark{~\faAngleRight}{}~}\lecture@getsubsecmark}\strut}}
}{%
\def\lecture@summary@headi{%
  \begingroup\normalsize\normalfont\linespread{1.25}\begin{tikzpicture}[remember picture,overlay]
    \node[below left,yshift=-.25cm,xshift=-\lecture@len@margin,font=\usekomafont{pageheadfoot}\scriptsize,inner sep=\z@,outer sep=\z@,align=right] at(current page.north east) {\disablehyper\lecture@copyright@notice@upper\\\disablehyper\lecture@copyright@notice@lower};
  \end{tikzpicture}\endgroup}
  \def\lecture@summary@foot@{%
  \ofoot{\strut\nohyper{{\sbfamily\thepage}\thinspace/\thinspace\pageref{LastPage}}}%
  \ifoot{\strut\nohyper{\leftmark\iflecture@e{\leftmark}{}{\iflecture@subsecmark{~\faAngleRight}{}~}\lecture@getsubsecmark}\strut}}
}
\renewpairofpagestyles{scrheadings}{\ihead{\lecture@summary@headi}\lecture@summary@foot@}
\newpairofpagestyles{initial@scrheadings}{\lecture@summary@foot@}
\newpairofpagestyles{headonly@scrheadings}{\ihead{\lecture@summary@headi}}

\ifprofile{print}{}{%
\@for\layr:={scrheadings,initial@scrheadings,headonly@scrheadings,plain.scrheadings}\do{%
\AddLayersAtBeginOfPageStyle{\layr}{lecture.fancy.paper.head.ruler}}}

\colorlet{lecture@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{lecture@headfoot}}
\AtBeginDocument{\thispagestyle{initial@scrheadings}\pagestyle{scrheadings}}

%% Coverpage
\selectcoverpage{compact-upper}

%% Table of contents & sectioning
\unsettoc{toc}{onecolumn}\setuptoc{toc}{noprotrusion}
\let\old@tableofcontents\tableofcontents
\preto\tableofcontents{%
\begingroup\phantomsection\label{toc}\pdfbookmark[0]{\contentsname}{lecture@toc@@id@toc}%
}
\appto\tableofcontents{\endgroup}
\deftocheading{toc}{}

\CloneTOCEntryStyle{tocline}{lecture@toc@section}
\TOCEntryStyleStartInitCode{lecture@toc@section}{%
    \expandafter\renewcommand\csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{##1}}%
}

\newlength\lecture@chapnumberboxwd
\lecture@chapnumberboxwd=2.25em
\def\lecture@chapnumberbox#1{\makebox[\lecture@chapnumberboxwd][r]{#1}}
\RedeclareSectionCommands[tocpagenumberbox=\lecture@chapnumberbox]
  {section,subsection,subsubsection,paragraph,subparagraph}

\renewcommand*\sectionlinesformat[4]{\hskip#2\@hangfrom{\color{paletteA}\smaller#3}{#4}}
\setkomafont{disposition}{\sffamily\sbfamily}

\RedeclareSectionCommand[runin=false,tocindent=1.85em,%
beforeskip=.5\baselineskip \@plus .33\baselineskip \@minus .33\baselineskip,%
afterskip=\z@]{section}
\RedeclareSectionCommand[runin=false,tocindent=4.15em,%
beforeskip=.5\baselineskip \@plus .33\baselineskip \@minus .33\baselineskip,%
afterskip=\z@]{subsection}
\RedeclareSectionCommand[runin=on,tocindent=7.15em,%
beforeskip=.5\baselineskip \@minus .33\baselineskip,%
afterskip=1ex,font=\bfseries\sffamily\smaller]{subsubsection}
\RedeclareSectionCommand[runin=on,beforeskip=.5\baselineskip \@minus .25\baselineskip,%
afterskip=\z@, font=\mdseries\rmfamily\itshape]{paragraph}

%% Flexible Chapsums
\newenvironment{wide}{\strip{}\ignorespaces}{\endstrip{}}
\def\@lecture@c@pre#1{\phantomsection\nobreak#1\nobreak}

\def\lecture@firstoftwo#1#2{#1}\def\lecture@secondoftwo#1#2{#2}

\DeclareRobustCommand*\lecture@subsecmark[1]{\begingroup
\let\label\relax \let\index\relax \let\glossary\relax
\expandafter\protected@xdef\csname lecture@subsec@\thesection @\endcsname{#1}%
\endgroup\if@nobreak\ifvmode\nobreak\fi\fi}

\def\lecture@getsubsecmark{\csname lecture@subsec@\thesection @\endcsname}
\def\iflecture@subsecmark{\ifcsname lecture@subsec@\thesection @\endcsname\expandafter\lecture@firstoftwo\else\expandafter\lecture@secondoftwo\fi}

\let\lecture@section\section
\def\section{\needspace{2.25\baselineskip}\@ifstar{\lecture@star@section}{\@dblarg\lecture@nostar@section}}
\def\lecture@star@section#1{\lecture@section*{#1}}
\def\lecture@nostar@section[#1]#2{\lecture@section[#1]{%
  {\pdfbookmark[1]{\thesection)\space#1}{lecture@sec@@id@\thesection}}#2}}

\let\lecture@subsection\subsection
\def\subsection{\needspace{2.25\baselineskip}\@ifstar{\lecture@star@subsection}{\@dblarg\lecture@nostar@subsection}}
\def\lecture@star@subsection#1{\lecture@subsection*{#1}\lecture@subsecmark{#1}}
\def\lecture@nostar@subsection[#1]#2{\lecture@subsection[#1]{%
  {\pdfbookmark[2]{\thesubsection)\space#1}{lecture@subsec@@id@\thesubsection}\lecture@subsecmark{#1}}#2}}

\let\lecture@subsubsection\subsubsection
\def\subsubsection{\@ifstar{\lecture@star@subsubsection}{\@dblarg\lecture@nostar@subsubsection}}
\def\lecture@star@subsubsection#1{\lecture@subsubsection*{#1}}
\def\lecture@nostar@subsubsection[#1]#2{\lecture@subsubsection[#1]{%
  {\pdfbookmark[3]{\thesubsubsection)\space#1}{lecture@subsubsec@@id@\thesubsubsection}}#2}}

\newcounter{lecture@paragraph}[subsubsection]
\let\lecture@paragraph\paragraph
\def\paragraph{\@ifstar{\lecture@star@paragraph}{\@dblarg\lecture@nostar@paragraph}}
\def\lecture@star@paragraph#1{\lecture@paragraph*{#1}}
\def\lecture@nostar@paragraph[#1]#2{\stepcounter{lecture@paragraph}\@lecture@c@pre{\pdfbookmark[4]{\roman{lecture@paragraph})\space#1}{lecture@paragr@@id@\thesubsubsection @\thelecture@paragraph}}\lecture@paragraph[{#1}]{#2~\thinspace\paletteA{\textbullet}\thinspace~}}

%% Listpatches
\preto\listoffigures{\begingroup\lecture@disablehyper}\appto\listoffigures{\endgroup}
\preto\listoftables{\begingroup\lecture@disablehyper}\appto\listoftables{\endgroup}
\DeclareTOCStyleEntry{lecture@toc@section}{section}
\DeclareTOCStyleEntry{lecture@toc@section}{subsection}

%% Special ref
% this is redefined by other classes and used as a simple interface
\def\lectureref#1#2{\hyperref[#1]{#2}}
\let\lautoref\autoref
\def\appref#1{\lectureref{#1}{\faBook}}
\def\exaref#1{\lectureref{#1}{\faFlask}}

%% Figures, Tables and refs
\ifLESU@shortfloat
\appto\captionsngerman{\def\figurename{Abb}\def\tablename{Tbl}}
\appto\captionsenglish{\def\figurename{Fig}\def\tablename{Tbl}}
\else
\appto\captionsngerman{\def\figurename{Abbildung}\def\tablename{Tabelle}}
\appto\captionsenglish{\def\figurename{Figure}\def\tablename{Table}}
\fi
\def\figureautorefname{\figurename}\def\tableautorefname{\tablename}
\renewcommand*\captionformat{~~}

\def\lecturelinkcolor{%
% we do not use paletteA if we are in a box. we use the box-color instead!
\ifcsname libx@boxid\endcsname\libx@get{BoxColor}\else paletteA\fi}
\ifLESU@sflinks
\def\lecturelinkfont{\sffamily\relsize{-.5}}
\else\let\lecturelinkfont\relax\fi
\def\lecture@fig@style@nonbold#1{%
    {\hypersetup{allcolors=\lecturelinkcolor}\lecturelinkfont{#1}}%
}
\def\sbfamily{\fontseries{sb}\selectfont}
\def\lecture@fig@style#1{\lecture@fig@style@nonbold{{\sbfamily#1}}}

\ifLESU@shortfloat
\DeclareCaptionLabelFormat{lecture-caption}{\lecture@fig@style{\paletteA{#1.~#2:\thinspace~}}}
\else
\DeclareCaptionLabelFormat{lecture-caption}{\lecture@fig@style{\paletteA{#1~#2:~}}}
\fi
\captionsetup{format=plain,indention=1ex,font=small,labelformat=lecture-caption,labelsep=none}

\AtBeginDocument{%
\@ifpackageloaded{lecture-links}{%
  \SetAllLinkStyle{\lecture@fig@style@nonbold{#1}}%
  \SetCiteColor{\lecturelinkcolor}%
}{% dirty patches
  \let\lecture@autoref\autoref
  \renewcommand*\autoref[1]{{\lecture@fig@style{\lecture@autoref{#1}}}}%
  \let\lecture@nameref\nameref
  \renewcommand*\nameref[1]{{\lecture@fig@style{\lecture@nameref{#1}}}}%
}}

%% Extra -- divider
\def\lecturedivider{{\par\centering\pgfornament[width=.6\linewidth,color=paletteA]{89}\par}}

\renewenvironment{abstract}{\noindent\ignorespaces}{\unskip\lecturedivider\smallskip\if@nobreak\ifvmode\nobreak\fi\fi}
\preto\appendix{\needspace{4\baselineskip}\lecturedivider}

%% Extra -- Mathskip
\def\lecturenomathskip{\abovedisplayskip\z@ \belowdisplayskip\z@
\abovedisplayshortskip\z@ \belowdisplayshortskip\z@}
\ifLESU@mathskip\else\AtBeginDocument{\lecturenomathskip}\fi

\def\disablepagefooter{\label{LastPage}\clearpage\pagestyle{headonly@scrheadings}}
% insert auto if not set
\AtEndDocument{\ifcsname k@LastPage\endcsname\else\label{LastPage}\fi}
\endinput