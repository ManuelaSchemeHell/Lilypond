%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Gottes Liebe ist so wunderbar
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Gottes Liebe ist so wunderbar"
%% Voice 1
firstvoice =
\relative c'' {
  \key f \major
  a4 a f f a a c8 b a4
  g g e e g g b8 a g4
  a a f f a a c8 b a4
  c2 b8 a g4 f1 \bar "||"
  a2 f a4 a c8 b a4 g2 e g4 g b8 a g4
  a2 f a4 a c8 b a4 c2 b8 a g4 f1 \bar "|."
}
%% Voice 2
secondvoice =
\relative c' {
  c
}
%% Chords
songchords =
\chordmode {
  f1 f c c:7 f c f f f c c:7 f f c f
}


%% Song Lyrics
firststrophe = \lyricmode {
  \set stanza = #"1. "
  Got -- tes Lie -- be ist so wun -- der -- bar,
  Got -- tes Lie -- be ist so wun -- der -- bar,
  Got -- tes Lie -- be ist so wun -- der -- bar,
  so wun -- der -- bar groß.

  So hoch, was kann hö -- her sein?
  So tief, was kann tie -- fer sein?
  So weit, was kann wei -- ter sein?
  So wun -- der -- bar groß.
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" \firstvoice
        \context SecondVoice="sndvoice" \secondvoice

      >>
      \new Lyrics \lyricsto "melody" \firststrophe
    >>
    \context ChordNames \songchords
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: unbekannt"
        "Melodie: unbekannt"
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
          "Gottes Güte ist so wunderbar ..."
        }
      }
      \line {
        \bold "3."
        \column {

          "Gottes Gnade ist so wunderbar ..."
        }
      }
      \line {
        \bold "4."
        \column {
          "Gottes Treue ist so wunderbar ..."
        }
      }
      \line {
        \bold "5."
        \column {
          "Gottes Hilfe ist so wunderbar ..."
        }
      }
    }

    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}