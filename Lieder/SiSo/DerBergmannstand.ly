%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Der Bergmannsstand sei hoch geehret
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Der Bergmannsstand sei hoch geehret"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key b \major
  \partial 4.
  b8 b d f4. f8 g ( f ) g( a ) b ( f ) f4 r8
  b, b d f4. f8 b ( f ) b ( d ) c2 r4
  c8 b a4. c,8 c c a' g g4 f r8 c c c a'4. c,8 c c a' g f4 ( es ) r
  d8 es \bar ".|:"
  \repeat volta 2 { f4 b8 c d8. c16 b8 g f2 d4 g8 f f ( a ) a4 a g8 a }
  \alternative { { b2 r4 d,8 es \bar ":|." } { b2 r8 f' g a } }
  b2 r8 b a b g2 r8 c c c d4. d8 es4 a, b2 r8 \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  b8
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4.
  b1 b b f f es
  f f b b f b b b es b b2
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Der Berg -- manns -- stand sei hoch ge -- eh -- ret,
  es le -- be hoch, der Berg -- manns -- stand!
  Wenn er auch das Ta -- ges -- licht ent -- beh -- ret,
  so tut er’s doch für’s teu -- re Va -- ter -- land.
  Ja den Söh -- nen der Gru -- ben und der Ber -- ge,
  reicht ein je -- der freund -- lich die Hand!
  Ja den Hand!
  Es le -- be hoch, es le -- be hoch,
  es le -- be hoch, der Berg -- manns -- stand.
}

#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"1. "
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
        "Volkstümliches Bergmannslied"

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
          "Hört ihr nicht des Glöckleins leises Schallen?"
          "Hört ihr nicht die Klopfe, die uns ruft?"
          "Nun wohlan, zum Schachte laßt uns wallen."
          "Ein Glück Auf! erschalle durch die Luft."
          "|: Ja den Söhnen der Gruben und der Berge,"
          "reicht ein jeder freundlich die Hand,"
          "Es lebe hoch, es lebe hoch,"
          "es lebe hoch, der Bergmannsstand. :|"
        }
      }

    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Bringen wir die Berge dann zum Weichen,"
          "und ist gewonnen dann das reiche Erz,"
          "großen Lohn, den sie alsdann uns reichen,"
          "und die Lieb erfreuet unser Herz."
          "|: Ja den Söhnen der Gruben und der Berge,"
          "reicht ein jeder freundlich die Hand,"
          "Es lebe hoch, es lebe hoch,"
          "es lebe hoch, der Bergmannsstand. :|"
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