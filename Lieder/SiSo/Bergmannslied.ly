%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Muster
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Bergmannslied"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key f \major
  f2 e4 g f2 r a g4 b a2 r4 f8 ( g )
  a4 a a g8 ( a ) b4 g g g8 ( a )  b4 d d c8 ( b )
  c4 a a g f2 g a4 d c b a2 ( g f2. ) r4 \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  c2 c4 c c2 s f e4 g f2 s4 c8 ( c )
  f4 f f e8 ( f ) g4 e e e8 ( f )  f4 b b a8 ( f )
  a4 f f e c2 c f4 b a f f2 ( e c2. ) s4
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  f2 c:7 f s f c:7 f s f1 c:7 b f f2 c:7 f4 b f b f2 c:7 f
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Glück auf! Glück auf! Der Stei -- ger kommt,
  er hat sein hel -- les Licht bei Nacht
  er hat sein hel -- les Licht bei Nacht
  schon an -- ge -- zünd't, schon an -- ge -- zünd't. __
}

#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Hat's an -- ge -- zünd't, es gibt ei-nen Schein
  \set ignoreMelismata = ##t
  und da -- mit so
  fah -- ren __ _ wir ins~Berg-werk ein
  und da -- mit so fah -- ren __ _ wir ins Berg-werk~ein
  ins Berg -- werk ein, ins
  \set ignoreMelismata = ##f
  Berg -- werk ein. __

}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
      \new AltLyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "2\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Volkslied (1740)"
        "Melodie: Volksweise (18. Jhdt.)"
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext

\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "3."
        \column {
          "Die Bergleut sein" "so hübsch und so fein:"
          "sie graben das feinste Gold"
          "aus Felsenstein."
        }
      }
      \vspace #Absatz
      \line {
        \bold "4."
        \column {
          "Der ein grabt Silber," "der andere Gold"
          "und dem schwarzbraunen Mägdelein,"
          "dem sind sie hold."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "5."
        \column {
          "Ade, nun ade, Herzliebste mein!"
          "Und da drunten" "im tiefen, finstern Schacht,"
          "da denk ich dein."
        }
      }
      \vspace #Absatz
      \line {
        \bold "6."
        \column {
          "Und kehr ich heim zum Liebchen mein,"
          "dann erschallt der Bergmanns""Gruß bei der Nacht"
          "Glück auf, Glück auf!"
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Muster
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%