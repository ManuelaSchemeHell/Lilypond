%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Die grauen Nebel
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Die grauen Nebel"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key g \major
  \partial 2
  r8 d8 g a h4 h h8 a g h d4 d2 c8 h a4 a a8 c h a g2 r8
  d8 g a h4 h h8 a g h d4 d2 c8 h a4 a a8 c h a g2 r2
  h2 h h4 c d2 a4 a8 h c4 a h e d4 \breathe \tuplet 3/2 { d8 e d }
  h2 h h4 c d2
  a4 a8 c h4 a g2\fermata \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  s8 d8 g a d,4 d e8 e e e
  fis4 fis2 fis8 fis fis4 fis fis8 a g d d2 s8
  d8 g a g4 g g8 fis e g fis4 fis2 fis8 fis fis4 fis fis8 fis fis fis d2 s2
  d2 d d4 e fis2 fis4 fis8 fis fis4 fis g g h2
  d,2 d d4 e fis2
  fis4 fis8 fis g4 fis d2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s2 g2 e:m d1:7 d g g2 e:m
  d1 d g g g d g g g d g
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
          "Sie lassen alles in der Tiefe liegen,"
          "wollen nur hinauf zum hellen Licht,"
          "sie wollen in den klaren Höhen siegen,"
          "einen Weg nach unten gibt es nicht."
        }
      }
    }
    \hspace #0 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Sie werden Männer, die ihr Reich erringen,"
          "die es schützen vor dem großen Feind."
          "Die Augen strahlen und die Lieder klingen,"
          "ihre Herzen sind im Kampf vereint."
        }
      }
    }
    \hspace #0 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Die grau -- en Ne -- bel hat das Licht durch -- drun -- gen,
  und die düs -- tern Ta -- ge sind da -- hin.
  Wir se -- hen ei -- ne blau -- e Schar von Jun -- gen
  an der lau -- ten Stadt vor -- ü -- ber zieh'n.
  Komm, komm, lockt der Schritt.
  Komm, Ka -- me -- rad wir zie -- hen mit.
  Jei jei jei
  Komm, komm, lockt der Schritt.
  komm, wir mar -- schie -- ren mit.
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
        "Text: Volkslied (20. Jhdt.)"
        "Melodie: Volksweise (20. Jhdt.)"
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
