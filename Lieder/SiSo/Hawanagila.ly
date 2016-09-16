%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Hava nagila
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Hava nagila"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key b \major
  d2 d2 r4 fis es d fis2 fis r4 a g fis g2 g2
  r4 b a g fis2 es4 d8 ( es ) d1 \bar ":..:"
  < d fis >4 q2 es4 d d d2 < c es >4 q2 d4 c c c2
  c2 es4. d8 c4 c g'2 fis es4 es d1 \bar ":|."
  g1 g1 g2 g g g
  g4 g b4. a8 g4 b a g g g b4. a8 g4 b a g
  a a c4. b8 a4 c b a a a c4. b8 a4 c b a
  a a d2 ( d1 ) a4 a d2 ( d1 )
  d,2 d4. d8 b'4 ( a g fis )
  \slurShifts #'(0 . 0) #'(5 . 1)
  g1 ( g'4 ) r4 r2 \bar "|."
}

%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  d1:7 d:7 d:7 d:7
  g:m g:m d2:7 c:m d1:7
  d:7 d:7 c:m c:m c:m c:m d2:7 c:m d1:7
  \repeat unfold 8 g:m
  \repeat unfold 10 d:7
  g:m
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {

  Ha -- va na -- gi -- la, ha -- va na -- gi -- la
  ha -- va na -- gi -- la we -- nis -- me -- chah!
  Ha -- va ne -- ra -- ne -- na, ha -- va ne -- ra -- ne -- na
  Ha -- va ne -- ra -- ne -- na we -- nis -- me -- chah.
  U -- ru, U -- ru a -- chim
  Ur' a -- chim be -- lew sa me -- a
  ur' a -- chim be -- lew sa me -- a
  ur' a -- chim be -- lew sa me -- a
  ur' a -- chim be -- lew sa me -- a
  ur' a -- chim ur' a -- chim be -- lew sa me -- a
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context Voice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
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
        "Text: Volkslied"
        "Melodie: Volksweise aus Israel"
      }
    }
    piece = ""
    opus = ""
  }
}

\markup {
  \fill-line {
    \hspace #2 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold  "Deutsche Übersetzung:"
        \column {
          "Lasst uns glücklich sein"
          "Lasst uns glücklich und fröhlich sein"
          "Lasst uns singen und fröhlich sein"
          \vspace #Absatz
          "Erwachet, erwachet Brüder!"
          "Erwachet Brüder, mit einem glücklichen Herzen."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}