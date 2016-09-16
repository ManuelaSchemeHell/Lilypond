%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Ich bin ein Bergmann
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Ich bin ein Bergmann"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key f \major
  \partial 4.
  c8 c c a'4. f8 e8. f16 g8 f f4 c r8
  c d c b'4. g8 f8. e16 f8 a g2 r8
  g fis g a4. g8 g f e d d4 c r8
  f e d g4. e16 ( c ) a8 f' e d c2.
  c4 g'4. e8 f4 a g8 ( e ) c4 r c g'4. e8 f4 a g8 ( c ) c4 r8
  c, d e
  \repeat volta 2 {
    \bar ".|:" f4. f8 a g f g a2 r8
    a8 a c c4. b8 a c, a' g
  }
  \alternative { { f2 r8 c8 c d \bar ":|." } { f2 r8 } }
  \bar "|."

}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  c
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4.
  f1 f c:7 c d:m d:m c2 f c1 c2 f c1
  c2 f c1 f f c f f2
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Ich bin ein Berg -- mann, kennt ihr wohl das Zei -- chen,
  des Schlä -- gels und des Ei -- sens sil -- ber Bild?
  Dem al -- le fins -- tern Er -- den -- mäch -- te wei -- chen,
  dem E -- le -- men -- te trot -- zend noch so wild.
  Ob auch in fins -- tern Näch -- ten,
  in e -- wig dunk -- len Schäch -- ten,
  mir nim -- mer strahlt der hel -- le Son -- nen -- schein,
  ich bin ein Berg -- mann, will ein Berg -- mann sein!
  Mir nim -- mer sein!
}

#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Er -- glän -- zet nicht in uns -- rer Gru -- be Dun -- kel,
  dem Au -- ge man -- cher lieb -- lich hel -- le Schein!
  Um -- schwe -- bet nicht mit himm -- li -- schen Ge -- fun -- kel,
  uns lä -- chelnd Freund -- schaft, Lie -- be, Lied und Wein?
  \set ignoreMelismata = ##f

  Sie sind uns treu er -- ge -- ben, sie schmüc -- ken un -- ser Le -- ben,
  sie brin -- gen Licht in ew’ -- ge Nacht hi -- nein,
  ich bin ein Berg -- mann, will ein Berg -- mann sein!
  Sie brin -- gen sein!
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
      \new AltLyrics \lyricsto "melody" {
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
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: „Ich bin ein Preuße“, Bergmannslied"
        "Melodie: Heinrich August Neithardt (1793-1861)"
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
        \bold "3."
        \column {
          "Und wartet nicht in jungfräulicher Schöne,"
          "das holde Liebchen in der Heimat mein?"
          "Ihr schallen freudig unsere Jubeltöne,"
          "ihr woll’n wir freudig diesen Becher weih’n!"
          "Glück Auf! Ihr frohen Brüder!"
          "Es schalle donnernd wieder:"
          "Des Bergmanns Braut muß stets die Schönste sein."
          "Ich bin ein Bergmann, will ein Bergmann sein!"
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Sind wir nicht der Erde liebste Söhne?"
          "Wer sinkt ihr so vertrauend an die Brust?"
          "Wer schaut sie so in ihrer schönsten Schöne?"
          "Wem füllt sie so das Herz mit Freud’ und Lust?"
          "Laßt uns die Becher heben!"
          "Glück Auf dem Bergmannsleben!"
          "Es stimmt da jeder freudig mit uns ein:"
          "Ich bin ein Bergmann, will ein Bergmann sein!"
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}
