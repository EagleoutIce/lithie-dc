%% lecture-mobile documentclass
%% Florian Sihler, 10 Sep. 2020
%%
%% Based on koma-script
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lecture-mobile}[2020/09/10 The lecture-mobile documentclass]
\def\LayoutName{lecture-mobile}

% First we setup the document options
\LoadClass[titlepage,%
  numbers=noenddot,ngerman,%
  fontsize=13pt,oneside,titlepage=firstiscover,%
  footnotes=nomultiple,a5paper,%
  chapterprefix=false%
]{scrbook}
\KOMAoption{listof}{leveldown,chaptergapline,totocnumbered}

%% Options
%% -----
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LEMO,prefix=LEMO@}

\DeclareBoolOption{userip}
\DeclareComplementaryOption{norip}{userip}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}

\ProcessKeyvalOptions*

%% Basic packages
%% -----
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

\RequirePackage{lecture-registers,lecture-coverpage,lithie-birb}

\RequirePackage[english,main=ngerman]{babel}
\RequirePackage{tikz,etoolbox,calc,booktabs,pbox,scrhack,caption,stfloats,float}
\usetikzlibrary{decorations.text}

%% Fonts
%% -----
% needed to allow compat opts
\AtEndPreamble{%
\RequirePackage[cmintegrals,cmbraces,ebgaramond]{newtxmath}%
\RequirePackage{ebgaramond-maths}%
\RequirePackage[tabular,lining]{montserrat}%
}

\DeclareFixedFont{\lecture@font@eulerNormal}{U}{eur}{b}{n}{\f@size}
\DeclareFixedFont{\lecture@font@eulerSmall}{U}{eur}{b}{n}{9}

%% Microtype
%% -----
\RequirePackage[activate={true,nocompatibility},final,kerning=true,spacing=true,stretch=20,factor=1042,shrink=20,babel]{microtype}
\SetTracking{encoding={*}, shape=sc}{42}

% we do not want protusion in table of*
\preto\tableofcontents{\microtypesetup{protrusion=false}}
\appto\tableofcontents{\microtypesetup{protrusion=true}}

%% Line handling
%% -----
\RequirePackage[all]{nowidow}
\RequirePackage{cuted}

%% General Layout & Packages
%% -----
\RequirePackage{relsize,lastpage,datetime,fontawesome,afterpage,AnonymousPro,xstring,graphicx,environ}
\RequirePackage[draft=false]{scrlayer-scrpage}

\RequirePackage[a5paper,total={.92\paperwidth,.8\paperheight},head=52pt,foot=60pt,centering]{geometry}
%\overfullrule=1cm
\footheight=48pt
\flushbottom

%% Hyperlinks => Figures, Tables and refs
%% -----
\RequirePackage[%
    unicode=true,pdfencoding=auto,psdextra,pdftex, %
    backref, pagebackref=false, %
    bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle, %
    pdfborder={0 0 0}, breaklinks=true, %
    colorlinks, hyperindex, %
    bookmarkstype=X@l@X% erase
]{hyperref}

\RequirePackage{bookmark}

% just erases color
\def\nohyper#1{\begingroup\lecture@disablehyper#1\endgroup}
\AtEndPreamble{
\@ifpackageloaded{lecture-links}{%
    \def\lecture@disablehyper{\DisableLinkStyle\hypersetup{allcolors=.}}
}{
    \def\lecture@disablehyper{\hypersetup{allcolors=.}}
}%
\let\disablehyper\lecture@disablehyper
}

%% Lists
%% -----
\RequirePackage{lithie-dc@inlists}
\setlist[description]{labelwidth=*,font=\normalfont\itshape}

%% Color-Palettes
%% -----
\RequirePackage[enumitem,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\LEMO@cpalette}
\UseTikzPalette{\LEMO@tpalette}

%% Footnotes
%% -----

% footnote handling NOTE: we know there is a chapter!
\deffootnote{2em}{1em}{%
    \makebox[2em][r]{\nohyper{\hyperref[lecture@fn:\thesection:\csname lecture@footnoteref@\@mpfn\endcsname]{\thefootnotemark}}}~}


\renewcommand*\thefootnote{$\langle$\arabic{footnote}$\rangle$}
\renewcommand*\thempfootnote{$\langle$\alph{mpfootnote}$\rangle$}

\def\lecture@footnoteref@footnote{fn@\arabic{footnote}}
\def\lecture@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{lecture@fn:\thesection:\csname lecture@footnoteref@\@mpfn\endcsname}}

%% Nonrectangular paragraphs & hyphenation
%% -----

% TODO: option for recatngular
\parindent=\z@
\parskip=.5\baselineskip plus .25\baselineskip minus .2\baselineskip

\columnsep=1.55em
\def\arraystretch{1.15}
\linespread{1.125}
\hbadness=99999 \vbadness=99999

\hyphenpenalty=575
\lefthyphenmin=2 \righthyphenmin=3
% min 2 letters before and 3 after hyphen
\DeclareRobustCommand*\singleline[1]{#1\hfill\hbox{}}

%% Header and footer
%% -----
\renewcommand\chaptermark[1]{\markboth{\thechapter~#1}{}}
\renewcommand\sectionmark[1]{\markright{\thesection~#1}}

\colorlet{lecture@headfoot}{gray!90!black}
\setkomafont{pageheadfoot}{\sffamily\scriptsize\color{lecture@headfoot}\lecture@disablehyper}

\DeclareNewLayer[
  topmargin,background,contents={%
    \rule[\baselineskip]{\layerwidth}{.125em}%
  }%
]{lecture.digital.head.ruler}

\def\lecture@m@hfbox#1{\parbox[c][1.35cm]{\z@}{}\parbox[t]{.7\paperwidth}{#1}}
\def\lecture@m@hfboxfoot#1{\parbox[b][2.35\baselineskip]{\z@}{}\parbox{.65\paperwidth}{#1}}

\def\lecture@m@footdata{%
\cfoot{\centering\lecture@rs{title}\iflecture@ers{title}{}{\iflecture@er{author}{}{~$\circ$\space}}\LinkAuthor{\lecture@r{author}}}%
\ifoot{\lecture@abutton[.75pt]{GoBack}{\faUndo}}%
\ofoot{\lecture@abutton[.75pt]{GoForward}{\faRepeat}}%
}

\renewpairofpagestyles{scrheadings}{%
\ihead{\lecture@m@hfbox{\raggedright\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet\space}}\rightmark}}%
\ohead{\lecture@m@hfbox{\raggedleft\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\thinspace/\thinspace\pageref{LastPage}}}%
\lecture@m@footdata}

\AddLayersAtBeginOfPageStyle{scrheadings}{lecture.digital.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{lecture.digital.head.ruler}

\defpairofpagestyles[scrheadings]{lecture@chapter}{%
\ihead{\lecture@m@hfbox{ }}%
\ohead{\lecture@m@hfbox{\raggedleft\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\thinspace/\thinspace\pageref{LastPage}}}%
\lecture@m@footdata}

\AddLayersAtBeginOfPageStyle{lecture@chapter}{lecture.digital.head.ruler}

\defpairofpagestyles[scrheadings]{lecture@frontmatter}{%
\ihead{\lecture@m@hfbox{\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet\space}}\rightmark}}%
\ohead{\lecture@m@hfbox{\raggedleft\hyperref[toc]{\textbf{\thepage}}}}%
\lecture@m@footdata}

\defpairofpagestyles[scrheadings]{lecture@chapter@frontmatter}{%
\ihead{\lecture@m@hfbox{ }}%
\ohead{\lecture@m@hfbox{\raggedleft\hyperref[toc]{\textbf{\thepage}}}}%
\lecture@m@footdata}

\appto\frontmatter{\pagestyle{lecture@frontmatter}\renewcommand{\chapterpagestyle}{lecture@chapter@frontmatter}}
\appto\mainmatter{\pagestyle{scrheadings}\renewcommand{\chapterpagestyle}{lecture@chapter}}

\newcommand*\lecture@abutton[3][\z@]{\raisebox{#1}{\Acrobatmenu{#2}{#3}}}

%% Coverpage
%% -----
\selectcoverpage{fancy-small}%

%% Table of contents & sectioning
%% -----

\let\old@tableofcontents\tableofcontents
\preto\tableofcontents{%
\begingroup
\phantomsection\label{toc}\pdfbookmark[0]{\contentsname}{lecture@toc@@id@toc}%
}
\appto\tableofcontents{\endgroup}

\newlength\lecture@chapnumberboxwd \lecture@chapnumberboxwd=2.25em
\def\lecture@chapnumberbox#1{\makebox[\lecture@chapnumberboxwd][r]{#1}}
\RedeclareSectionCommands[tocpagenumberbox=\lecture@chapnumberbox]
  {part,chapter,section,subsection,subsubsection,paragraph,subparagraph}

\RedeclareSectionCommand[%
  tocnumwidth=1.25em,beforeskip=\z@,afterskip=\z@
]{chapter}

\def\sectionlinesformat#1#2#3#4{\hskip #2{#3}{#4}}
\RedeclareSectionCommand[%
  tocindent=1.15em, beforeskip=.885\baselineskip,%
  afterskip=.25\baselineskip
]{section}

\RedeclareSectionCommand[%
  runin=false,tocindent=4.15em, beforeskip=.33\baselineskip,%
  afterskip=\z@
]{subsection}

\RedeclareSectionCommand[%
  tocindent=7.15em, beforeskip=.33\baselineskip
]{subsubsection}

% \setkomafont{paragraph}{\mdseries\sffamily}
\RedeclareSectionCommand[%
  runin=false, beforeskip=.33\baselineskip,%
  afterskip=\z@,font=\mdseries\sffamily\smaller
]{paragraph}

\newenvironment{wide}{\ignorespaces}{}

\long\def\textsummary#1{\parbox{\linewidth}{\textsf{\itshape\small #1}\bigskip}}

% chapter summary
\long\def\csummary#1{%
\immediate\protected@write\@auxout{}{\protect\expandafter\protect\gdef\protect\csname lecture@chap@summaries@\thechapter\protect\endcsname{#1}}%
\textsummary{#1}}

\let\lecture@chapter\chapter
\def\chapter{\@ifstar{\lecture@star@chapter}{\@dblarg\lecture@nostar@chapter}}
\def\lecture@star@chapter#1{\lecture@chapter*{#1}\markboth{#1}{}}

\colorlet{lecture@tocsum}{lecture@headfoot}
\def\lecture@chapter@sumbox#1#2{\protect\@lecture@chapter@sumbox{#1}{#2}}
\def\@lecture@chapter@sumbox#1#2{\begin{minipage}[t]{\linewidth-#2}#1\end{minipage}}

\def\lecture@nostar@chapter[#1]#2{%
    \lecture@chapter[{\lecture@chapter@sumbox{#1\@lecture@style@tocsum{\thechapter}}{\@tocrmarg-\lecture@chapnumberboxwd}}]{%
    \phantomsection{\pdfbookmark[0]{\thechapter)\space#1}{lecture@chp@@id@\thechapter}}#2}\chaptermark{#1}%
    \immediate\protected@write\@auxout{}{\protect\expandafter\protect\gdef\protect\csname lecture@chap@name@\thechapter\protect\endcsname{#2}}}

\def\@lecture@ifsum#1#2{{\@ifundefined{#1}{}{#2}}}
\def\@lecture@style@tocsum#1{\@lecture@ifsum{lecture@chap@summaries@#1}{\color{lecture@tocsum}\leavevmode\\*%
    \lecture@chapter@sumbox{\mdseries\itshape\scriptsize\sffamily{\selectfont{\@nameuse{lecture@chap@summaries@#1}}}\bigskip}{2\fboxsep-1.25em}}}

\let\lecture@section\section
\def\section{\@ifstar{\lecture@star@section}{\@dblarg\lecture@nostar@section}}
\def\lecture@star@section#1{\lecture@section*{#1}\markright{#1}}
\def\lecture@nostar@section[#1]#2{\lecture@section[#1]{%
    {\phantomsection\pdfbookmark[1]{\thesection)\space#1}{lecture@sec@@id@\thesection}}#2}}

\let\lecture@subsection\subsection
\def\subsection{\@ifstar{\lecture@star@subsection}{\@dblarg\lecture@nostar@subsection}}
\def\lecture@star@subsection#1{\lecture@subsection*{#1}\markright{#1}}
\def\lecture@nostar@subsection[#1]#2{\lecture@subsection[#1]{%
    {\phantomsection\pdfbookmark[2]{\thesubsection)\space#1}{lecture@subsec@@id@\thesubsection}}#2}}

\deftocheading{toc}{\chapter*{\contentsname}}

\CloneTOCEntryStyle{tocline}{lecture@toc@section}
\TOCEntryStyleStartInitCode{lecture@toc@section}{%
    \expandafter\renewcommand
    \csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{##1}}%
}
\CloneTOCEntryStyle{tocline}{lecture@toc@chapter}
\TOCEntryStyleStartInitCode{lecture@toc@chapter}{%
    \expandafter\renewcommand
    \csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{\textbf{\textsf{##1}}}}%
}

\preto\listoffigures{\begingroup\lecture@disablehyper}
\preto\listoftables{\begingroup\lecture@disablehyper}
\appto\listoffigures{\endgroup}
\appto\listoftables{\endgroup}

\DeclareTOCStyleEntry[]{lecture@toc@chapter}{chapter}
\DeclareTOCStyleEntry[]{lecture@toc@section}{section}
\DeclareTOCStyleEntry[]{lecture@toc@section}{subsection}

\renewcommand*\chapterformat{%
    \color{paletteA}\thechapter\autodot~%
}


%% Special ref
%% -----
\def\lectureref#1#2{\hyperref[#1]{#2}}

%% Figures, Tables and refs
%% -----

\addto\captionsngerman{\renewcommand{\figurename}{Abbildung}\renewcommand{\figureautorefname}{\figurename}\renewcommand{\tablename}{Tabelle}\renewcommand{\tableautorefname}{\tablename}}
\addto\captionsenglish{\renewcommand{\figurename}{Figure}\renewcommand{\figureautorefname}{\figurename}\renewcommand{\tablename}{Table}\renewcommand{\tableautorefname}{\tablename}}

\renewcommand*\captionformat{~~}

\def\lecturelinkcolor{%
% we do not use paletteA if we are in a box. we use the box-color instead!
\ifcsname libx@boxid\endcsname\libx@get{BoxColor}\else paletteA\fi%
}
\def\lecturelinkfont{\smaller\sffamily}
\def\lecture@fig@style@nonbold#1{%
    {\hypersetup{allcolors=\lecturelinkcolor}\lecturelinkfont{#1}}%
}
\def\sbfamily{\fontseries{sb}\selectfont}
\def\lecture@fig@style#1{\lecture@fig@style@nonbold{{\fontseries{m}\selectfont#1}}}

\DeclareCaptionLabelFormat{lecture-caption}{\lecture@fig@style{\paletteA{#1 #2:~~}}}
\captionsetup{format=plain,indention=1em,labelformat=lecture-caption,labelsep=none,textfont=small}

\AtBeginDocument{%
\@ifpackageloaded{lecture-links}{%
\SetAllLinkStyle{\lecture@fig@style{#1}}%
\SetUrlLinkStyle{\lecture@fig@style@nonbold{#1}}%
\SetHrefLinkStyle{\lecture@fig@style@nonbold{#1}}%
\SetFootnoteLinkStyle{\lecture@fig@style@nonbold{#1}}%
}{% dirty patches
\let\lecture@autoref\autoref%
\renewcommand*{\autoref}[1]{{\lecture@fig@style{\lecture@autoref{#1}}}}%
\let\lecture@nameref\nameref%
\renewcommand*{\nameref}[1]{{\lecture@fig@style{\lecture@nameref{#1}}}}%
}\SetCiteColor{\lecturelinkcolor}}

%% Extra -- RIP
%% -----

\ifLEMO@userip
\RequirePackage{random-intropoem}

\def\lecture@rippage@geometry{\newgeometry{width=.85\paperwidth,top=.15\paperheight,bottom=.07\paperheight,centering}}

\newcommand\RipPage[1][]{%
\thispagestyle{empty}%
\lecture@rippage@geometry
\parbox{\linewidth}{\footnotesize#1}\null\vfill
\begingroup
\RipWidth{.9\textwidth}%
\SetRipStyle{%
\begingroup\null\hfill\footnotesize\RipParBox{%
    \raggedleft\riptext
    \smallskip\par
\itshape Aus: \ripname\\*%
\ripauthor,\quad\ripdate}\vspace*{2\baselineskip}\endgroup}%
\GetRandomRip\endgroup
\restoregeometry{}%
\clearpage
\thispagestyle{empty}%
% place the birb
\begin{tikzpicture}[overlay]
\begin{scope}[xshift=.55\paperwidth,yshift=-.5\paperwidth]
    \lithiebirb
\end{scope}
\node[gray,align=left] at(.175\paperwidth,-.733\paperwidth) {\textbf{\nohyper{\href{https://github.com/EagleoutIce/lithie-util/tree/gh-pages}{\Lithie}}}\\Ver. \lithie@version};
\end{tikzpicture}%
\clearpage}
\fi

%% Disable table float
%% -----

\newcounter{lecture@tablefakectr}

\def\afterpagebody#1{%
\afterpage{\begingroup\captionsetup{type=table}\par\normalfont\small\enlargethispage*{1\baselineskip}\vspace*{-\baselineskip}\@nameuse{lecture@tablebody@#1}\needspace{2\baselineskip}\bigskip\par\endgroup}%
}

\RenewEnviron{table*}[1][]{%
\stepcounter{lecture@tablefakectr}%
\expandafter\global\expandafter\let\csname lecture@tablebody@\thelecture@tablefakectr\endcsname\BODY{}%
\edef\lecture@tmp@counterval{\noexpand\afterpagebody{\thelecture@tablefakectr}}%
\lecture@tmp@counterval}

%% Extra -- Stoc
%% -----

\def\lecturetocname{Kurzübersicht}
\newcommand*\lecturetoc[2][2]{%
\begingroup\makeatletter
\setcounter{tocdepth}{#2}%
\def\contentsname{\lecturetocname}%
{%
\expandafter\def\csname @starttoc\endcsname##1{\InputIfFileExists{\jobname.##1}{}{}}%
\markboth{\lecturetocname}{}%
\old@tableofcontents
}%
\setcounter{tocdepth}{#1}%
\endgroup
}

%% try to modify bottom space
%% -----
\def\@textbottom{\vskip\z@\@plus .33\textheight}
\let\@texttop\relax
\endinput