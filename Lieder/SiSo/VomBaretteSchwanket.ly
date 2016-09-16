%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Vom Barette schwankt die Feder
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Vom Barette schwankt die Feder"
%% Voice 1
baretteMelody =
\relative c' {
  \key g \major
  \set Timing.beamExceptions = #'()
  d4 d g g h8 ( a ) g ( a ) h4 g
  g4. h8 a ( g ) fis ( g ) a4 a a r e e a a
  c8 ( h ) a ( h ) c4 a
  \slurDashed
  d4( d8 ) e\noBeam d4 c h a g \breathe d \bar "||"
  \slurSolid
  %% why not \repeat volta ...
  \bar ".|:"
  <<
    \context Voice = "voice" {
      \voiceOne
      g2 g
      h4^( a g fis ) e2 e
      %% Here some trickery
      a4-\tweak transparent ##t ^(\( h c) a\)
      h2 h4. h8 h4 c d h c^( d c d ) h2
    }
    \new Voice = "alt" {
      \set Voice.fontSize = #-2
      \voiceTwo
      g4 d g d
      g d
      g( d )
      e h
      e( h ) e
      h e ( fis )
      g2 g4. g8
      g4 a h g
      a( d, e fis) g2
    }
  >>
  \oneVoice r
  \bar ":|."
}

%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  d4 d d d d d d d
  d4. d8 d4 d4 fis4 fis fis s
  e e e e
  a8 ( g ) fis ( g ) a4 fis
  fis4 fis8 a a4 a g d d
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  g1 g g d a:m a:m d g g g e:m a:m g g d:7 g
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
          "Unsre Linke an dem Schwerte,"
          "in der Rechten einen Spieß,"
          "kämpfen wir, so weit die Erde,"
          "bald für das und bald für dies."
          "Ja |: dies und das, Suff und Fraß"
          "muß ein, ja muß ein""Landsknecht haben.:|"
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Ruhm und Beute zu gewinnen,"
          "zieh'n wir mutig in die Schlacht;"
          "einmal müssen wir von hinnen"
          "lustig drum bei Tag und Nacht."
          "Bei |: Nacht und Tag, was er mag,"
          "muß ein, ja muß ein""Landsknecht haben.:|"
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Landsknechtleben, lustig Leben,"
          "in der Schenk' bei Tag und Nacht!"
          "Sitzt ein fader Kerl daneben,"
          "der nicht singt und der nicht lacht."
          "Ja |: schmeißt in raus, reines Haus,"
          "muß ein, ja muß ein""Landsknecht haben! :|"
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "Sollte ich einst liegen bleiben"
          "in der blutdurchtränkten Schlacht,"
          "sollt ihr mir ein Kreuzlein schreiben"
          "über dem tiefen, dunklen Schacht."
          "Mit |: Trommelspiel, Pfeifen viel"
          "sollt ihr mich begraben.:|"
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
baretteLyrics = \lyricmode {
  \set stanza = #"1. "
  Vom Ba -- ret -- te schwankt -- die -- Fe --  der,
  wiegt und biegt -- im -- Win -- de sich.
  Un -- ser Wams von Büf -- fel -- le -- der
  ist   zer -- fetzt von
  Hieb und Stich.
  Ja
  %% Here some trickery
  %% send this to another Lyrics-context
  \context Lyrics = "up" {
    Stich und Hieb __  und ein Lieb __
  }
  \skip 1 muß ein, ja muß ein Lands -- knecht ha --  ben.
}

altLyr = \lyricmode {
  Stich und Hieb und Stich und Hieb __ und ein Lieb __ und ein Lieb __
}

\score
{
  <<
    \new Staff = "leadsheet"

    <<
      \tocItem \markup #myTitel
      \new FirstVoice = "voice" \baretteMelody
      \context SecondVoice="sndvoice"
      {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
    >>
    \new Lyrics = "up" \with {
      alignAboveContext = #"leadsheet"
      % lyrics above a staff should have this override
      \override VerticalAxisGroup.staff-affinity = #DOWN
    }
    \lyricsto "voice" { \repeat unfold 37 \skip 1  }

    \new Lyrics = "down" \lyricsto "voice" \baretteLyrics

    \new Lyrics = "alt" \with { fontSize = #-1 } \lyricsto "alt" \altLyr
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

%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))