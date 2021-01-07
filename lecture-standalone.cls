%% lecture-standalone documentclass
%% Florian Sihler, 7 Oct. 2020
%%

\def\LayoutName{lecture-standalone}

%% Options
%% -----------------------------------------------------------------------------

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LESA,prefix=LESA@}

\DeclareBoolOption{graphic}
\DeclareComplementaryOption{nographic}{graphic}

\DeclareBoolOption{debug}
\DeclareComplementaryOption{nodebug}{debug}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[BoldInk]{tpalette}

\DeclareStringOption[GrayPrint]{printcpalette}
\DeclareStringOption[CleanPlate]{printtpalette}

\ProcessKeyvalOptions*\relax%

\ifLESA@debug%
    \errorcontextlines 999999%
\fi

%% Basic packages
%% -----------------------------------------------------------------------------

\LoadClass[ngerman,10pt]{scrartcl}

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lecture-registers,lithie-birb}

\RequirePackage[english,main=ngerman]{babel}
\RequirePackage{tikz,etoolbox,calc,booktabs,pbox,scrhack,caption,stfloats,float}
\usetikzlibrary{decorations.text}


%% Microtype
%% -----------------------------------------------------------------------------

\RequirePackage[activate={true,nocompatibility},final,kerning=true,spacing=true,stretch=20,factor=1042,shrink=20,babel]{microtype}
\SetTracking{encoding={*}, shape=sc}{42}

%% General Layout & Packages
%% -----------------------------------------------------------------------------

\RequirePackage{relsize,lastpage,datetime,fontawesome,afterpage,xstring,graphicx}
\RequirePackage[draft=false]{scrlayer-scrpage}

\RequirePackage[a4paper,total={0.85\paperwidth,0.75\paperheight},centering,headheight=36pt]{geometry}
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

\RequirePackage{bookmark,csquotes}

% just erases color
\def\nohyper#1{\bgroup\lecture@disablehyper#1\egroup}
\AtEndPreamble{%
\@ifpackageloaded{lecture-links}{%
\def\lecture@disablehyper{\DisableLinkStyle\hypersetup{allcolors=.}}}%
{\def\lecture@disablehyper{\hypersetup{allcolors=.}}}%
\let\disablehyper\lecture@disablehyper
}



\RequirePackage{enumitem,tikz,nameref}
\RequirePackage[enumitem,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\RequirePackage[sopra-listings={:defaults,cpalette,numinpar},sopra-tables={cpalette},sopra-models,lecture,lithie-boxes={germanenv,autostyle},lecture-links={patchurl}]{lithie-util}
\LoadBoxStyle{limerence}
\RequirePackage[imgprefix={Standalone},command={Standalone}]{lecture-personal}
\RequirePackage{morewrites}

%% Fonts
%% -----------------------------------------------------------------------------

\ifprofile{print}{%
\RequirePackage[charter,expert]{mathdesign}
\RequirePackage[scaled=.96,sups,osf]{XCharter}%
\RequirePackage[tabular,lining]{montserrat}%
}{%
% needed to allow compat opts
\AtEndPreamble{%
\RequirePackage[cmintegrals,cmbraces,ebgaramond]{newtxmath}%
\RequirePackage{ebgaramond-maths}%
\RequirePackage[tabular,lining]{montserrat}%
}}

%% Color concept
%% -----------------------------------------------------------------------------

\DefineTikzPalette{BoldInk}
{\paletteAname: paletteA,fill=paletteA}
{\paletteBname: paletteB,fill=paletteB}
{\paletteCname: paletteC,fill=paletteC}
{\paletteDname: paletteD,fill=paletteD}
{Schwarz: text=white}

\AppendToProfile{print}{%
    \UsePalette{\LESA@printcpalette}%
    \UseTikzPalette{\LESA@printtpalette}%
}

\AppendToProfile{default}{%
    \UsePalette{\LESA@cpalette}%
    \UseTikzPalette{\LESA@tpalette}%
}

\ifLESA@graphic%
    \RequirePackage[active,tightpage]{preview}%
    \PreviewEnvironment{tikzpicture}%
\fi

\endinput