%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Wiegende Welle
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Wiegende Welle"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  \key g \major
  h4 h8 a g4 g8 e d4 g8 a h4 r
  a4 a8 g fis g a c h2 g4 r
  h4 h8 a \slurDotted g4 ( g8 ) e d4 g8 a h4 r
  a4 a8 g fis g a h g2 r4 r8 g
  e4 g c4. e,8 d4 g h4. g8 fis4. g8 a g a c
  h2 g4 r8 g e e g g c4. e,8
  d d g g h4. g8 fis4. g8 a g a h g2 r \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  d4 d8 c h4 h8 h h4 h8 c d4 s
  fis4 fis8 e d e fis a g2 d4 s
  d4 d8 c h4 h8 h h4 h8 c d4 s
  fis4 fis8 e d e fis g d2 s4 s8 c
  c4 e g4. c,8 h4 d g4. d8 d4. d8 d d fis a
  g2 d4 s8 c c c c c g'4. c,8
  h h d d g4. d8 d4. d8 fis g fis g <d h >2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  g1 g1 d:7 g g  d1 d:7 g c g d:7 g c g d:7 g
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  \set ignoreMelismata = ##t \set stanza = #"1. "
  Wie -- gen -- de Wel -- le auf wo -- gen -- der See,
  wal -- len -- de Flu -- ten der Ge -- zei -- ten,
  schau -- kelnd her -- nie -- der und wie -- der zur Höh,
  trägst du mein Boot im fro -- hen Spiel.
  %\set stanza=#"1.-2."
  "1.-2. Ein" fri -- scher Wind weht uns ge -- schwind
  in blau -- e, un -- be -- grenz -- te Wei -- ten,
  weht im -- mer, im -- mer zu,
  ihr Win -- de, mein Ka -- nu
  fliegt mit uns fort zum fer -- nen Ziel.
}
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Gisch -- ten -- de Bran -- dung am tük -- ki -- schen Riff,
  stru -- deln -- de Was -- ser mich um -- lau -- ern.
  Al -- len Ge -- fah -- ren trot -- zet mein Schiff,
  hei, wie wir flie -- gen durch die Flut!
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