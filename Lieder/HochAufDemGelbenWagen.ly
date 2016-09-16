%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Hoch auf dem gelben Wagen
myTitel="Hoch auf dem gelben Wagen"
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key f \major
  c4 f8 g a4 c a ( g ) f2 c4 f8 g a4 g f2. r4
  c4 f8 g a4 c a ( g ) f r g4 g g8 [ f ] e f g2. r4
  d4 d8 d g4 g8 a f2 c4 r
  g'4 g8 g c4 g a2 r4 a4
  \repeat volta 2
  {
    \bar ".|:"
    d,4 d8 d f4 e8 d c4 ( f8 [ a ] ) c2
    c2 h4 c d2 c4 b
  }
  \alternative { {a2 r4 a \bar ":|." } { a2 r2 } }
  \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  s1
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  f1 f1 f2. c4 f1 f f c:7 c
  b2 c2 f1 c:7 f b f f
  b2 c:7 f1 f
}
%% Text
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "3."
        \column {
          "Postillon in der Schenke"
          "füttert Rosse im Flug,"
          "schäumendes Gerstengetränke"
          "reicht uns der Wirt im Krug."
          "Hinter den Fensterscheiben"
          "lacht ein Gesicht gar hold,"
          "ich möchte so gerne noch bleiben,"
          "aber der Wagen, der rollt."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Sitzt einmal ein Gerippe"
          "hoch auf dem Wagen vorn,"
          "hält statt der Peitsche die Hippe,"
          "Stundenglas statt Horn."
          "Sag ich: Ade, nun, ihr Lieben,"
          "die ihr nicht mitfahren wollt,"
          "ich wäre so gern noch geblieben,"
          "aber der Wagen, der rollt."
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
  Hoch auf dem gel -- ben Wa -- gen
  sitz ich beim Schwa -- ger vorn.
  Vor -- wärts die Ros -- se tra -- ben,
  lus -- tig schmet -- tert das Horn.
  Ber -- ge und Tä -- ler und Au -- en,
  leuch -- ten -- des Äh -- ren -- gold,
  ich "|:möch" -- te so ger -- ne noch  schau -- en;
  a -- ber der Wa -- gen, der rollt. "Ich :|" rollt.
}

#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Flö -- ten hör ich und Gei -- gen,
  lus -- ti -- ges Baß -- ge -- brumm,
  jun -- ges Volk im Rei -- gen
  tanzt um die Lin -- de he -- rum.
  Wir -- belt wie Blät -- ter im Win -- de,
  ju -- belt und lacht und tollt,
  ich "|:blie" -- be so gern bei der Lin -- de;
  a -- ber der Wa -- gen, der rollt. "Ich :|" rollt.
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
        "Musik: Heinz Höhne (1892-1968)"
        "Text: Rudolf Baumbach (1840–1905)"
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))