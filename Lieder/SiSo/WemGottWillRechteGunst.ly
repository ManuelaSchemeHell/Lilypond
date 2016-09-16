%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Wem Gott will rechte Gunst erweisen
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Wem Gott will rechte Gunst erweisen"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \partial 4 \slurDashed
  c4 e g c8. h16 c8 a g2 e4 g
  f8. e16 f8 d e4 c d2 h'4\rest d,8 ( e )
  f4. f8 e8. e16 f8 g a2 g4 g c8. h16 c8 d e4 d c2 h4\rest \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  \partial 4
  c4 e g a8. g16 a8 f e2 c4 e
  d8. c16 d8 h c4 c h2 s4 h8  c
  d4. d8 c8. c16 d8 e f2 e4 g c8. g16 e8 g c4 g e2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 c2 f c1 g2:7 c g1 g2:7 c f c c4 e:m  c/g g:7 c
}
%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Die Bächlein von den Bergen springen,"
          "die Lerchen schwirren hoch vor Lust;"
          "was sollt ich nicht mit ihnen singen"
          "aus voller Kehl und frischer Brust?"
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Den lieben Gott lass ich nur walten,"
          "der Bächlein, Lerchen, Wald und Feld"
          "und Erd und Himmel will erhalten,"
          "hat auch mein Sach aufs Best bestellt."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}
%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "1\"")) = \lyricmode {
  \set stanza = #"1. "
  Wem Gott will rech -- te Gunst er -- wei -- sen,
  den schickt er in die wei -- te Welt,
  dem will er seine Wun -- der wei -- sen
  in Berg und Tal und Strom und Feld.
}
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Die Trä -- gen, die zu Hau -- se lie -- gen,
  er -- quic -- ket nicht das Mor -- gen -- rot,
  sie wis -- sen nur vom Kin -- der -- wie  -- gen,
  von Sor -- gen, Last und Not um Brot.
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
        #(ly:parser-include-string (string-append "\\\"l" myTitel "1\""))
      }
      \new AltLyrics  \lyricsto "melody" {
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
      \override #'(baseline-skip . 0.6)
      \right-column {
        "Text: Joseph von Eichendorff (1788-1857), 1822"
        "Melodie: Friedrich Theodor Fröhlich (1803-1836 ), 1833"
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))