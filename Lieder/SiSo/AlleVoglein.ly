%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Alle Vöglein sind schon da
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Alle Vöglein sind schon da"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  c4. e8 g4 c a c8 ( a ) g2 f4. g8 e4 c d2 c4 r
  g' g f f c g'8 ( e ) d2 g4 g f f e g8 ( e ) d2 \breathe
  c4. e8 g4 c a c8 ( a ) g2 f4. g8 e4 c d2 c4 r \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  c4. c8 e4 g f a8 ( f ) e2 d4. e8 c4 c h2 c4 s
  e e d d c e8 ( c ) h2 e4 e d d c e8 ( c ) h2
  c4. c8 e4 g f a8 ( f ) e2 d4. e8 c4 c h2 c4
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  c1 f2 c d:m c g c
  c g:7 c g:7 c g:7 c g:7
  c1 f2 c d:m c g c
}
%% Text
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Wie sie alle lustig sind,"
          "flink und froh sich regen!"
          "Amsel, Drossel, Fink und Star"
          "und die ganze Vogelschar"
          "wünschen dir ein frohes Jahr,"
          "lauter Heil und Segen."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Was sie uns verkünden nun,"
          "nehmen wir zur Herzen:"
          "alle wolln wir lustig sein,"
          "lustig wie die Vögelein,"
          "hier und dort, feldaus, feldein,"
          "springen, tanzen scherzen."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Al -- le Vög -- lein sind schon da, al -- le Vög -- lein, al -- le!
  Welch ein Sin -- gen, Mu -- si -- ziern,
  Pfei -- fen, Zwit -- schern, Ti -- ri -- liern!
  Früh -- ling will nun ein -- mar -- schiern,
  kommt mit Sang und Schal -- le.
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
        "Text: August Heinrich Hoffmann von Fallersleben (1798–1874), 1843"
        "Melodie: Volksweise"
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Alle Vöglein sind schon da
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%