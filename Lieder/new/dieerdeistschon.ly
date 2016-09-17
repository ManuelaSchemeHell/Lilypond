%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Die Erde ist schön, es liebt sie der Herr
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Die Erde ist schön, es liebt sie der Herr"
%% Voice 1
firstvoice =
\relative c' {
  \key g \major
  \partial 4
  d4 h'8 h4 a8 g4 g g8 g4 fis8 e2
  d8 d4 h8 d4 g a2 r4
  d, h'8 h4 a8 g4 g g8 g4 fis8 e2
  d8 d4 h8 d4 g a h8 ( a ) g2~ g
  r4 d8 c h4 h h a h d2 d8 c
  h4 h h d a2 r4 d8 c
  h4 h h d e g2 g8 a h4 d, d a' g2 r4 \bar "|."
}
%% Voice 2
secondvoice =
\relative c' {
  d4 d
}
%% Chords
songchords =
\chordmode {
  s4 g1 c g d:7 g c g d2 g
  g1 g g g d:7 g c g2 d:7 g
}


%% Song Lyrics
firststrophe = \lyricmode {
  \set stanza = #"Refrain: "
  Die E -- rde ist schön, es liebt sie der Herr,
  Neu ist der Mensch, der liebt.
  Die E -- rde ist schön, es liebt sie der Herr,
  Neu ist der Mensch, der liebt wie er.
  \set stanza = #"1. "
  Gros -- se Freu -- de wir ge -- fun -- den,
  sie be -- glei -- tet uns vor -- an.
  Al -- len möch -- ten wir sie schen -- ken,
  dass die Welt sich freu -- en kann.
}

secondstrophe = \lyricmode {
  \repeat unfold 34 { \skip 1 }
  \set stanza = #"2. "
  Al -- le We -- ge die -- ser Er -- de
  fü -- hren zu dem Him -- mel hin,
  und der Wind, der mich um -- we -- het,
  lenkt zur Son -- ne hin den Sinn.
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
      \new AltLyrics \lyricsto "melody" \secondstrophe
    >>
    \context ChordNames \songchords
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: ???"
        "Melodie: ???"
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
        \bold "3."
        \column {
          "Alle Menschen sind uns Brüder,"
          "teilen woll'n wir Freud und Leid,"
          "Daraus wächst das wahre Leben,"
          "das die Welt erwartet heut."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Bei der Arbeit, in der Freizeit,"
          "fern sei Zwietracht, Zorn und Neid,"
          "schenk dem andern deine Liebe,"
          "und ins Herz zieht ein die Freud. "
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}