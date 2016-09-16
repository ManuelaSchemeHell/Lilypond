%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Mein Vater ist Bergmann
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Mein Vater ist Bergmann"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \time 6/8
  \partial 8
  e8 g8. g16 a8 g4. e4. ( e4 ) e'8
  e c h d4. ( d4 ) c8 c h a
  a4. g ( g4 ) a8 g4 f8 e4. ( e4 ) g8
  g e f g4. g ( g4) e'8
  e c h d4. ( d4 ) c8 c h a
  a4. g ( g4 ) a8 a g f e4. ( e )
  r4 c'8 c h a a4. g4 c8 f h, h c4 \bar "|."
}

#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  \partial 8
  c8 e8. e16 e8 e4. c4. ( c4 ) g'8
  g g g g4. ( g4 ) g8 f f f
  d4. d ( d4 ) d8 d4 d8 c4. ( c4 ) e8
  e c c e4. e ( e4) c'8
  g g g g4. ( g4 ) g8 g g d
  d4. d ( d4 ) d8 d d d c4. ( c )
  s4 f8 f f f f4. c4 g'8 h g g e4
}

%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s8 c2. c c4. g:7 g:7 f g2.:9 g4.:9 g:7 c2. c c c4. g:7 g:7
  f g2.:9 g4.:9 g:7 c2. f2. g4.:9 c g:7 c
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Mein Va -- ter ist Berg -- mann, und ich bin sein Sohn,
  mit Kum -- mer und Sor -- gen, so werd ich groß.
  Als Kna -- be, da mußt ich __ mit un -- ter die Erd, __
  da mus -- te ich fah -- ren __ mit Wa -- gen und Pferd, __
  da mus -- te ich fah -- ren mit Wa -- gen und Pferd.
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
        "Text: Volkslied (19. Jhdt)"
        "Melodie: Volksweise (19. Jhdt)"
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
          "Und eines Tages, da hat es gekracht."
          "Ich hörte ein Wimmern tief unten im Schacht."
          "Ich kannte die Stimme, die Hilfe geschrien!"
          "Mein Vater, mein Vater! Da brachten sie ihn."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Von Steinen zerschmettert, lag tot auf der Bahr,"
          "ich denke noch heute, als Beerdigung war."
          "Die Knappen, sie senkten ins Grab ihn hinein,"
          "o welch Kummer, Bergmann zu sein!"
        }
      }
    }

    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}
