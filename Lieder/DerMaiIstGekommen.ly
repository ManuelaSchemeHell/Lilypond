%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Der Mai ist gekommen
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

myTitel="Der Mai ist gekommen"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \time 3/4 \partial 4
  c8 (  d  ) e4 e4. f8 a8 (  g  ) g4. e8 g8 f f4 g e2 \bar "|"
  c8 (  d  ) e4 e4. f8 a8 (  g  ) g4. e8 g8 ( f ) f4 g e2 \bar "."
  e8 e d8  ( g  ) g4. g8 fis8  ( a  ) a4. a8
  \set melismaBusyProperties = #'() \unset melismaBusyProperties
  %% melisma: wenn mehrere Noten auf einer Silbe gesungen werden
  d8. ( c16 ) h8.(  a16 )
  \slurDashed
  g8.(  fis16 )
  g2 g8 ( f ) e8. e16 e4. f8
  a4 g4. e8 g8. f16 f4 g e2 \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  \partial 4
  c8  d  c4 c4. c8 f8  e   e4. c8 d8 d d4 < f d> c2
  c8  d  c4 c4. c8 f8  e   e4. c8 d8 d d4 < f d> c2
  e8 e d8   d   d4. d8 d8   fis   fis4. a8 d8.  c16  h8.  a16  g8.  fis16  g2
  g8  f  e8. e16 e4. f8
  a4 g4. e8 g8. f16 f4 g e2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 c2. f4 c2 g2.:7 c c c g:7 c g d d g c
}
%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  %translate #'(0 . 13)
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Frisch auf drum, frisch auf drum im hellen Sonnenstrahl"
          "wohl über die Berge, wohl durch das tiefe Tal."
          "Die Quellen erklingen, die Bäume rauschen all;"
          "mein Herz ist wie ’ne Lerche und stimmet ein mit Schall."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Und abends im Städtlein, da kehr ich durstig ein:"
          "Herr Wirt, eine Kanne, eine Kanne blanken Wein!"
          "Ergreife die Fiedel, du lust’ger Spielmann du,"
          "von meinem Schatz das Liedel, das sing ich dazu."
        }
      }
      \vspace #Absatz
      \line {
        \bold "4."
        \column {
          "Und find ich keine Herberg, so lieg ich zu Nacht"
          "wohl unter blauem Himmel, die Sterne halten Wacht."
          "Im Winde die Linde, die rauscht mich ein gemach,"
          "es küsset in der Frühe das Morgenrot mich wach."
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "O Wandern, o wandern, du freie Burschenlust!"
          "Da weht Gottes Odem so frisch in die Brust,"
          "da singet und jauchzet das Herz zum Himmelszelt:"
          "wie bist du doch so schön, du weite, weite Welt!"
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
  Der Mai ist ge -- kom -- men, die Bäu -- me schla -- gen aus,
  da blei -- be, wer Lust hat, mit Sor -- gen zu -- haus;
  wie die Wol -- ken dort wan -- dern am himm -- li -- schen Zelt,
  so steht auch mir der Sinn in die wei -- te, wei -- te Welt.
}
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Herr Va -- ter, Frau Mut -- ter, dass Gott euch be -- hüt!
  Wer weiß, wo in der Fer -- ne mein Glück mir noch blüht?
  Es gibt so man -- che Stras -- se, die nim -- mer
  \set ignoreMelismata = ##t
  ich marschiert,
  es gibt so man -- chen Wein, den ich nim -- mer noch pro -- biert.
}
\pageBreak
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
        "Text: Emanuel Geibel (1815–1884), 1842"
        "Melodie: Justus Wilhelm Lyra (1822–1882), 1843"
      }
    }
    piece = ""
    opus = ""
  }

}

#(ly:parser-include-string (string-append "\\\"" myTitel "\""))