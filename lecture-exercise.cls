%% lecture-exercise documentclass
%% Florian Sihler, 10 Sep. 2020
%% Based on koma-script
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lecture-exercise}[2020/09/10 The lecture-exercise documentclass]
\def\LayoutName{lecture-exercise}
% First we setup the document options
\LoadClass[numbers=noenddot,fontsize=11pt,oneside,%
  footnotes=nomultiple,a4paper,onecolumn%
]{scrartcl}
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LEEX,prefix=LEEX@}
\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}
\ProcessKeyvalOptions*

% Now we handle the packages
\RequirePackage{ifluatex}
\ifluatex
\usepackage{fontspec}
\defaultfontfeatures{Ligatures=TeX}
\else
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\fi

\RequirePackage{lecture-registers,lecture-coverpage}

\RequirePackage{tikz,etoolbox,calc,booktabs,pbox,scrhack,caption,stfloats,float}
\usetikzlibrary{decorations.text}
\ifluatex
\RequirePackage{polyglossia}
\setdefaultlanguage{german}
\setotherlanguage{english}
\AtEndPreamble{
\RequirePackage[sc,osf]{mathpazo}
\RequirePackage[euler-digits,small]{eulervm}
\AtBeginDocument{\def\hbar{\hslash}}
% \RequirePackage[tabular,lining]{montserrat}
\RequirePackage[fira]{fontsetup}
}
\else
\RequirePackage[english,main=ngerman]{babel}
\AtEndPreamble{
\RequirePackage[sc,osf]{mathpazo}
\RequirePackage[euler-digits,small]{eulervm}
\AtBeginDocument{\def\hbar{\hslash}}
\RequirePackage[tabular,lining]{montserrat}
}
\fi
% needed to allow compat options

\ifluatex\else\PassOptionsToPackage{spacing=true,kerning=true}{microtype}\fi
\RequirePackage[activate={true,nocompatibility},final,tracking=true,stretch=30,shrink=10,babel]{microtype}
\RequirePackage[all]{nowidow}
\PassOptionsToPackage{inline}{enumitem}
\RequirePackage{enumitem,relsize,lastpage,datetime,afterpage,AnonymousPro,xstring,graphicx,cuted}
\RequirePackage[draft=false]{scrlayer-scrpage}

\RequirePackage[%
  unicode=true,pdfencoding=auto,psdextra,pdftex, %
  backref, pagebackref=false, %
  bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle, %
  pdfborder={0 0 0}, breaklinks=true, %
  colorlinks, hyperindex, %
  bookmarkstype=X@l@X% erase
]{hyperref}

\RequirePackage{bookmark,lithie-dc@inlists}
\setlist{leftmargin=1.25em,labelwidth=1.25em}
\setlist[description]{labelwidth=*,font=\normalfont\itshape}
\DeclareRobustCommand\negline{\leavevmode\\*[-2\baselineskip]}

\RequirePackage[enumitem,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\LEEX@cpalette}
\UseTikzPalette{\LEEX@tpalette}

% footnote handling NOTE: we know there is a section!
\deffootnote{2em}{1em}{%
    \makebox[2em][r]{\nohyper{\hyperref[lecture@fn:\thesection:\csname lecture@footnoteref@\@mpfn\endcsname]{\thefootnotemark}}}~}

\RequirePackage[a4paper,total={.85\paperwidth,.75\paperheight},centering,headheight=36pt]{geometry}
\def\thefootnote{$\langle$\arabic{footnote}$\rangle$}
\def\thempfootnote{$\langle$\alph{mpfootnote}$\rangle$}
\def\lecture@footnoteref@footnote{fn@\arabic{footnote}}
\def\lecture@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{lecture@fn:\thesection:\csname lecture@footnoteref@\@mpfn\endcsname}}
\flushbottom

\parindent=\z@
\parskip=.5\baselineskip \@plus .25\baselineskip \@minus .2\baselineskip
\def\arraystretch{1.15}
\linespread{1.15}
\hyphenpenalty90
\hbadness\@MM \vbadness\@MM

% just erases color
\def\nohyper#1{\begingroup\lecture@disablehyper#1\endgroup}
\AtEndPreamble{
\@ifpackageloaded{lecture-links}{%
    \def\lecture@disablehyper{\DisableLinkStyle\hypersetup{allcolors=.}}
}{
    \def\lecture@disablehyper{\hypersetup{allcolors=.}}
}%
\let\disablehyper\lecture@disablehyper}

\DeclareNewLayer[
  topmargin,background,
  contents={\rule[\baselineskip]{\layerwidth}{.2em}}%
]{lecture.digital.head.ruler}

\renewpairofpagestyles{scrheadings}{%
\ihead{\parbox[t][3em]{.85\linewidth}{\strut\raggedright\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet~}}\rightmark\strut}}%
\ohead{\parbox[t][3em]{.1\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\thinspace/\thinspace\pageref{LastPage}}\leavevmode\\\strut}}%
\ofoot{\nohyper{\lecture@rs{title}}}%
\ifoot{\nohyper{\lecture@abutton{PrevPage}{\faAngleLeft} \lecture@abutton[.75pt]{GoBack}{\tiny\faUndo} \lecture@abutton[.75pt]{GoForward}{\tiny\faRepeat} \lecture@abutton{NextPage}{\faAngleRight}}}%
}

\AddLayersAtBeginOfPageStyle{scrheadings}{lecture.digital.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{lecture.digital.head.ruler}

\colorlet{lecture@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{lecture@headfoot}}

\pagestyle{scrheadings}
\newcommand\lecture@abutton[3][\z@]{\raisebox{#1}{\Acrobatmenu{#2}{#3}}}
\selectcoverpage{simple}%

\long\def\sectionmark#1{\markboth{\thesection~#1}{}}
\long\def\subsectionmark#1{\markboth{\thesubsection~#1}{}}

\let\old@tableofcontents\tableofcontents
\preto\tableofcontents{%
\begingroup
\phantomsection\label{toc}\pdfbookmark[0]{\contentsname}{lecture@toc@@id@toc}%
}
\appto\tableofcontents{\endgroup}
% assure the toc label
\AtEndDocument{\ifcsname k@toc\endcsname\else\label{toc}\fi}

\renewcommand\sectionlinesformat[4]{%
\hskip #2{#3}{#4}%
}
\RedeclareSectionCommand[tocindent=1.85em,%
  beforeskip=.66\baselineskip,afterskip=.66\baselineskip
]{section}

\RedeclareSectionCommand[tocindent=4.15em]{subsection}
\RedeclareSectionCommand[tocindent=7.15em]{subsubsection}
\RedeclareSectionCommand[
  runin=false,beforeskip=.33\baselineskip,afterskip=\z@,
  font=\mdseries\sffamily\smaller
]{paragraph}

\let\lecture@section\section
\def\section{\@ifstar{\lecture@star@section}{\@dblarg\lecture@nostar@section}}
\def\lecture@star@section#1{\lecture@section*{#1}\markright{#1}}
\def\lecture@nostar@section[#1]#2{\lecture@section[#1]{%
        {\phantomsection\pdfbookmark[1]{\arabic{section}~#1}{lecture@sec@@id@\thesection}}#2}}

\let\lecture@subsection\subsection
\def\subsection{\@ifstar{\lecture@star@subsection}{\@dblarg\lecture@nostar@subsection}}
\def\lecture@star@subsection#1{\lecture@subsection*{#1}\markright{#1}}
\def\lecture@nostar@subsection[#1]#2{\lecture@subsection[#1]{%
        {\phantomsection\pdfbookmark[2]{\arabic{subsection}~#1}{lecture@subsec@@id@\thesubsection}}#2}}

\deftocheading{toc}{\section*{\contentsname}}
\CloneTOCEntryStyle{tocline}{lecture@toc@section}
\TOCEntryStyleStartInitCode{lecture@toc@section}{%
    \expandafter\renewcommand%
    \csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{##1}}%
}

\preto\listoffigures{\begingroup\lecture@disablehyper}
\preto\listoftables{\begingroup\lecture@disablehyper}
\appto\listoffigures{\endgroup}
\appto\listoftables{\endgroup}

\DeclareTOCStyleEntry{lecture@toc@section}{section}
\DeclareTOCStyleEntry{lecture@toc@section}{subsection}

%% Special ref
\def\lectureref#1#2{\hyperref[#1]{#2}}
\let\lautoref\autoref

%% Figures, Tables and refs
\addto\captionsngerman{\renewcommand{\figurename}{Abbildung}\renewcommand{\figureautorefname}{\figurename}\renewcommand{\tablename}{Tabelle}\renewcommand{\tableautorefname}{\tablename}}
\addto\captionsenglish{\renewcommand{\figurename}{Figure}\renewcommand{\figureautorefname}{\figurename}\renewcommand{\tablename}{Table}\renewcommand{\tableautorefname}{\tablename}}

\renewcommand*{\captionformat}{~~}

\def\lecturelinkcolor{%
% we do not use paletteA if we are in a box. we use the box-color instead!
\ifcsname libx@boxid\endcsname\libx@get{BoxColor}\else paletteA\fi%
}
\def\lecturelinkfont{\smaller\sffamily}
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
    \let\lecture@autoref\autoref
    \renewcommand*\autoref[1]{{\lecture@fig@style{\lecture@autoref{#1}}}}%
    \let\lecture@nameref\nameref
    \renewcommand*\nameref[1]{{\lecture@fig@style{\lecture@nameref{#1}}}}%
}}
\endinput