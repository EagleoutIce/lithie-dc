%% lecture-standalone documentclass
%% Florian Sihler, 7 Oct. 2020
%%
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

\LoadClass[ngerman,10pt]{scrartcl}
\RequirePackage{babel}

\usepackage{enumitem}
\RequirePackage[color-palettes={:defaults,enumitem,addons},color,sopra-listings={:defaults,encoding,cpalette},sopra]{lithie-util}

\RequirePackage[tabular,lining]{montserrat}
\RequirePackage{ebgaramond-maths}
\RequirePackage[stretch=42,babel,final]{microtype}

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
    \usepackage[active,tightpage]{preview}%
    \PreviewEnvironment{tikzpicture}%
\fi

\endinput