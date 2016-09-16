%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Leobenlied
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Leobenlied"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  c
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  c
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  c
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Wenn ich die Strecken und Baue durchquer,
  das Haupt gebeugt vor den Firsten,
  die Brust von schwülem Broden schwer,
  der Gaumen vertrocknet vor Dürsten,
  da ist mir’s als wären es tausend Jahr,
  daß ich in den Bergen da droben,
  |: daß ich Student in Leoben war,
  im alten, trauten Leoben! :|
  Kein Faß gab’s, daß wir nicht leer gekriegt,
  kein Fels, den wir nicht erstiegen,
  kein arges Wort blieb ungerügt,
  kein Freies blieb verschwiegen.
  Und immer war unsere Faust bereit,
  den scharfen Schläger zu proben,
  |: das war die schöne, die goldene Zeit,
  im alten, trauten Leoben! :|

  Und Mädels gab es so süß und so hold,
  und Freunde so lustig und bieder,
  mit Gurgeln aus Stahl und Herzen voll Gold,
  und Kehlen voll jubelnder Lieder,
  nun sitzen auch sie auf einsamen Schacht,
  in alle Winde zerstoben,
  |: und denken voll Sehnsucht der sonnigen Pracht,
  im alten, trauten Leoben!
}

#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  2 Strophe
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
        "Text: Volkslied"
        "Melodie: Volksweise"
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
        \bold "2."
        \column {
          "This is verse two."
          "It has two lines."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "This is verse three."
          "It has two lines."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "This is verse four."
          "It has two lines."
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "This is verse five."
          "It has two lines."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}
