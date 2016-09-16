%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Bergvagabunden
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Bergvagabunden"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key g \major \slurDashed
  d8 d4 d8 e4 d h'8 h4 h8 c4 h
  a8 a4 a8 h h ( h ) a g2 r
  \bar ":|."
  c8 c4 c8 d4 c h8 h4 h8 c4 h
  a8 a4 a8 h h4 a8 g4 c h r
  c8 c4 c8 d4 c h8 h4 h8 c4 d
  a8 a4 a8 h h4 a8 g2 r \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  h8 h4 h8 h4 h g'8 g4 g8 g4 g
  fis8 fis4 fis8 g g ( g ) fis d2 s
  g8 g4 g8 g4 g g8 g4 g8 g4 g
  fis8 fis4 fis8 g g4 fis8 d4 g g s
  g8 g4 g8 g4 g g8 g4 g8 g4 g
  fis8 fis4 fis8 g g4 fis8 <d h>2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  g1 g d:7 g c g d:7 g c g d:7 g
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
          "Mit Seil und Haken, alles zu wagen,"
          "hängen wir an der steilen Wand."
          "Herzen erglühen, Edelweiß blühen,"
          "vorbei geht´s mit sicherer Hand."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Fels ist bezwungen, frei atmen Lungen,"
          "ach, wie so schön ist die Welt."
          "Handschlag, ein Lächeln," "Mühen vergessen,"
          "alles aufs Beste bestellt."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Beim Alpenglühen" "heimwärts wir ziehen,"
          "Berge, die leuchten so rot."
          "Wir kommen wieder," "denn wir sind Brüder,"
          "Brüder auf Leben und Tod."
          "Lebt wohl ihr Berge," "sonnige Höhen,"
          "Bergvagabunden sind treu."
        }
      }

    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "a\"")) = \lyricmode {
  Wenn wir er -- klim -- men schwin -- deln -- de Hö -- hen,
  stei -- gen dem Gip -- fel -- kreuz zu,

}
#(ly:parser-include-string (string-append "\"l" myTitel "b\"")) = \lyricmode {
  \set ignoreMelismata = ##t
  brennt ei -- ne Sehn -- sucht in un -- s'ren Her -- zen,
  die lässt uns nim -- mer -- mehr in Ruh'.
}

#(ly:parser-include-string (string-append "\"l" myTitel "c\"")) = \lyricmode {
  %\set stanza = "1.-3"
  Herr -- li -- che Ber -- ge,
  \undropLyrics
  son -- ni -- ge Hö -- hen,
  Berg -- va -- ga -- bun -- den sind wir, ja wir;
  herr -- li -- che Ber -- ge, son -- ni -- ge Hö -- hen,
  Berg -- va -- ga -- bun -- den sind wir.
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
        \leftbrace
        #(ly:parser-include-string (string-append "\\\"l" myTitel "a\""))
        \rightbrace \dropLyrics
        #(ly:parser-include-string (string-append "\\\"l" myTitel "c\""))
      }
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "b\""))
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
        "Text: Erich Hartinger"
        "Melodie: Hans Kolesa"
      }
    }
    piece = ""
    opus = ""
  }

}
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))