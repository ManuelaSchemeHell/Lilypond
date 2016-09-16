%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Hoch vom Dachstein an
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Hoch vom Dachstein an"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key d \major
  \time 3/4 \partial 4
  d8 e fis a, fis'4 e8 d e h e4 g8 h
  a e a h g a fis4 r d8 e
  fis a, fis'4 e8 d
  cis8 e  cis'4
  h8 a gis a h cis d gis, a4 r
  a8 ais h g d'4 cis8 h h8. a16 fis4 a8 ais cis8. h16 a8 h g a fis4 r
  a8 ais h g d'4 cis8 h h8. a16 fis'4\fermata
  e8 d cis8. h16 cis8. h16 g8 cis, d2 \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  d8 cis d a d4 cis8 d h g h4 e8 d
  cis cis cis d e cis d4 s  d8 cis
  d a d4 h8 h
  a8  cis  a'4
  gis8 fis e fis gis a h e, cis4 s
  fis8 fis g e h'4 a8 g g8. fis16 d4 fis8 fis a8. g16 fis8 g e fis d4 s
  fis8 fis g d h'4 a8 g g8. fis16 d'4
  cis8 h a8. g16 a8. g16 e8 a, d2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 d2. e:m a:7 d d a:7 e:7 a g d a:7 d g d a:7 d2
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Hoch vom Dach -- stein an, wo der Aar noch haust,
  bis zum Wen -- den -- land am Bett der Sav'
  und vom Alp -- tal an, das die Mürz durch -- braust,
  bis ins Re -- ben -- land im Tal der Drav'.
  \set stanza = #"1.-4."
  Die -- ses schö -- ne Land ist der Stei -- rer Land,
  ist mein lie -- bes teu -- res Hei -- mat -- land,
  die-  -ses schö -- ne Land ist der Stei -- rer Land,
  ist mein lie -- bes, teu -- res Hei -- mat -- land!
}

#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Wo die Gem -- se keck von der Fels -- wand springt
  und der Jä -- ger kühn sein Le -- ben wagt,
  wo die Sen -- ne -- rin fro -- he Jod -- ler singt
  am Ge -- birg, das hoch in Wol -- ken ragt.

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
        "Text: Jakob Dirnböck (1809-1861)"
        "Melodie: Ludwig Karl Seydler (1810-1888)"
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
          "Wo die Kohlenglut und des Hammers Kraft,"
          "starker Hände Fleiß das Eisen zeugt"
          "wo noch Eichen stehn, voll und grün von Saft"
          "die kein Sturmwind je noch hat gebeugt"
        }
      }

    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "10."
        \column {
          "Wo sich lieblich groß eine Stadt erhebt"
          "hart am Atlasband der grünen Mur,"
          "wo ein Geist der Kunst und des Wissens lebt,"
          "dort im hehren Tempel der Natur"
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}
\markup  { Die folgenden Strophen werde nicht mehr gesungen. }
\markup {
  \fill-line {

    \hspace #-2 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "4."
        \column {
          "Wo der Mais und Haid'n" "herbstlich duftend blühn "
          "Und des Obstes Füll' so lachend keimt; "
          "Wo im Unterland süße Trauben glühn, "
          "Deren edles Blut wie Perlen schäumt "
        }
      }
      \vspace #Absatz
      \line {
        \bold "6."
        \column {
          "Wo noch deutsches Wort und Handschlag gilt"
          "Frommer Sinn noch herrscht" "und Tugend währt;"
          "Wo auf Mädchenwang noch das Schamroth spielt"
          "Und die Hausfrau klug den Segen mehrt "
        }
      }
      \vspace #Absatz
      \line {
        \bold "8."
        \column {
          "Wo in jedem Arm die geerbte Kraft"
          "Habsburgs Enkeln blüht voll alter Treu"
          "Für den Kaiser gern jeder sich rafft"
          "Und dann eisern steht in Schlachtenreih'"
        }
      }
    }
    \hspace #0 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "5."
        \column {
          "Wo am Kirchweihfest noch alter Weis'"
          "Sanfter Zither Ton und Hackbrett klingt"
          "Und der wackre Bursch" "rasch und flink im Kreis "
          "Holde Dirnen froh im Tanze schwingt"
        }
      }
      \vspace #Absatz
      \line {
        \bold "7."
        \column {
          "Wo's im schlichten Rock," "wie im Fürstengewand"
          "Edle Männer gibt voll weisem Rath,"
          "Die ein Schitz und Schirm frü das treue Land"
          "Rüstig vorwärts gehn in reger That."
        }
      }
      \vspace #Absatz
      \line {
        \bold "9."
        \column {
          "Wo des Dampfes Kraft nun mit Sturmgewalt "
          "Alles fortbewegt auf eis'ner Bahn "
          "Und sich Fleiss und Müh' zeigen vielgestalt "
          "Und ein neuer Geist als ihr Gespann "
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}