%% lecture-mobile documentclass
%% Florian Sihler, 10 Sep. 2020
%%
%% Based on koma-script

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lecture-mobile}[2020/09/10 The lecture-mobile documentclass]

\def\LayoutName{lecture-mobile}

% First we setup the document options

\LoadClass[titlepage,%
           numbers=noenddot,%
           fontsize=13.45pt,DIV=calc,oneside,titlepage=firstiscover,%
           footnotes=nomultiple,a5paper,%
           chapterprefix=false,geometry%
]{scrbook}

\KOMAoption{listof}{leveldown,chaptergapline,totocnumbered}

%% Options
%% -----------------------------------------------------------------------------

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LEMO,prefix=LEMO@}

\DeclareBoolOption{userip}
\DeclareComplementaryOption{norip}{userip}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}

\ProcessKeyvalOptions*\relax%

% Now we handle the packages

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

\RequirePackage{lecture-registers,lecture-coverpage}

\RequirePackage[english,main=ngerman]{babel}
\RequirePackage{tikz,etoolbox,calc,booktabs,pbox,scrhack,caption,stfloats,float}
\usetikzlibrary{decorations.text}
\RequirePackage{ebgaramond-maths}
\RequirePackage[tabular,lining]{montserrat}

\RequirePackage[stretch=42,babel,final]{microtype}
\RequirePackage[all]{nowidow}
\PassOptionsToPackage{inline}{enumitem}
\RequirePackage{enumitem,relsize,lastpage,datetime,fontawesome,afterpage,AnonymousPro,xstring,graphicx,flushend,cuted,environ}
\RequirePackage[draft=false]{scrlayer-scrpage}

\RequirePackage[%
    unicode=true,pdfencoding=auto,psdextra,pdftex, %
    backref, pagebackref=false, %
    bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle, %
    pdfborder={0 0 0}, breaklinks=true, %
    colorlinks, hyperindex, %
    bookmarkstype=X@lecture@X% erase
]{hyperref}

\RequirePackage{bookmark}

\setlist{leftmargin=1.25em,labelwidth=1.25em}
\newlist{inlist}{enumerate*}{1}
\setlist[inlist]{itemjoin={{, }},itemjoin*={{ und }},label=($\roman*$),mode=boxed}
\setlist[description]{labelwidth=*,font=\normalfont\itshape}

\RequirePackage[enumitem,lithieboxes,hyperref,addons]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\LEMO@cpalette}
\UseTikzPalette{\LEMO@tpalette}

% footnote handling NOTE: we know there is a chapter!
\deffootnote{2em}{1em}{%
    \makebox[2em][r]{\nohyper{\hyperref[lecture@fn:\thesection:\@nameuse{lecture@footnoteref@\@mpfn}]{\thefootnotemark}}}~}

\RequirePackage[a5paper,total={0.92\paperwidth,0.76\paperheight},centering,headheight=36pt]{geometry}
%\overfullrule=1cm

\renewcommand*{\thefootnote}{$\langle$\arabic{footnote}$\rangle$}
\renewcommand*{\thempfootnote}{$\langle$\alph{mpfootnote}$\rangle$}

\def\lecture@footnoteref@footnote{fn@\arabic{footnote}}
\def\lecture@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{lecture@fn:\thesection:\@nameuse{lecture@footnoteref@\@mpfn}}}

\flushbottom

% TODO: option for non-recatngular
\setlength{\parindent}{0pt}
\setlength{\parskip}{.5\baselineskip plus .25\baselineskip minus .2\baselineskip}
% \setlength{\parfillskip}{0pt} % don't fill the last line
% \setlength{\emergencystretch}{.4\textwidth} % not to get preposterously bad lines

\setlength{\columnsep}{1.55em}
\renewcommand{\arraystretch}{1.15}
\linespread{1.175}
\hyphenpenalty=90
\hbadness=99999
\vbadness=99999

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

\DeclareNewLayer[
  topmargin,
  background,
  contents={%
    \rule[\baselineskip]{\layerwidth}{0.125em}%
  }%
]{lecture.digital.head.ruler}

\renewpairofpagestyles{scrheadings}{%
\ihead{\parbox[t][3em]{0.8\linewidth}{\strut\raggedright\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet~}}\rightmark\strut}}%
\ohead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\,/\,\pageref{LastPage}}\leavevmode\\\strut}}%
\ofoot{\nohyper{\lecture@rs{title}\iflecture@ers{title}{}{\iflecture@er{author}{}{~$\circ$~}}\LinkAuthor{\lecture@r{author}}}}%
\ifoot{\larger\nohyper{\lecture@abutton{PrevPage}{\faAngleLeft}~~\lecture@abutton[.75pt]{GoBack}{\footnotesize\faUndo}~~\lecture@abutton[.75pt]{GoForward}{\footnotesize\faRepeat}~~\lecture@abutton{NextPage}{\faAngleRight}}}%
}

\AddLayersAtBeginOfPageStyle{scrheadings}{lecture.digital.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{lecture.digital.head.ruler}

\colorlet{lecture@headfoot}{gray!90!black}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{lecture@headfoot}}

\defpairofpagestyles[scrheadings]{lecture@chapter}{%
\ohead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\,/\,\pageref{LastPage}}\leavevmode\\\strut}}%
\ofoot{\nohyper{\lecture@rs{title}\iflecture@ers{title}{}{\iflecture@er{author}{}{~$\circ$~}}\LinkAuthor{\lecture@r{author}}}}%
\ifoot{\larger\nohyper{\lecture@abutton{PrevPage}{\faAngleLeft}~~\lecture@abutton[.75pt]{GoBack}{\footnotesize\faUndo}~~\lecture@abutton[.75pt]{GoForward}{\footnotesize\faRepeat}~~\lecture@abutton{NextPage}{\faAngleRight}}}%
\ihead{\parbox[t][3em]{0.85\linewidth}{\strut\\\strut}}%
}

\AddLayersAtBeginOfPageStyle{lecture@chapter}{lecture.digital.head.ruler}

\defpairofpagestyles[scrheadings]{lecture@frontmatter}{%
\ihead{\parbox[t][3em]{0.85\linewidth}{\strut\raggedright\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet~}}\rightmark\strut}}%
\ofoot{\nohyper{\lecture@rs{title}\iflecture@ers{title}{}{\iflecture@er{author}{}{~$\circ$~}}\LinkAuthor{\lecture@r{author}}}}%
\ifoot{\larger\nohyper{\lecture@abutton{PrevPage}{\faAngleLeft}~~\lecture@abutton[.75pt]{GoBack}{\footnotesize\faUndo}~~\lecture@abutton[.75pt]{GoForward}{\footnotesize\faRepeat}~~\lecture@abutton{NextPage}{\faAngleRight}}}%
\ohead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}}\leavevmode\\\strut}}%
}

\defpairofpagestyles[scrheadings]{lecture@chapter@frontmatter}{%
\ohead{\parbox[t][3em]{0.15\linewidth}{\strut\raggedleft\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}\leavevmode\\\strut}}}%
\ofoot{\nohyper{\lecture@rs{title}\iflecture@ers{title}{}{\iflecture@er{author}{}{~$\circ$~}}\LinkAuthor{\lecture@r{author}}}}%
\ifoot{\larger\nohyper{\lecture@abutton{PrevPage}{\faAngleLeft}~~\lecture@abutton[.75pt]{GoBack}{\footnotesize\faUndo}~~\lecture@abutton[.75pt]{GoForward}{\footnotesize\faRepeat}~~\lecture@abutton{NextPage}{\faAngleRight}}}%
\ihead{\parbox[t][3em]{0.85\linewidth}{\strut\\\strut}}%
}


\appto\frontmatter{\pagestyle{lecture@frontmatter}\renewcommand{\chapterpagestyle}{lecture@chapter@frontmatter}}
\appto\mainmatter{\pagestyle{scrheadings}\renewcommand{\chapterpagestyle}{lecture@chapter}}
\appto\appendix{\linespread{1.06}}

\newcommand\lecture@abutton[3][0pt]{\raisebox{#1}{\Acrobatmenu{#2}{#3}}}

% TODO: draftmode

% coverpage:
\selectcoverpage{plain-small}%


\renewcommand{\chaptermark}[1]{\markboth{\thechapter~#1}{}}
\renewcommand{\sectionmark}[1]{\markright{\thesection~#1}}

\DeclareFixedFont{\lecture@font@eulerNormal}{U}{eur}{b}{n}{\f@size}
\DeclareFixedFont{\lecture@font@eulerSmall}{U}{eur}{b}{n}{9}

\preto\tableofcontents{%
\bgroup%
\phantomsection\label{toc}\pdfbookmark[0]{\contentsname}{lecture@toc@@id@toc}%
\linespread{1}%
}
\appto\tableofcontents{\egroup}

\RedeclareSectionCommand[
  tocnumwidth=1em,
  beforeskip=0pt,%
  afterskip=0pt%
]{chapter}

\renewcommand{\sectionlinesformat}[4]{%
\hskip #2{#3}{#4}%
}
\RedeclareSectionCommand[
  tocindent=1.85em,%
  beforeskip=0.66\baselineskip,%
  afterskip=0.66\baselineskip%
]{section}

\RedeclareSectionCommand[
  tocindent=4.15em
]{subsection}

\RedeclareSectionCommand[
  tocindent=7.15em
]{subsubsection}

% \setkomafont{paragraph}{\mdseries\sffamily}
\RedeclareSectionCommand[
  runin=false,%
  beforeskip=0.33\baselineskip,%
  afterskip=0pt,
  font=\mdseries\sffamily\smaller%
]{paragraph}

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
\def\lecture@chapter@sumbox#1{\protect\@lecture@chapter@sumbox{#1}}
\def\@lecture@chapter@sumbox#1{\begin{minipage}[t]{\linewidth-2\fboxsep-\@tocrmarg}#1\end{minipage}}
\def\lecture@nostar@chapter[#1]#2{%
    \lecture@chapter[{\lecture@chapter@sumbox{#1\@lecture@style@tocsum{\thechapter}}}]{%
    \phantomsection{\pdfbookmark[0]{\thechapter~#1}{lecture@chp@@id@\thechapter}}#2}\chaptermark{#1}%
    \immediate\protected@write\@auxout{}{\protect\expandafter\protect\gdef\protect\csname lecture@chap@name@\thechapter\protect\endcsname{#2}}}

\def\@lecture@ifsum#1#2{{\@ifundefined{#1}{}{#2}}}
\def\@lecture@style@tocsum#1{\@lecture@ifsum{lecture@chap@summaries@#1}{\color{lecture@tocsum}\leavevmode\\%
    \lecture@chapter@sumbox{\mdseries\itshape\scriptsize\sffamily{\selectfont{\@nameuse{lecture@chap@summaries@#1}}}\bigskip}}}

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

\deftocheading{toc}{%
   \chapter*{\contentsname}
}

\CloneTOCEntryStyle{tocline}{lecture@toc@section}
\TOCEntryStyleStartInitCode{lecture@toc@section}{%
    \expandafter\renewcommand%
    \csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{##1}}%
}
\CloneTOCEntryStyle{tocline}{lecture@toc@chapter}
\TOCEntryStyleStartInitCode{lecture@toc@chapter}{%
    \expandafter\renewcommand%
    \csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{\textbf{\textsf{##1}}}}%
}

\preto\listoffigures{\bgroup\lecture@disablehyper}
\preto\listoftables{\bgroup\lecture@disablehyper}
\appto\listoffigures{\egroup}
\appto\listoftables{\egroup}

\DeclareTOCStyleEntry[]{lecture@toc@chapter}{chapter}
\DeclareTOCStyleEntry[]{lecture@toc@section}{section}
\DeclareTOCStyleEntry[]{lecture@toc@section}{subsection}

\renewcommand*{\chapterformat}{%
    \color{paletteA}\thechapter\autodot~%
}


%% Special ref
%% -----------------------------------------------------------------------------

\def\lectureref#1#2{%
    \hyperref[#1]{#2}%
}

%% Figures, Tables and refs
%% -----------------------------------------------------------------------------

\addto\captionsngerman{\renewcommand{\figurename}{Abbildung}\renewcommand{\figureautorefname}{\figurename}\renewcommand{\tablename}{Tabelle}\renewcommand{\tableautorefname}{\tablename}}
\addto\captionsenglish{\renewcommand{\figurename}{Figure}\renewcommand{\figureautorefname}{\figurename}\renewcommand{\tablename}{Table}\renewcommand{\tableautorefname}{\tablename}}

\renewcommand*{\captionformat}{~~}

\def\lecture@fig@style@nonbold#1{% we do not use paletteA if we are in a box. we use the box-color instead!
    \begingroup\ifcsname libx@boxid\endcsname%
        \hypersetup{allcolors=\libx@get{BoxColor}}{\smaller\sffamily{#1}}%
    \else%
        \hypersetup{allcolors=paletteA}\smaller\sffamily{#1}%
    \fi%
    \endgroup%
}
\def\lecture@fig@style#1{\lecture@fig@style@nonbold{{\fontseries{m}\selectfont#1}}}

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
    }
}

%% Extra -- RIP
%% -----------------------------------------------------------------------------

\ifLEMO@userip
\RequirePackage{random-intropoem}

\def\lecture@rippage@geometry{\newgeometry{width=0.85\paperwidth,top=.15\paperheight,bottom=.07\paperheight,centering}}

\newcommand\RipPage[1][]{%
\thispagestyle{empty}%
\lecture@rippage@geometry%
#1\null\vfill%
\bgroup%
\RipWidth{0.9\textwidth}%
\SetRipStyle{%
\bgroup\null\hfill\footnotesize\RipParBox{%
    \raggedleft\riptext%
    \smallskip\par%
\itshape Aus: \ripname\\%
\ripauthor,\quad\ripdate}\vspace*{2\baselineskip}\egroup}%
\GetRandomRip\egroup%
\restoregeometry{}%
\clearpage}
\fi

%% Disable table float
%% -----------------------------------------------------------------------------

\newcounter{lecture@tablefakectr}

\def\afterpagebody#1{%
\afterpage{\bgroup\captionsetup{type=table}\par\normalfont\normalsize\@nameuse{lecture@tablebody@#1}\bigskip\par\egroup}%
}

\RenewEnviron{table*}[1][]{%
    \stepcounter{lecture@tablefakectr}%
    \expandafter\global\expandafter\let\csname lecture@tablebody@\thelecture@tablefakectr\endcsname\BODY%
    \edef\lecture@tmp@counterval{\noexpand\afterpagebody{\thelecture@tablefakectr}}%
    \lecture@tmp@counterval%
}%

\endinput