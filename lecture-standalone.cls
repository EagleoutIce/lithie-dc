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

\LoadClass[ngerman]{scrartcl}

\usepackage{tikz}
\usepackage[color-palettes={:defaults,addons},color,sopra-listings={:defaults,encoding},sopra]{lithie-util}


\AppendToProfile{print}{%
    \UsePalette{GrayPrint}%
    \UseTikzPalette{DeepInk}%
}

\AppendToProfile{default}{%
    \UsePalette{GrayPrint}%
    \UseTikzPalette{DeepInk}%
}

\iflecst@standalone@graphics@
    \usepackage[active,tightpage]{preview}%
    \PreviewEnvironment{tikzpicture}%
\fi

\endinput