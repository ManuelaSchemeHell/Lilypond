%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Drei Lilien
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\pageBreak
myTitel="Drei Lilien"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \partial 4 \key b \major
  b8 [ ( d ) ] f4. g8 f4 es b4. c8 b4 f'
  g f es d c2 r4 \bar "|" b8 [ ( d ) ] f4 f f8 ( [ g ) ]  a8 ( [ b ) ]
  b2 g4 c d2 c b r4 \bar "|" b,8  d
  f8. f16 f8 f f8. f16 f8 f f2 ( d4 ) \breathe d8. f16
  b8. b16 b8 b8 d8. c16 b8 c d2 ( b4 ) \breathe g
  f f f b b2 g4 c b2 a b r4 \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  b4 b4. b8 b4 b b4. c8 b4 b
  es d c b a2 s4 b4 d4 d d4  f4
  g2 es4 es f2 f f s4 b,4 b1 b2 s4
  \once \override NoteColumn.force-hshift = #0.6
  %\shiftOnnn
  d4 d2 f2 f2 s4
  d
  d d d f g2 es4 es f2 f f
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 b1 b es f b es b2 f:7 b1
}
#(define-markup-list-command (rparagraph layout props args) (markup-list?)
   (interpret-markup-list layout props
     (make-justified-lines-markup-list (cons (make-hspace-markup -2) args))))

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
          "Ach Reiter, lieber Reitersmann,"
          "laß doch die Lilien stehn,"
          "die soll ja mein Feinsliebchen"
          "noch lange sehn."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Und sterbe ich noch heute,"
          "so bin ich morgen tot;"
          "dann begraben mich die Leute"
          "ums Morgenrot."
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
  Drei Li -- li -- en, drei Li -- li -- en,
  die pflanzt ich auf mein Grab,
  da kam ein stol -- zer Rei -- ter
  und brach sie ab.
  Ju -- vi -- val -- le -- ral -- le -- ral -- le -- ral -- le -- ra, __
  Ju -- vi -- val -- le -- ral -- le -- ral -- le -- ral -- le -- ra, __
  da kam ein stol -- zer Rei -- ter
  und brach sie ab.
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
       % \new Voice \Struktur
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
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))