%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Muster
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="LiedTitel"
%% Voice 1
firstvoice =
\relative c'' {
  c
}
%% Voice 2
secondvoice =
\relative c' {
  c
}
%% Chords
songchords =
\chordmode {
  c
}


%% Song Lyrics
firststrophe = \lyricmode {
  \set stanza = #"1. "
  1. Strophe
}

secondstrophe = \lyricmode {
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