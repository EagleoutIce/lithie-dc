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
\SetupKeyvalOptions{family=LESU,prefix=LESU@}

\DeclareBoolOption{userip}
\DeclareComplementaryOption{norip}{userip}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}

\DeclareBoolOption{index}
\DeclareComplementaryOption{noindex}{index}

\ProcessKeyvalOptions*

%% Basic packages
%% -----------------------------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lecture-registers,lecture-coverpage,lithie-birb,pgfornament}

\RequirePackage[english,main=ngerman]{babel}
\RequirePackage{tikz,etoolbox,calc,booktabs,pbox,scrhack,caption,stfloats,float,translations,needspace}
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
\RequirePackage{relsize,datetime,fontawesome5,afterpage,xstring,graphicx}
\RequirePackage[draft=false]{scrlayer-scrpage}

\ifLESU@index\else\RequirePackage{lastpage}\fi

\newlength\lecture@len@margin \lecture@len@margin=2cm
\RequirePackage[a4paper,margin=\lecture@len@margin,includefoot,marginpar=1.15cm,vcentering]{geometry}
\flushbottom

%% Hyperlinks => Figures, Tables and refs
%% -----------------------------------------------------------------------------
\ifLESU@index\RequirePackage{lecture-index}\fi % enforce loading before hyperref

\RequirePackage[%
    unicode=true,pdfencoding=auto,psdextra,pdftex, %
    backref, pagebackref=false, %
    bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle, %
    pdfborder={0 0 0}, breaklinks=true, %
    colorlinks, hyperindex, bookmarkstype=X@l@X% erase
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
%% -----------------------------------------------------------------------------
\PassOptionsToPackage{inline}{enumitem}
\RequirePackage{enumitem}

\DeclareTranslationFallback{t-and}{, and}
\DeclareTranslation{English}{t-and}{, and}
\DeclareTranslation{German}{t-and}{und}

\DeclareTranslationFallback{t-or}{, or}
\DeclareTranslation{English}{t-or}{, or}
\DeclareTranslation{German}{t-or}{oder}

\setlist{leftmargin=1.25em,labelwidth=1.25em,nosep}
\newlist{inlist}{enumerate*}{1}
\setlist[inlist]{itemjoin={{, }},itemjoin*={{, \GetTranslation{t-and}\space}},label=($\roman*$),mode=boxed}
\newlist{orlist}{enumerate*}{1}
\setlist[orlist]{itemjoin={{, }},itemjoin*={{, \GetTranslation{t-or}\space}},label=($\alph*$),mode=boxed}
\setlist[description]{leftmargin=*,labelwidth=*,font=\normalfont\itshape}

\setlist[itemize,1]{label={\smaller[5]\raisebox{.275ex}{$\blacksquare$}}}%
\setlist[itemize,2]{label={\smaller[1]\raisebox{.5ex}{$\blacktriangleright$}}}%
\setlist[itemize,3]{label={\textbullet}}%
\setlist[itemize,4]{label={\textendash}}%

%% suppress indent after environments
% https://tex.stackexchange.com/questions/514127/incompatibility-between-noindentafter-and-etoolbox-v2-5f/515465#515465
\newcommand*\@NoIndentAfter{%
    \@ifnextchar\par{%
        \def\par{%
            \everypar{\setbox\z@\lastbox\everypar{}}%
            \@restorepar%
        }%
    }{}%
}
\newrobustcmd*{\NoIndentAfterThis}{\@NoIndentAfter\par\par}

\AfterEndEnvironment{enumerate}{\NoIndentAfterThis}
\AfterEndEnvironment{itemize}{\NoIndentAfterThis}
\AfterEndEnvironment{description}{\NoIndentAfterThis}
\AfterEndEnvironment{wrapfigure}{\NoIndentAfterThis}



%% Color-Palettes
%% -----------------------------------------------------------------------------
\RequirePackage[rect,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\LESU@cpalette}
\UseTikzPalette{\LESU@tpalette}

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

\parindent=1em
\parskip=\z@

\abovecaptionskip=3pt plus 1pt minus 2pt
\belowcaptionskip=3pt plus 1pt minus 2pt
\floatsep=2pt plus 1pt minus 2pt
\textfloatsep=16pt plus 5pt minus 2pt

\let\@afterindenttrue\@afterindentfalse
\@afterindentfalse

\columnsep=1.5em
\renewcommand*{\arraystretch}{1.215}
\linespread{1.2}
\hbadness=99999 \vbadness=99999

\hyphenpenalty=475
\lefthyphenmin=2 \righthyphenmin=2
% min 3 letters before and 2 after hyphen

%% Header and footer
%% -----------------------------------------------------------------------------

\renewcommand*{\sectionmark}[1]{\markboth{#1}{}}

\DeclareNewLayer[%
topmargin,background,contents={%
  \rule[\baselineskip]{\layerwidth}{.2em}%
}%
]{lecture.fancy.paper.head.ruler}

\def\lecture@copyright@notice@upper{\lecture@r{title}, \lecture@r{subtitle}}
\def\lecture@copyright@notice@lower{\lecture@rs{brief}}
\renewpairofpagestyles{scrheadings}{%
\ihead{\begin{tikzpicture}[remember picture,overlay]
  \node[below left,yshift=-.25cm,xshift=-\lecture@len@margin,font=\usekomafont{pageheadfoot}\scriptsize,inner sep=\z@,outer sep=\z@,align=right] at(current page.north east) {\disablehyper\lecture@copyright@notice@upper\\\disablehyper\lecture@copyright@notice@lower};
\end{tikzpicture}}
\ofoot{\strut\nohyper{{\sbfamily\thepage}\thinspace/\thinspace\pageref{LastPage}}}%
\ifoot{\strut\nohyper{\leftmark\iflecture@e{\leftmark}{}{\iflecture@subsecmark{~\faAngleRight}{}~}\lecture@getsubsecmark}\strut}%
}

\newpairofpagestyles{initial@scrheadings}{%
\ofoot{\strut\nohyper{{\sbfamily\thepage}\thinspace/\thinspace\pageref{LastPage}}}%
\ifoot{\strut\nohyper{\leftmark\iflecture@e{\leftmark}{}{\iflecture@subsecmark{~\faAngleRight}{}~}\lecture@getsubsecmark}\strut}%
}

\newpairofpagestyles{headonly@scrheadings}{%
\ihead{\begin{tikzpicture}[remember picture,overlay]
  \node[below left,yshift=-.25cm,xshift=-\lecture@len@margin,font=\usekomafont{pageheadfoot}\scriptsize,inner sep=\z@,outer sep=\z@,align=right] at(current page.north east) {\disablehyper\lecture@copyright@notice@upper\\\disablehyper\lecture@copyright@notice@lower};
\end{tikzpicture}}%
}

\AddLayersAtBeginOfPageStyle{scrheadings}{lecture.fancy.paper.head.ruler}
\AddLayersAtBeginOfPageStyle{initial@scrheadings}{lecture.fancy.paper.head.ruler}
\AddLayersAtBeginOfPageStyle{headonly@scrheadings}{lecture.fancy.paper.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{lecture.fancy.paper.head.ruler}

\colorlet{lecture@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{lecture@headfoot}}

\AtBeginDocument{\thispagestyle{initial@scrheadings}\pagestyle{scrheadings}}

%% Coverpage
%% -----------------------------------------------------------------------------
\selectcoverpage{compact-upper}


%% Table of contents & sectioning
%% -----------------------------------------------------------------------------

\unsettoc{toc}{onecolumn}
\setuptoc{toc}{noprotrusion}
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

\RedeclareSectionCommand[%
  runin=false,tocindent=1.85em,%
  beforeskip=.5\baselineskip plus .33\baselineskip minus .33\baselineskip,%
  afterskip=\z@
]{section}

\RedeclareSectionCommand[%
  runin=false,tocindent=4.15em,%
  beforeskip=.5\baselineskip plus .33\baselineskip minus .33\baselineskip,%
  afterskip=\z@
]{subsection}

\RedeclareSectionCommand[%
  runin=on,tocindent=7.15em,%
  beforeskip=.5\baselineskip minus .33\baselineskip,%
  afterskip=1ex%
]{subsubsection}

\RedeclareSectionCommand[%
  runin=on,%
  beforeskip=.5\baselineskip minus .25\baselineskip,%
  afterskip=\z@, font=\mdseries\rmfamily\itshape
]{paragraph}

%% Flexible Chapsums
%% -----------------------------------------------------------------------------

\newenvironment{wide}{\strip{}\ignorespaces}{\endstrip{}}

\def\@lecture@c@pre#1{\phantomsection\nobreak#1\nobreak}

\def\lecture@firstoftwo#1#2{#1}
\def\lecture@secondoftwo#1#2{#2}

\DeclareRobustCommand*\lecture@subsecmark[1]{%
\begingroup
\let\label\relax \let\index\relax \let\glossary\relax%
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

\newcounter{lecture@paragraph}[subsection]
\let\lecture@paragraph\paragraph
\def\paragraph{\@ifstar{\lecture@star@paragraph}{\@dblarg\lecture@nostar@paragraph}}
\def\lecture@star@paragraph#1{\lecture@paragraph*{#1}}
\def\lecture@nostar@paragraph[#1]#2{\stepcounter{lecture@paragraph}\@lecture@c@pre{\pdfbookmark[3]{\roman{lecture@paragraph})\space#1}{lecture@paragr@@id@\thesubsection @\thelecture@paragraph}}\lecture@paragraph[{#1}]{#2~\thinspace\paletteA{\textbullet}\thinspace~}}

%% Listpatches
%% -----------------------------------------------------------------------------

\preto\listoffigures{\begingroup\lecture@disablehyper}
\preto\listoftables{\begingroup\lecture@disablehyper}
\appto\listoffigures{\endgroup}
\appto\listoftables{\endgroup}

\DeclareTOCStyleEntry[]{lecture@toc@section}{section}
\DeclareTOCStyleEntry[]{lecture@toc@section}{subsection}

%% Special ref
%% -----------------------------------------------------------------------------

% this is redefined by other classes and used as a simple interface
\def\lectureref#1#2{\hyperref[#1]{#2}}
\let\lautoref\autoref

\def\appref#1{\lectureref{#1}{\faBook}}

%% Figures, Tables and refs
%% -----------------------------------------------------------------------------

\addto\captionsngerman{\def\figurename{Abbildung}\def\figureautorefname{\figurename}\def\tablename{Tabelle}\def\tableautorefname{\tablename}}
\addto\captionsenglish{\def\figurename{Figure}\def\figureautorefname{\figurename}\def\tablename{Table}\def\tableautorefname{\tablename}}

\renewcommand*{\captionformat}{~~}

\def\lecturelinkcolor{%
% we do not use paletteA if we are in a box. we use the box-color instead!
\ifcsname libx@boxid\endcsname\libx@get{BoxColor}\else paletteA\fi
}
\let\lecturelinkfont\relax
\def\lecture@fig@style@nonbold#1{%
    {\hypersetup{allcolors=\lecturelinkcolor}\lecturelinkfont{#1}}%
}
\def\sbfamily{\fontseries{sb}\selectfont}
\def\lecture@fig@style#1{\lecture@fig@style@nonbold{{\sbfamily#1}}}

\DeclareCaptionLabelFormat{lecture-caption}{\lecture@fig@style{\paletteA{#1~#2:~}}}
\captionsetup{format=plain,indention=1ex,font=small,labelformat=lecture-caption,labelsep=none}

\AtBeginDocument{%
  \@ifpackageloaded{lecture-links}{%
    \SetAllLinkStyle{\lecture@fig@style@nonbold{#1}}%
    \SetCiteColor{\lecturelinkcolor}%
  }{% dirty patches
    \let\lecture@autoref\autoref%
    \renewcommand*{\autoref}[1]{{\lecture@fig@style{\lecture@autoref{#1}}}}%
    \let\lecture@nameref\nameref%
    \renewcommand*{\nameref}[1]{{\lecture@fig@style{\lecture@nameref{#1}}}}%
  }%
}

%% Extra -- divider
%% -----------------------------------------------------------------------------

\def\lecturedivider{%
  {\par\centering\pgfornament[width=.6\linewidth,color=paletteA]{89}\par}}

\renewenvironment{abstract}{\noindent\ignorespaces}{\unskip\lecturedivider\smallskip\if@nobreak\ifvmode\nobreak\fi\fi}
\preto\appendix{\needspace{4\baselineskip}\lecturedivider}

%% Extra -- Mathskip
%% -----------------------------------------------------------------------------

\def\lecturenomathskip{\abovedisplayskip=\z@ \belowdisplayskip=\z@
\abovedisplayshortskip=\z@ \belowdisplayshortskip=\z@}

\def\disablepagefooter{\label{LastPage}\clearpage\pagestyle{headonly@scrheadings}}
% insert auto if not set
\AtEndDocument{\ifcsname k@LastPage\endcsname\else\label{LastPage}\fi}
\endinput