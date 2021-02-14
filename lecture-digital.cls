%% lecture-digital documentclass
%% Florian Sihler, 10 Sep. 2020
%%
%% Based on koma-script
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lecture-digital}[2020/09/10 The lecture-digital documentclass]
\def\LayoutName{lecture-digital}

% First we setup the document options
\LoadClass[%
  numbers=noenddot,ngerman,%
  fontsize=11pt,oneside,%
  titlepage=firstiscover,%
  footnotes=nomultiple,a4paper,%
  twocolumn,chapterprefix=true,%
]{scrbook}

\KOMAoption{listof}{leveldown,chaptergapline,totocnumbered}

%% Options
%% -----------------------------------------------------------------------------
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LEDI,prefix=LEDI@}

\DeclareBoolOption{userip}
\DeclareComplementaryOption{norip}{userip}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}

\ProcessKeyvalOptions*\relax%

%% Basic packages
%% -----------------------------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lecture-registers,lecture-coverpage,lithie-birb}

\RequirePackage[english,main=ngerman]{babel}
\RequirePackage{tikz,etoolbox,calc,booktabs,pbox,scrhack,caption,stfloats,float}
\usetikzlibrary{decorations.text}

%% Fonts
%% -----------------------------------------------------------------------------
% needed to allow compat opts
\AtEndPreamble{%
\RequirePackage[cmintegrals,cmbraces,ebgaramond]{newtxmath}%
\RequirePackage{ebgaramond-maths}%
\RequirePackage[tabular,lining]{montserrat}%
}

%% Microtype
%% -----------------------------------------------------------------------------

\RequirePackage[activate={true,nocompatibility},final,kerning=true,spacing=true,stretch=50,factor=1000,shrink=10,selected=true,babel]{microtype}
\SetTracking{encoding={*}, shape=sc}{42}

% we do not want protusion in table of*
\preto\tableofcontents{\microtypesetup{protrusion=false}}
\appto\tableofcontents{\microtypesetup{protrusion=true}}

%% Line handling
%% -----------------------------------------------------------------------------
\RequirePackage[all]{nowidow}
\RequirePackage{cuted}

%% General Layout & Packages
%% -----------------------------------------------------------------------------
\RequirePackage{relsize,lastpage,datetime,fontawesome,afterpage,xstring,graphicx}
\RequirePackage[draft=false]{scrlayer-scrpage}

\RequirePackage[a4paper,total={0.85\paperwidth,0.7525\paperheight},centering,headheight=36pt]{geometry}
\flushbottom

%% Hyperlinks => Figures, Tables and refs
%% -----------------------------------------------------------------------------
\RequirePackage[%
    unicode=true,pdfencoding=auto,psdextra,pdftex, %
    backref, pagebackref=false, %
    bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle, %
    pdfborder={0 0 0}, breaklinks=true, %
    colorlinks, hyperindex, %
    bookmarkstype=X@lecture@X% erase
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

\setlist{leftmargin=1.25em,labelwidth=1.25em}
\newlist{inlist}{enumerate*}{1}
\setlist[inlist]{itemjoin={{, }},itemjoin*={{ und }},label=($\roman*$),mode=boxed}
\newlist{orlist}{enumerate*}{1}
\setlist[orlist]{itemjoin={{, }},itemjoin*={{, oder }},label=($\alph*$),mode=boxed}
\setlist[description]{labelwidth=*,font=\normalfont\itshape}

%% Color-Palettes
%% -----------------------------------------------------------------------------
\RequirePackage[enumitem,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\LEDI@cpalette}
\UseTikzPalette{\LEDI@tpalette}

%% Footnotes
%% -----------------------------------------------------------------------------

% footnote handling NOTE: we know there is a chapter!
\deffootnote{2em}{1em}{%
    \makebox[2em][r]{\nohyper{\hyperref[lecture@fn:\thesection:\@nameuse{lecture@footnoteref@\@mpfn}]{\thefootnotemark}}}~}

\renewcommand*{\thefootnote}{$\langle$\arabic{footnote}$\rangle$}
\renewcommand*{\thempfootnote}{$\langle$\alph{mpfootnote}$\rangle$}

\def\lecture@footnoteref@footnote{fn@\arabic{footnote}}
\def\lecture@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{lecture@fn:\thesection:\@nameuse{lecture@footnoteref@\@mpfn}}}

%% (non) Rectangular paragraphs & hyphenation
%% -----------------------------------------------------------------------------

% TODO: option for non-rectangle?
\parindent=\z@
\parskip=.5\baselineskip plus .2\baselineskip minus .1\baselineskip
\emergencystretch=0.5ex%
\columnsep=1.55em
\def\arraystretch{1.15}
\linespread{1.15}
\hbadness=99999
\vbadness=99999

\hyphenpenalty=475
\lefthyphenmin=2 \righthyphenmin=3
% min 2 letters before and 3 after hyphen
% TODO: minitoc: https://tex.stackexchange.com/questions/3001/list-sections-of-chapter-at-beginning-of-that-chapter#3002
\DeclareRobustCommand*{\singleline}[1]{#1\hfill\hbox{}}

%% Header and footer
%% -----------------------------------------------------------------------------

% TODO: draftmode
\renewcommand{\chaptermark}[1]{\markboth{\thechapter~#1}{}}
\renewcommand{\sectionmark}[1]{\markright{\thesection~#1}}

\DeclareNewLayer[%
topmargin,background,contents={%
  \rule[\baselineskip]{\layerwidth}{0.2em}%
}%
]{lecture.digital.head.ruler}

\renewpairofpagestyles{scrheadings}{%
\ihead{\parbox[t][3em]{0.85\linewidth}{\strut\raggedright\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet~}}\rightmark\strut}}%
\ohead{\parbox[t][3em]{0.1\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\thinspace/\thinspace\pageref{LastPage}}\leavevmode\\\strut}}%
\ofoot{\nohyper{\lecture@rs{title}\iflecture@ers{title}{}{\iflecture@er{author}{}{~$\circ$~}}\LinkAuthor{\lecture@r{author}}}}%
\ifoot{\nohyper{\lecture@abutton{PrevPage}{\faAngleLeft} \lecture@abutton[.75pt]{GoBack}{\tiny\faUndo} \lecture@abutton[.75pt]{GoForward}{\tiny\faRepeat} \lecture@abutton{NextPage}{\faAngleRight}}}%
}

\AddLayersAtBeginOfPageStyle{scrheadings}{lecture.digital.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{lecture.digital.head.ruler}

\colorlet{lecture@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{lecture@headfoot}}

\defpairofpagestyles[scrheadings]{lecture@chapter}{%
\ohead{\parbox[t][3em]{0.1\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\thinspace/\thinspace\pageref{LastPage}}\leavevmode\\\strut}}%
\ofoot{\nohyper{\lecture@rs{title}\iflecture@ers{title}{}{\iflecture@er{author}{}{~$\circ$~}}\LinkAuthor{\lecture@r{author}}}}%
\ifoot{\nohyper{\lecture@abutton{PrevPage}{\faAngleLeft} \lecture@abutton[.75pt]{GoBack}{\tiny\faUndo} \lecture@abutton[.75pt]{GoForward}{\tiny\faRepeat} \lecture@abutton{NextPage}{\faAngleRight}}}%
\ihead{\parbox[t][3em]{0.85\linewidth}{\strut\\\strut}}%
}

\AddLayersAtBeginOfPageStyle{lecture@chapter}{lecture.digital.head.ruler}

\defpairofpagestyles[scrheadings]{lecture@frontmatter}{%
\ihead{\parbox[t][3em]{0.85\linewidth}{\strut\raggedright\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet~}}\rightmark\strut}}%
\ofoot{\nohyper{\lecture@rs{title}\iflecture@ers{title}{}{\iflecture@er{author}{}{~$\circ$~}}\LinkAuthor{\lecture@r{author}}}}%
\ifoot{\nohyper{\lecture@abutton{PrevPage}{\faAngleLeft} \lecture@abutton[.75pt]{GoBack}{\tiny\faUndo} \lecture@abutton[.75pt]{GoForward}{\tiny\faRepeat} \lecture@abutton{NextPage}{\faAngleRight}}}%
\ohead{\parbox[t][3em]{0.1\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}}\leavevmode\\\strut}}%
}

\defpairofpagestyles[scrheadings]{lecture@chapter@frontmatter}{%
\ohead{\parbox[t][3em]{0.1\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\leavevmode\\\strut}}}%
\ofoot{\nohyper{\lecture@rs{title}\iflecture@ers{title}{}{\iflecture@er{author}{}{~$\circ$~}}\LinkAuthor{\lecture@r{author}}}}%
\ifoot{\nohyper{\lecture@abutton{PrevPage}{\faAngleLeft} \lecture@abutton[.75pt]{GoBack}{\tiny\faUndo} \lecture@abutton[.75pt]{GoForward}{\tiny\faRepeat} \lecture@abutton{NextPage}{\faAngleRight}}}%
\ihead{\parbox[t][3em]{0.85\linewidth}{\strut\\\strut}}%
}

\appto\frontmatter{\pagestyle{lecture@frontmatter}\renewcommand{\chapterpagestyle}{lecture@chapter@frontmatter}}
\appto\mainmatter{\pagestyle{scrheadings}\renewcommand{\chapterpagestyle}{lecture@chapter}}

\newcommand\lecture@abutton[3][\z@]{\raisebox{#1}{\Acrobatmenu{#2}{#3}}}

%% Coverpage
%% -----------------------------------------------------------------------------

\selectcoverpage{fancy}%


%% Table of contents & sectioning
%% -----------------------------------------------------------------------------

\let\old@tableofcontents\tableofcontents
\preto\tableofcontents{%
\bgroup%
\phantomsection\label{toc}\pdfbookmark[0]{\contentsname}{lecture@toc@@id@toc}%
}
\appto\tableofcontents{\egroup}

\deftocheading{toc}{\chapter*{\contentsname}}

\CloneTOCEntryStyle{tocline}{lecture@toc@section}
\TOCEntryStyleStartInitCode{lecture@toc@section}{%
    \expandafter\renewcommand%
    \csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{##1}}%
}

\newlength\lecture@chapnumberboxwd
\lecture@chapnumberboxwd=2.25em
\def\lecture@chapnumberbox#1{\makebox[\lecture@chapnumberboxwd][r]{#1}}
\RedeclareSectionCommands[tocpagenumberbox=\lecture@chapnumberbox]
  {part,chapter,section,subsection,subsubsection,paragraph,subparagraph}

\RedeclareSectionCommand[
  tocnumwidth=1.85em,%
  beforeskip=2\baselineskip,%
  afterskip=1.33\baselineskip%
]{chapter}

\renewcommand{\sectionlinesformat}[4]{\hskip #2{#3}{#4}}

\RedeclareSectionCommand[%
  runin=false,tocindent=1.85em,%
  beforeskip=1.25\baselineskip plus 0.33\baselineskip,%
  afterskip=\z@%
]{section}

\RedeclareSectionCommand[%
  runin=false,tocindent=4.15em,%
  beforeskip=1.25\baselineskip plus 0.33\baselineskip,%
  afterskip=\z@, runin=false%
]{subsection}

\RedeclareSectionCommand[%
  runin=false,tocindent=7.15em,%
  beforeskip=1.25\baselineskip,%
  afterskip=\z@%
]{subsubsection}

% \setkomafont{paragraph}{\mdseries\sffamily}
\RedeclareSectionCommand[%
  runin=false,%
  beforeskip=0.75\baselineskip,%
  afterskip=\z@, font=\mdseries\sffamily\smaller%
]{paragraph}

%% Flexible Chapsums
%% -----------------------------------------------------------------------------

\newenvironment{wide}{\strip{}\ignorespaces}{\endstrip{}}

\long\def\textsummary#1{%
\begin{wide}%
    \sffamily\itshape\small #1\bigskip\par%
\end{wide}}

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

\def\@lecture@c@pre#1{\phantomsection\nobreak#1\nobreak}

\def\lecture@nostar@chapter[#1]#2{%
  \lecture@chapter[{\lecture@chapter@sumbox{#1\@lecture@style@tocsum{\thechapter}}{\@tocrmarg-\lecture@chapnumberboxwd}}]{%
  \phantomsection{\pdfbookmark[0]{\thechapter)\space#1}{lecture@chp@@id@\thechapter}}#2}\chaptermark{#1}%
  \immediate\protected@write\@auxout{}{\protect\expandafter\protect\gdef\protect\csname lecture@chap@name@\thechapter\protect\endcsname{#2}}}

\def\@lecture@ifsum#1#2{{\@ifundefined{#1}{}{#2}}}
\def\@lecture@style@tocsum#1{\@lecture@ifsum{lecture@chap@summaries@#1}{\color{lecture@tocsum}\leavevmode\\%
    \lecture@chapter@sumbox{\mdseries\itshape\scriptsize{\selectfont{\@nameuse{lecture@chap@summaries@#1}}}\bigskip}{2\fboxsep-4em}}}

\let\lecture@section\section
\def\section{\@ifstar{\lecture@star@section}{\@dblarg\lecture@nostar@section}}
\def\lecture@star@section#1{\lecture@section*{#1}\markright{#1}}
\def\lecture@nostar@section[#1]#2{\lecture@section[#1]{%
  {\pdfbookmark[1]{\thesection)\space#1}{lecture@sec@@id@\thesection}}#2}}

\let\lecture@subsection\subsection
\def\subsection{\@ifstar{\lecture@star@subsection}{\@dblarg\lecture@nostar@subsection}}
\def\lecture@star@subsection#1{\lecture@subsection*{#1}}
\def\lecture@nostar@subsection[#1]#2{\lecture@subsection[#1]{%
  {\pdfbookmark[2]{\thesubsection)\space#1}{lecture@subsec@@id@\thesubsection}}#2}}

\newcounter{lecture@paragraph}[subsection]
\let\lecture@paragraph\paragraph
\def\paragraph{\@ifstar{\lecture@star@paragraph}{\@dblarg\lecture@nostar@paragraph}}
\def\lecture@star@paragraph#1{\lecture@paragraph*{#1}}
\def\lecture@nostar@paragraph[#1]#2{\stepcounter{lecture@paragraph}\@lecture@c@pre{\pdfbookmark[3]{\roman{lecture@paragraph})\space#1}{lecture@paragr@@id@\thesubsection @\thelecture@paragraph}}\lecture@paragraph[#1]{#2}}

%% Listpatches
%% -----------------------------------------------------------------------------

\preto\listoffigures{\bgroup\lecture@disablehyper}
\preto\listoftables{\bgroup\lecture@disablehyper}
\appto\listoffigures{\egroup}
\appto\listoftables{\egroup}

\DeclareTOCStyleEntry[]{lecture@toc@section}{section}
\DeclareTOCStyleEntry[]{lecture@toc@section}{subsection}

\newsavebox{\lecture@chapter@widthbox}
\renewcommand*{\chapterformat}{%
  \paletteA{\MakeUppercase{\chapappifchapterprefix{\nobreakspace}}\thechapter\autodot}%
  \IfUsePrefixLine{%
    \par\nobreak\vspace{-\parskip}\vspace{-.6\baselineskip}%
    \savebox{\lecture@chapter@widthbox}{\pbox{\linewidth}{\csname lecture@chap@name@\thechapter\endcsname\quad\null}}%
    \rule{\wd\lecture@chapter@widthbox}{.5pt}\vspace{-.3\baselineskip}%
  }{\enskip}%
}


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
}{% dirty patches
\let\lecture@autoref\autoref%
\renewcommand*{\autoref}[1]{{\lecture@fig@style{\lecture@autoref{#1}}}}%
\let\lecture@nameref\nameref%
\renewcommand*{\nameref}[1]{{\lecture@fig@style{\lecture@nameref{#1}}}}%
}\SetCiteColor{\lecturelinkcolor}%
}
%% Extra -- RIP
%% -----------------------------------------------------------------------------

\ifLEDI@userip
\RequirePackage{random-intropoem}

\def\lecture@rippage@geometry{\newgeometry{width=0.85\paperwidth,top=.15\paperheight,bottom=.07\paperheight,centering}}


\newcommand\RipPage[1][]{%
\thispagestyle{empty}%
\lecture@rippage@geometry%
\onecolumn%
% place the birb
\begin{tikzpicture}[overlay]
\begin{scope}[xshift=0.645\paperwidth,yshift=-0.55\paperwidth]
    \lithiebirb%
\end{scope}
\end{tikzpicture}%
\parbox{0.675\linewidth}{\footnotesize{#1}}\null\vfill%
\bgroup%
\RipWidth{0.7\textwidth}%
\SetRipStyle{%
\bgroup\null\hfill\large\RipParBox{%
    \raggedleft\riptext%
    \smallskip\par%
\itshape Aus: \ripname\\*%
\ripauthor,\quad\ripdate}\vspace*{2\baselineskip}\egroup}%
\GetRandomRip%
\egroup%
\restoregeometry{}%
\clearpage}
\fi

%% Extra -- Stoc
%% -----------------------------------------------------------------------------

\def\lecturetocname{Kurzübersicht}
\newcommand*\lecturetoc[2][2]{%
\bgroup\makeatletter%
\setcounter{tocdepth}{#2}%
\def\contentsname{\lecturetocname}%
{%
\expandafter\def\csname @starttoc\endcsname##1{\InputIfFileExists{\jobname.##1}{}{}}%
\markboth{\lecturetocname}{}%
\old@tableofcontents%
}%
\setcounter{tocdepth}{#1}%
\egroup%
}

\endinput