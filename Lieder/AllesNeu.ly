%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Alles neu macht der Mai
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Alles neu macht der Mai"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  \key g \major
  \time 2/4
  d8 h h4 c8 a a4 g8 a h c d d d r
  d8 h h4 c8 a a4 g8 h d d d4 r
  a8 a a a a h c4 h8 h h h h c d4
  d8 h h4 c8 a a4 g8 h d d d4 r \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c'' {
  g8 g g4 fis8 fis fis4 d8 d d g h h h s
  g8 g g4 fis8 fis fis4 d8 g h h h4 s
  fis8 fis fis fis fis g g4 g8 g g g g g g4
  g8 g g4 fis8 fis fis4 d8 d d g h4
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  g2 d:7 g g g d:7
  g g d:7 d g g g d:7 g g
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
          "Wir durchziehn Saaten grün,"
          "Haine, die ergötzend blüh'n,"
          "Waldespracht, neu gemacht"
          "nach des Winters Nacht."
          "Dort im Schatten an dem Quell,"
          "rieselnd munter silberhell,"
          "Klein und Groß ruht im Moos,"
          "wie im weichen Schoß."
        }
      }

    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Hier und dort, fort und fort,"
          "wo wir ziehen, Ort für Ort,"
          "wie sich heut' alles freut"
          "dieser Frühlingszeit."
          "Stimmet Jubellieder an!"
          "Singe jeder wie er kann:"
          "Alles neu, frisch und frei"
          "macht der holde Mai."
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
  Al -- les neu macht der Mai,
  macht die See -- le frisch und frei.
  Lasst das Haus, kommt hin -- aus,
  win -- det ei -- nen Strauß!
  Rings er -- glän -- zet Son -- nen -- schein,
  duf -- tend pran -- gen Flur und Hain:
  Vo -- gel -- sang, Hör -- ner -- klang
  tönt den Wald ent -- lang.
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
        "Text: Hermann Adam von Kamp (1796-1867),1829"
        "Melodie: Volksweise (18. Jhdt.)"
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Alles neu macht der Mai
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%