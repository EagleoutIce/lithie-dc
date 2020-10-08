%% lecture-standalone documentclass
%% Florian Sihler, 7 Oct. 2020
%%

\newif\iflecst@standalone@graphics@
\DeclareOption{graphic}{\lecst@standalone@graphics@true}
\DeclareOption{nographic}{\lecst@standalone@graphics@false}

\newif\iflecst@standalone@debug@
\DeclareOption{debug}{\lecst@standalone@debug@true}
\DeclareOption{nodebug}{\lecst@standalone@debug@false}

\ProcessOptions*\relax%

\iflecst@standalone@debug@
\errorcontextlines 999999
\fi

\LoadClass[ngerman,10pt]{scrartcl}

\usepackage{tikz}
\usepackage[color-palettes={:defaults,addons},color,sopra-listings={:defaults,encoding,cpalette},sopra]{lithie-util}


\DefineTikzPalette{SoftInk}
{\paletteAname: paletteA,fill=paletteA!56!white}
{\paletteBname: paletteB,fill=paletteB!56!white}
{\paletteCname: paletteC,fill=paletteC!56!white}
{\paletteDname: paletteD,fill=paletteD!56!white}
{Schwarz: text=black}

\AppendToProfile{print}{%
    \UsePalette{GrayPrint}%
    \UseTikzPalette{CleanPlate}%
}

\AppendToProfile{default}{%
    \UsePalette{GreenWater}%
    \UseTikzPalette{SoftInk}%
}

\iflecst@standalone@graphics@
    \usepackage[active,tightpage]{preview}%
    \PreviewEnvironment{tikzpicture}%
\fi

\endinput