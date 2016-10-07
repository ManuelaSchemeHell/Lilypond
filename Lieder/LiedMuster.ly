\language "deutsch"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Muster
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#(define myTitel "LiedTitel")

%% Voice 1
firstvoice=
\relative c'' {
  c
}

%% Voice 2
secondvoice =
\relative c' {
  s8
}

%% Chords
songchords =
\chordmode {
  s8
}

%% Song Lyrics
firstverse =
\lyricmode {
  \set stanza = #"1. "
  %&glqq; &grqq; bei -- nån -- der
  1. Strophe
}

secondverse =
\lyricmode {
  \set stanza = #"2. "
  Strophe xx
}

thirdverse=
\lyricmode {
  \set stanza = #"3. "
  Strophe xxx
}

fourthverse =
\lyricmode {
  \set stanza = #"4. "
  Strophe xxxx
}

fifthverse =
\lyricmode {
  \set stanza = #"5. "
  Strophe xxxxx
}

\score
{
  <<
    \new Staff="leadsheet"
    <<
      \tocItem \markup #myTitel
      \indexItem #myTitel \markup #myTitel
      \context FirstVoice="melody" \firstvoice
      \context SecondVoice="sndvoice" \secondvoice
    >>
    \new Lyrics \lyricsto "melody" \firstverse
    \new AltLyrics \lyricsto "melody" \secondverse
    \new Lyrics \lyricsto "melody" \thirdverse
    \new AltLyrics \lyricsto "melody" \fourthverse
    \new Lyrics \lyricsto "melody" \fifthverse
    \context ChordNames \songchords
  >>
  \header {
    title = #myTitel
    subtitle = ##f
    subsubtitle = ##f
    poet = ##f
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Volkslied"
        "Melodie: Volksweise"
      }
    }
    piece = ##f
    opus = ##f
  }

}

%% Songtext
\markup {
  \column {
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
    \vspace #Absatz
    \fill-line
    {
      \line {
        \bold { \with-color #white "1" "9." }
        \column {
          "This is a single verse five."
          "centered in the line."
        }
      }
    }
  }
}
