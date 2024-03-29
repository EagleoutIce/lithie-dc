%% lecture-standalone documentclass
%% Florian Sihler, 7 Oct. 2020
\def\LayoutName{lecture-standalone}
%% Options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=LESA,prefix=LESA@}
\DeclareBoolOption{graphic}
\DeclareComplementaryOption{nographic}{graphic}
\DeclareBoolOption[true]{code}
\DeclareComplementaryOption{nocode}{code}
\DeclareBoolOption[true]{fonts}
\DeclareComplementaryOption{nofonts}{fonts}
\DeclareBoolOption{debug}
\DeclareComplementaryOption{nodebug}{debug}
\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[BoldInk]{tpalette}
\DeclareStringOption[GrayPrint]{printcpalette}
\DeclareStringOption[CleanPlate]{printtpalette}
\ProcessKeyvalOptions*
\ifLESA@debug\errorcontextlines\@M\fi
%% Basic packages
\LoadClass[ngerman,10pt]{scrartcl}
\RequirePackage{babel}
\RequirePackage{enumitem,tikz}

\ifLESA@code
    \PassOptionsToPackage{sopra-listings={:defaults,encoding,cpalette},sopra}{lithie-util}
\fi

\RequirePackage[color-palettes={:defaults,enumitem},color,graphics]{lithie-util}

\ifLESA@fonts
%% Fonts
\ifprofile{print}{
\RequirePackage[charter,expert]{mathdesign}
\RequirePackage[scaled=.96,sups,osf]{XCharter}
\RequirePackage[tabular,lining]{montserrat}
}{
% needed to allow compat opts
\AtEndPreamble{%
\RequirePackage[cmintegrals,cmbraces,ebgaramond]{newtxmath}
\RequirePackage{ebgaramond-maths}
\RequirePackage[tabular,lining]{montserrat}
}}
\fi

\RequirePackage{lecture-personal-tikz}

\def\sbfamily{\fontseries{sb}\selectfont}
\def\textsb#1{{\sbfamily#1}}

%% Microtype
\RequirePackage[activate={true,nocompatibility},final,kerning=true,spacing=true,stretch=20,factor=1042,shrink=20,babel]{microtype}
\SetTracking{encoding={*}, shape=sc}{42}

%% Color concept
\DefineTikzPalette{BoldInk}
{\paletteAname: paletteA,fill=paletteA}
{\paletteBname: paletteB,fill=paletteB}
{\paletteCname: paletteC,fill=paletteC}
{\paletteDname: paletteD,fill=paletteD}
{Schwarz: text=white}

\ifprofile{print}{\UsePalette{\LESA@printcpalette}\UseTikzPalette{\LESA@printtpalette}}%
    {\UsePalette{\LESA@cpalette}\UseTikzPalette{\LESA@tpalette}}

\def\vb@xt@{\vbox to}

\ifLESA@graphic
\RequirePackage[active,tightpage]{preview}
% allows to cancel easier
\providecommand\MakePreviewTikz{\PreviewEnvironment{tikzpicture}}
\MakePreviewTikz
\fi

\endinput