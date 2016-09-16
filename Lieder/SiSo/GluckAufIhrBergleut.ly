%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Glück auf, ihr Bergleut
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Glück auf, ihr Bergleut"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key f \major
  \partial 4
  c4 \bar ".|:"
  \repeat volta 2 {
    f f8 ( a ) g4 g8 ( b ) a ( c ) f ( d ) c4. b8
    a4 b8 ( g ) f4 e
  }
  \alternative {
    {
      f2 c4 \bar ":|."
    } { f2 r4 c' }
  }
  c4. a8 d ( c ) b ( a ) g4 g g c
  c4. a8 d ( c ) b ( a ) g4 g g8 ( b ) a ( g )
  f4 f8 ( a ) g4 g8 ( b) a ( c ) f ( d ) c4. b8
  a4 b8 ( g ) f4 e f2 r4 \bar "|."
}

%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  c4
  c c8 ( f ) e4 e8 ( g ) f ( a ) b ( f ) a4. f8
  f4 g8 ( e ) c4 c c2 c4 c2 s4 a'
  a4. f8 b4 f e4 e e g
  a4. f8 b4 f e4 e e4 c
  c4 c4 e4 e f b c4. b8
  a4 b8 ( g ) f4 e f2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 f2 c f4 b f2 f4 c:7 f c f2. f1
  f2 b c1 f2 b c c:7 f c f4 b f2 f4 c:7 f c:7 f
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Glück
  \set stanza = \markup {
    \hspace #-1
    \translate #'(0 . -0.6) \left-brace #25
  }
  <<
    {
      auf, ihr Berg -- leut jung und alt,
      seid frisch und wohl -- ge -- mut! Er --
    }
    \new Lyrics {
      \set associatedVoice = "melody"
      he -- bet eu -- re Stim -- me bald!
      Es wird schon wer -- den
    }
  >>
  gut.
  Gott hat uns einst die Gnad ge -- geb'n,
  daß wir vom ed -- len Berg -- werk leb'n,
  drum singt mit uns der gan -- ze Hauf:
  Glück auf, Glück auf, Glück auf!
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
        "Text: Volkslied (18. Jhdt.)"
        "Melodie: Volksweise (18. Jhdt.)"
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext

\markup {
  \fill-line {
    \hspace #4 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Glück auf! Dem Steiger sei's gebracht,"
          "sein Anbruch werde schön,"
          "daß er den Obern Freude macht,"
          "die es recht gerne sehn,"
          "wenn man ihn'n schöne Erze zeigt,"
          "an Silber und an Bleien reich."
          "Drum ruft mit uns der ganze Hauf:"
          "Glück auf, Glück auf, Glück auf!"
        }
      }
    }
    \hspace #5 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Drum preist das edle Bergwerk hoch,"
          "das uns allhier ernährt."
          "Das b'denk ein jeder Bergmann noch,"
          "wenn er zum Schachte fährt."
          "Und tu ein jeder seinen Fleiß,"
          "und kostet es gleich Müh und Schweiß,"
          "zu suchen neue Gänge auf."
          "Glück auf, Glück auf, Glück auf!"
        }
      }
    }
    \hspace #1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Muster
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%