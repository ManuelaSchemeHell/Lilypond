%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Wir lieben die Stürme
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Wir lieben die Stürme"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key a \major
  \partial 8
  \slurDotted
  e8 e4 a8 h8 cis4 h8. a16 h4 a8. gis16 a4 e8 e
  fis4 a8 fis e4 e4 d e8 d cis4 r8 e
  e4 a8 h cis4 h8. a16 h4 a8. gis16 a4 e8 e fis4 a8 (  fis )  e4
  cis'8. cis16
  cis8 ( h ) a8 gis a4 r
  \bar ".|:"
  \stemDown
  e2 a cis a4 e8 e a e a h cis4 d cis h8 a h4 a8. gis16 a2. r8
  \bar ":|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  \key a \major
  \partial 8
  e8 cis4 cis8 d8 e4 d8. cis16 d4 cis8. d16 a4 cis8 cis
  d4 fis8 d cis4 cis4 h cis8 h a4 s8 cis
  cis4 e8 d fis4 d8. cis16 d4 cis8. h16 cis4 cis8 cis d4 fis8 d cis4
  e8. e16
  a4 fis8 e e4 s
  \stemUp
  cis'2 cis e cis4 e8 e cis cis cis d e4 fis e d8 cis d4 e8. e16 cis2.
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s8 a1 h2:m a d a d:7 a a1
  d2 a d a e:7 a a1 a a a2 e:7 a2
}
%% Text
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Wir treiben die Beute mit fliegenden Segeln,"
          "wir jagen sei weit auf das endlose Meer."
          "Wir stürzen auf Deck, und wir kämpfen wie Löwen,"
          "hei, unser der Sieg, viel Feinde, viel Ehr!"
        }
      }
    }
    \hspace #1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Ja, wir sind Piraten und fahren zu Meere,"
          "wir fürchten nicht Tod und den Teufel dazu,"
          "wir lachen der Feinde und aller Gefahren,"
          "am Grunde des Meeres erst finden wir Ruh."
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
  Wir lie -- ben die Stür -- me, die brau -- sen -- den Wo -- gen,
  der eis -- kal -- ten Win -- de rau -- hes Ge -- sicht.
  Wir sind schon der Mee -- re so vie -- le ge -- zo -- gen,
  und den -- noch sank uns' -- re Fah __ _ ne nicht.
  Hei -- jo, hei -- jo, hei -- jo, hei -- jo, hei -- jo -- ho,
  hei -- jo, hei -- jo -- ho, hei -- jo -- jo!
}

#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Unser Schiff glei -- tet stolz durch die schäu -- men -- den Wo -- gen,
  jetzt strafft der __ _ Wind uns're Se -- gel mit Macht.
  Seht ihr hoch __ _ dro -- ben die Fah -- ne sich wen -- den,
  \set ignoreMelismata = ##t
  die blut -- ro -- te Fah -- ne,
  \set ignoreMelismata = ##f
  ihr See __  leut, habt acht.
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
      \new Lyrics="fstly" \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
      \new AltLyrics="sndly"
      \lyricsto "melody" {
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