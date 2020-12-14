%% lecture-print documentclass
%% Florian Sihler, 15 Okt. 2020
%%
%% Based on koma-script

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lecture-print}[2020/10/15 The lecture-print documentclass]

\def\LayoutName{lecture-print}
% TODO: keep twocolumn
% First we setup the document options

\LoadClass[%
    numbers=noenddot,%
    fontsize=11pt,ngerman,%
    titlepage=firstiscover,%
    footnotes=nomultiple,%
    twocolumn,chapterprefix=true,%
    a4paper%
]{scrbook}
\KOMAoption{listof}{leveldown,chaptergapline,totocnumbered,left}

%% Options
%% -----------------------------------------------------------------------------

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LEPR,prefix=LEPR@}

\DeclareBoolOption{userip}
\DeclareComplementaryOption{norip}{userip}

\DeclareStringOption[GrayPrint]{cpalette}
\DeclareStringOption[CleanPlate]{tpalette}

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

\RequirePackage[activate={true,nocompatibility},final,kerning=true,spacing=true,stretch=20,factor=1042,shrink=20,babel]{microtype}
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

\RequirePackage[a4paper,margin=1.75cm,headheight=40pt,top=80pt,bindingoffset=10mm,nofoot,centering]{geometry}
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
\AtEndPreamble{
\@ifpackageloaded{lecture-links}{%
    \def\lecture@disablehyper{\DisableLinkStyle\hypersetup{allcolors=.}}
}{
    \def\lecture@disablehyper{\hypersetup{allcolors=.}}
}%
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
\setlist[orlist]{itemjoin={{, }},itemjoin*={{ oder }},label=($\alph*$),mode=boxed}
\setlist[description]{labelwidth=*,font=\normalfont\itshape}


%% Color-Palettes
%% -----------------------------------------------------------------------------

\RequirePackage[enumitem,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\LEPR@cpalette}
\UseTikzPalette{\LEPR@tpalette}


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



%% Rectangular paragraphs & hyphenation
%% -----------------------------------------------------------------------------

% TODO: option for recatngular
\parindent=\z@
\parskip=.5\baselineskip plus .25\baselineskip minus .2\baselineskip
% \setlength{\parfillskip}{0pt} % don't fill the last line
% \setlength{\emergencystretch}{.4\textwidth} % not to get preposterously bad lines

\columnsep=1.5em
\renewcommand*{\arraystretch}{1.16}
\linespread{1.15}
\hbadness=99999
\vbadness=99999

\hyphenpenalty=475
\lefthyphenmin=2 \righthyphenmin=3
% min 2 letters before and 3 after hyphen

\DeclareRobustCommand*{\singleline}[1]{#1\hfill\hbox{}}

%% Header and footer
%% -----------------------------------------------------------------------------

\renewcommand{\chaptermark}[1]{\markboth{\thechapter~#1}{}}
\renewcommand{\sectionmark}[1]{\markright{\thesection~#1}}

% TODO: draftmode
\renewpairofpagestyles{scrheadings}{%
\rehead{\parbox[t][3em]{0.85\linewidth}{\strut\raggedleft\leftmark}}%
\lohead{\parbox[t][3em]{0.85\linewidth}{\strut\raggedright\rightmark}}%
\lehead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedright\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\thinspace/\thinspace\pageref{LastPage}}\leavevmode\\\strut}}%
\rohead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\thinspace/\thinspace\pageref{LastPage}}\leavevmode\\\strut}}%
}

\colorlet{lecture@headfoot}{gray!90!black}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{lecture@headfoot}}

\defpairofpagestyles[scrheadings]{lecture@chapter}{%
\lehead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedright\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\thinspace/\thinspace\pageref{LastPage}}\leavevmode\\\strut}}\rohead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\thinspace/\thinspace\pageref{LastPage}}\leavevmode\\\strut}}%
\ihead{\parbox[t][3em]{0.85\linewidth}{\strut\\\strut}}%
}

\defpairofpagestyles[scrheadings]{lecture@frontmatter}{%
\rehead{\parbox[t][3em]{0.85\linewidth}{\strut\raggedleft\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet~}}\rightmark\strut}}%
\lohead{\parbox[t][3em]{0.85\linewidth}{\strut\raggedright\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet~}}\rightmark\strut}}%
\rohead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}}\leavevmode\\\strut}}%
\lehead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedright\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}}\leavevmode\\\strut}}%
}

\defpairofpagestyles[scrheadings]{lecture@chapter@frontmatter}{%
\ohead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\leavevmode\\\strut}}}%
\ihead{\parbox[t][3em]{0.85\linewidth}{\strut\\\strut}}%
}


\appto\frontmatter{\pagestyle{lecture@frontmatter}\renewcommand{\chapterpagestyle}{lecture@chapter@frontmatter}}
\appto\mainmatter{\pagestyle{scrheadings}\renewcommand{\chapterpagestyle}{lecture@chapter}}

\newcommand\lecture@abutton[3][0pt]{\raisebox{#1}{\Acrobatmenu{#2}{#3}}}


%% Coverpage
%% -----------------------------------------------------------------------------

\selectcoverpage{plain}%


%% Table of contents & sectioning
%% -----------------------------------------------------------------------------

\let\old@tableofcontents\tableofcontents
\preto\tableofcontents{%
\bgroup%
\phantomsection\label{toc}\pdfbookmark[0]{\contentsname}{lecture@toc@@id@toc}%
}
\appto\tableofcontents{\egroup}

\deftocheading{toc}{%
   \chapter*{\contentsname}
}

\CloneTOCEntryStyle{tocline}{lecture@toc@section}
\TOCEntryStyleStartInitCode{lecture@toc@section}{%
    \expandafter\renewcommand%
    \csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{##1}}%
}

\newlength\lecture@chapnumberboxwd
\setlength{\lecture@chapnumberboxwd}{2.25em}
\def\lecture@chapnumberbox#1{\makebox[\lecture@chapnumberboxwd][r]{#1}}
\RedeclareSectionCommands[tocpagenumberbox=\lecture@chapnumberbox]
  {part,chapter,section,subsection,subsubsection,paragraph,subparagraph}

\RedeclareSectionCommand[
  tocnumwidth=1.85em,
  beforeskip=2\baselineskip,%
  afterskip=1.33\baselineskip%
]{chapter}

\renewcommand{\sectionlinesformat}[4]{%
\hskip #2{#3}{#4}%
}
\RedeclareSectionCommand[%
  runin=false,tocindent=1.85em,%
  beforeskip=1.25\baselineskip plus 0.33\baselineskip,%
  afterskip=\z@%
]{section}

\RedeclareSectionCommand[%
  runin=false,tocindent=4.15em,%
  beforeskip=1.25\baselineskip plus 0.33\baselineskip,%
  afterskip=\z@,%
  runin=false%
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
  afterskip=\z@,
  font=\mdseries\sffamily\smaller%
]{paragraph}


%% Flexible Chapsums
%% -----------------------------------------------------------------------------

\newenvironment{wide}{\strip{}\ignorespaces}{\endstrip{}}

\long\def\textsummary#1{%
\bgroup%
    \sffamily\itshape\small #1\bigskip\par%
\egroup}

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
\def\@lecture@style@tocsum#1{\@lecture@ifsum{lecture@chap@summaries@#1}{\color{lecture@tocsum}\leavevmode\\%
    \lecture@chapter@sumbox{\mdseries\itshape\scriptsize{\selectfont{\@nameuse{lecture@chap@summaries@#1}}}\bigskip}{2\fboxsep-4em}}}

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

\def\lecture@pagesuffix#1{\iflecstar\else\nolinebreak\thinspace\nolinebreak\textsuperscript{$\rightarrow\mskip\thinmuskip\pageref*{#1}$}\fi}

\def\lectureref#1#2{%
    \hyperref[#1]{#2}\lecture@pagesuffix{#1}%
}

%% Figures, Tables and refs
%% -----------------------------------------------------------------------------

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
        % \SetHyperrefLinkStyle{\lecture@fig@style{#1}}
        % \SetHyperlinkLinkStyle{\lecture@fig@style{#1}}
        \SetUrlLinkStyle{\lecture@fig@style@nonbold{#1}}%
        \SetHrefLinkStyle{\lecture@fig@style@nonbold{#1}}%
        \SetFootnoteLinkStyle{\lecture@fig@style@nonbold{#1}}%
    }{% dirty patches
        \let\lecture@autoref\autoref%
        \renewcommand*{\autoref}[1]{{\lecture@fig@style{\lecture@autoref{#1}}}}%
        \let\lecture@nameref\nameref%
        \renewcommand*{\nameref}[1]{{\lecture@fig@style{\lecture@nameref{#1}}}}%
    }
}
%% Extra -- RIP
%% -----------------------------------------------------------------------------

\ifLEPR@userip
\RequirePackage{random-intropoem}


\def\lecture@rippage@geometry{}%

\newcommand\RipPage[1][]{%
\thispagestyle{empty}%
\lecture@rippage@geometry%
\onecolumn%
% place the birb
\begin{tikzpicture}[overlay]
\begin{scope}[xshift=0.645\paperwidth,yshift=-0.55\paperwidth]
    \lithiebirb%
    % inject below 0.0 as there is the peak
    \node[below right, gray,scale=0.65] at(0,0) {Ver. \lithie@version};
\end{scope}
\end{tikzpicture}%
\parbox{0.6\linewidth}{\small{#1}}\null\vfill%
\bgroup%
\RipWidth{0.77\textwidth}%
\SetRipStyle{%
\bgroup\null\hfill\large\RipParBox{%
    \raggedleft\riptext%
    \smallskip\par%
\itshape Aus: \ripname\\%
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