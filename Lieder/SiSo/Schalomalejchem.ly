%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Schalom alejchem
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Schalom alejchem"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key f \major
  \partial 4.
  a8 d f
  a2 f4. e8 e d4 ( d ) d8 f a
  d2 b4. a8 a g4 ( g ) g8 a b
  a4. ( e8 ) a4. g8 g8 f4 ( f ) f8 e d a'4 a8 r a4 a8 r
  a8. g16 f8 e d \bar ":|."
}

%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4. d2:m c:7 d1:m b2:m f:7
  b1:m c:7 d:m c:7 c2:7 d:m
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  He -- we -- nu scha -- lom a -- le -- chem,
  he -- we -- nu scha -- lom a -- le -- chem,
  he -- we -- nu scha -- lom a -- le -- chem,
  he -- we -- nu scha -- lom, scha -- lom,
  scha -- lom a -- le -- chem.
}


\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context Voice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }

      >>
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
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
        "Text: Jüdischer Friedensgruß"
        "Melodie: Volksweise aus Israel"
      }
    }
    piece = ""
    opus = ""
  }

}
