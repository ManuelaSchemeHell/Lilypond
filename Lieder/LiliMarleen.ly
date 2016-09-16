%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Lili Marleen
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Lili Marleen"
%% Voice 1
voltaItalicOne = \markup { \text \fontsize #4 "1.-4." }
voltaItalicThree = \markup { \text \fontsize #4 "5." }
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \set Staff.doubleRepeatType = "|"
  \autoBeamOff
  \key c \major
  \stemUp \repeat volta 2 {
    \slurDotted e8 ( e ) e8 f g4 e
    f8. f16 f8 c' h2
    d,8. d16 d8 e f4 f8 g h8. a16 g8. f16 e2 \breathe
    a4 h8. c16 h4 a a g h4. a8
    g4 f a4. g8 f4 e g4. \breathe e8 g4. f8 f4 d'
    c2. e,4 g4. f8 f4 h,
  }
  \alternative {
    {
      \set Score.repeatCommands = #(list (list 'volta voltaItalicOne) 'start-repeat)
      c2 h'2\rest \bar ":|."
    } {
      \set Score.repeatCommands = #(list (list 'volta #f) (list 'volta voltaItalicThree) 'end-repeat)
      c,1
    }
  }
  \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  c8 ( c ) c d e4 c d8. d16 d8 a'
  <<
    {
      %\once \override NoteColumn.force-hshift = #-1
      \stemDown  \override NoteHead.font-size = #smallerNoteHead

      g2
    }
    \\ {
      \stemDown  \override NoteHead.font-size = #smallerNoteHead
      \once \override NoteColumn.force-hshift = #1.5
      h4.
      %\once \override NoteColumn.force-hshift = #-2
      d,8
    }
  >>
  h8. h16 h8 c8 d4 d8 e g8. f16 e8. d16 c2
  f4 g8. a16 g4 f f e g4. f8
  e4 d f4. e8 d4 c e4. c8
  e4. d8 d4 f e2. c4 e4. d8 d4 f e2 s2
  \once \override NoteColumn.force-hshift = #0.2
  e1
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  c g:7 g:7 g f f2 g e:m d:m d:m c g d:m c1 c2 d:m c1 c
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
          "Unsere beide Schatten"
          "sah'n wie einer aus."
          "Dass wir so lieb uns hatten,"
          "das sah gleich man daraus."
          "Und alle Leute soll'n es seh'n,"
          "wenn wir bei der Laterne stehn"
          "|: wie einst, Lili Marleen. :| "
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Schon rief der Posten,"
          "sie blasen Zapfenstreich,"
          "es kann drei Tage kosten,"
          "Kam'rad, ich komme gleich."
          "Da sagten wir auf Wiederseh'n."
          "Wie gerne wollt' ich mit dir geh'n,"
          "|: mit dir, Lili Marleen'. :|"
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Deine Schritte kennt sie,"
          "deinen zieren Gang,"
          "alle Abend brennt sie,"
          "doch mich vergaß sie lang."
          "Und sollte mir ein Leids gescheh'n,"
          "Wer wird bei der Laterne stehn"
          "|: mit dir, Lili Marleen? :| "
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "Aus dem stillen Raume,"
          "aus der Erden Grund"
          "küsst mich wie im Traume"
          "dein verliebter Mund."
          "Wenn sich die späten Nebel drehn,"
          "werd' ich bei der Lanterne stehn"
          "|: wie einst, Lili Marlen'. :| "
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
  \set stanza = #"1. "
  Vor der Ka -- ser -- ne,
  vor dem gros -- sen Tor
  stand ei -- ne La -- ter -- ne
  und steht sie noch da -- vor,
  so woll'n wir da uns wie -- der seh'n
  bei der La -- ter -- ne wolln wir steh'n
  wie einst, Li -- li Mar -- leen,
  wie einst, Li -- li Mar -- leen.
  -leen.
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
        "Text: Hans Leip (1893-1983), 1915"
        "Melodie: Norbert Schultze (1911-2002), 1940"
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))