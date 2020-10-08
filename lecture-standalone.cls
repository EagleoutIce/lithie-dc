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
\RequirePackage{babel}

\RequirePackage[color-palettes={:defaults,addons},color,sopra-listings={:defaults,encoding,cpalette},sopra]{lithie-util}

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
    \UsePalette{GrayPrint}%
    \UseTikzPalette{CleanPlate}%
}

\AppendToProfile{default}{%
    \UsePalette{GreenWater}%
    \UseTikzPalette{BoldInk}%
}

\iflecst@standalone@graphics@
    \usepackage[active,tightpage]{preview}%
    \PreviewEnvironment{tikzpicture}%
\fi

\endinput