%% Class nature
%% Written by Peter Czoschke, czoschke@mrl.uiuc.edu
%% v1.0 24 Feb. 2004
%%
%% A document class for Nature letters and articles that (should)
%% conform to the Nature preprint style as defined by their Word template.
%%
%% I created this class for personal purposes and without any connection
%% to the Nature Publishing Group.  I in no way claim that documents generated
%% with this file fully comply with their current style requirements.
%% I disclaim any responsibility for the use of this file heretofore.
%%
%% ------------------------------------
%%
%% See the accompanying file nature-template.tex for an example.
%%
%% Use with naturemag.bst if using BibTeX.
%%
%% Nature wants things in the order:
%% title, text, methods, references, Supplementary Information line (if any),
%% acknowledgements, interest declaration, corresponding author line,
%% tables, figure legends
%%
%% This class provides the following non-standard features:
%% 
%%  1   "affiliations" environment for listing the authors' institutions
%%
%%  2   "methods" environment for the Methods section
%%
%%  3   "addendum" environment for the Acknowledgements, etc. at the end
%%
%% In addition, the abstract, figure and table environments are redefined. See below.
%%

\ProvidesClass{nature}[24/2/2004 v1.0]
\typeout{A class for writing preprints for the journal Nature}
\typeout{Written by Peter Czoschke}
\typeout{ }

\LoadClass[12pt]{article}
\RequirePackage{times}
\RequirePackage{fullpage}
\RequirePackage{ifthen}

%%%% Biblatex bibliography %%%%

\RequirePackage[
    autocite=superscript,
    sorting=none,
    style=nature,
    defernumbers=true,
    backend=bibtex,
    ]{biblatex}

%% This section allows for a two part bibliography, one for the main text and
%% and one for the methods, with continuous numbering.
% Overall entry counter
\csnumgdef{blx@entrycount}{0}
\AtEveryBibitem{%
  \csnumgdef{blx@entrycount}{\csuse{blx@entrycount}+1}}

% Continued from this label number
\appto{\newrefsegment}{%
  \csnumgdef{blx@entrycount@\the\c@refsegment}{\csuse{blx@entrycount}+1}}

% Skip entries with label numbers less than the continued number
\defbibcheck{onlynew}{%
  \ifnumless{\thefield{labelnumber}}{\csuse{blx@entrycount@\the\c@refsegment}}
    {\skipentry}
    {}}

%%%%%


%% Some style parameters
\setlength{\parindent}{0.39in}
\setlength{\parskip}{18pt}
\newcommand{\spacing}[1]{\renewcommand{\baselinestretch}{#1}\large\normalsize}
\spacing{2}

%% Redefine \maketitle for Nature style
\def\@maketitle{%
  \newpage\spacing{1}\setlength{\parskip}{12pt}%
    {\Large\bfseries\noindent\sloppy \textsf{\@title} \par}%
    {\noindent\sloppy \@author}%
}

%% Define the affiliations environment, list each institution as an \item
%% Put after \maketitle
\newenvironment{affiliations}{%
    \setcounter{enumi}{1}%
    \setlength{\parindent}{0in}%
    \slshape\sloppy%
    \begin{list}{\upshape$^{\arabic{enumi}}$}{%
        \usecounter{enumi}%
        \setlength{\leftmargin}{0in}%
        \setlength{\topsep}{0in}%
        \setlength{\labelsep}{0in}%
        \setlength{\labelwidth}{0in}%
        \setlength{\listparindent}{0in}%
        \setlength{\itemsep}{0ex}%
        \setlength{\parsep}{0in}%
        }
    }{\end{list}\par\vspace{12pt}}

%% Redefine the abstract environment to be the first bold paragraph
\renewenvironment{abstract}{%
    \newrefsegment
    \setlength{\parindent}{0in}%
    \setlength{\parskip}{0in}%
    \bfseries%
    }{\par\vspace{-6pt}}

%% Redefine the \section command.
\renewcommand{\section}{\@startsection {section}{1}{0pt}%
    {-6pt}{1pt}%
    {\bfseries}%
    }
\renewcommand{\subsection}{\@startsection {subsection}{2}{0pt}%
    {-0pt}{-0.5em}%
    {\bfseries}*%
    }

%% Define the methods environment.  Use \subsection to separate.
\newenvironment{methods}{%
    \newrefsegment
    \section*{Methods}%
    \setlength{\parskip}{12pt}%
    }{}

%% Define the extended data environment.
\newenvironment{extended-data}{%
    \section*{Extended Data}%
    \setlength{\parskip}{12pt}%
    \renewcommand{\figurename}{Extended Data Figure}
    \renewcommand{\tablename}{Extended Data Table}
    \setcounter{figure}{0}
    \setcounter{table}{0}
}{}


%% No heading for References section, but eat up the extra space from \section command
\renewcommand\refname{\vspace{-48pt}\setlength{\parskip}{12pt}}

%% Define the addendum environment for Supplementary Info, Acknowledgements, etc.
\newenvironment{addendum}{%
    \setlength{\parindent}{0in}%
    \small%
    \begin{list}{Acknowledgements}{%
        \setlength{\leftmargin}{0in}%
        \setlength{\listparindent}{0in}%
        \setlength{\labelsep}{0em}%
        \setlength{\labelwidth}{0in}%
        \setlength{\itemsep}{12pt}%
        \let\makelabel\addendumlabel}
    }
    {\end{list}\normalsize}

\newcommand*{\addendumlabel}[1]{\textbf{#1}\hspace{1em}}

%% Redefine the figure and table environments.
%% The new figure environment defers printing of all figure captions
%% until the end of the document and prints them in sans serif font.
%% The \includegraphics command is ignored since Nature wants figures
%% as separate files.
%% The table environment was just changed to print on a separate page in
%% sans serif font.  Tables should all be moved to the end of the document
%% manually.  

%Uncomment next lines for final submission to Nature.

%\renewenvironment{figure}{\let\caption\NAT@figcaption}{}

%\newcommand{\NAT@figcaption}[2][]{\AtEndDocument{%
%    \refstepcounter{figure}
%    \ifthenelse{\value{figure}=1}{
%        \newpage\noindent%
%        \rule{\textwidth}{1pt}
%    }{
%        \par\vfill
%    }
%    \sffamily\noindent\textbf{Figure \arabic{figure}}\hspace{1em}#2}
%    }

%\renewenvironment{table}{\@float{table}[p]\sffamily\footnotesize}{\end@float}

\newcommand{\includetable}[1]{\input{#1}}
\newcommand{\NAT@ignore}[2][]{}

%% Ignore all \includegraphics commands in the document.
%  Uncomment next two lines before final submission to Nature.

\AtBeginDocument{\let\includegraphics\NAT@ignore}
\AtBeginDocument{\let\includetable\NAT@ignore}

