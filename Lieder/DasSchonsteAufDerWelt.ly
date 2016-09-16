myTitel="Das Schönste auf der Welt"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  \partial 4
  g4 c,4. e8 e4. g8
  g2. g4 g4. g8 a4 g d2 h'4\rest c,
  h4. d8 d4. h'8 h4. ( a8 ) h4 a g4. g8 a4 g e2 h'4\rest
  g8. e16 c8. c16 c8. c16 c4 c8. e16
  g8. g16 g8. g16 g4 c h4. h8 a4 h c h4\rest h4\rest g \bar ".|:"
  \repeat volta 2 {
    c4. c8 c c d c
    a4 f' d c h4. h8 h h a h
  }
  \alternative {
    { c4 h8 a g4 \breathe g8 g \bar ":|." }
    { c2 h4\rest }
  } \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c'' {
  \partial 4
  g4  c,4. c8 c4. e8
  e2. e4
  e4. e8 f4 e h2 s4 c
  h4. d8 d4. d8 d4. ( c8 ) d4 f e4. e8 f4 e c2 s4
  g'8. e16 c8. c16 c8. c16 c4 c8. e16
  g8. g16 g8. g16 e4 e g4. g8 f4 g e s s g
  e4. e8 e e f e f4 a f a
  g4. g8 g g f g e4 g8 f e4 g8 g e2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 c1 c c g g g g c c c g c c f g:7 c4 f c2 c2.
}
%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Des Morgens in der Früh',"
          "steig ich so hoch hinauf,"
          "da geht so wunderschön"
          "die liebe Sonne auf."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Des Nachts, wenn alles schläft,"
          "nur ich allein bin wach,"
          "dann steig ich auf die Alm hinauf"
          "und jag dem Gamsbock nach."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Den Schatz, den ich nicht mag,"
          "den seh ich alle Tag,"
          "und die mein Herz erfreut,"
          "die ist so weit, so weit."
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "Wenn ich gestorben bin,"
          "so tragt mich hoch hinauf,"
          "begrabt ihr mich im Tale,"
          "dann steig ich selber nauf."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}
%% Songtext
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. " Das Schöns -- te auf der Welt
  ist mein Ti -- ro -- ler -- land,
  mit sei -- nen stei -- len Hö -- hen,
  mit sei -- ner Fel -- sen -- wand.
  \set stanza = #"1.-5." Hol -- la -- ri -- a, hol -- la -- ro,
  hol -- la -- ri -- a, hol -- la -- ro
  hoch dro -- ben auf der Alm.
  Ti -- ro -- ler -- land, wie bist du schön, so schön
  wer weiß, ob wir uns wie -- der -- sehn
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
      \context Lyrics \with {
        alignBelowContext = "leadsheet"
      } \lyricsto "melody" {
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
        "Text: Volkslied"
        "Melodie: Volksweise"
      }
    }
    piece = ""
    opus = ""
  }
}

#(ly:parser-include-string (string-append "\\\"" myTitel "\""))