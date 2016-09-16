%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Gaudeamus igitur
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Gaudeamus igitur"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  \time 3/4 \key b \major
  b8. f16 f4 b g8. g16 g4 h4\rest a8. b16 c4 a b8 [ d ] b4 h4\rest
  \bar ":|."
  a8. b16 c4 c d8 b c4 c a8. b16 c4 c d8 b c4 c

  b8. a16 g8 [ es' ] d [ c ] b4 ( c ) d
  b8. a16 g8 [ es' ] d [ c ] f4 ( a, ) b\fermata   \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  d8. d16 d4 f es8.
  \once \override NoteColumn.force-hshift =#0.4
  f16 es4 s4 es8. es16 es4 es d8 [ f ] d4 s4
  f8. f16 f4 f f8 f f4 f f8. f16 f4 f c8 g' a8 [ g ] f4
  f8. f16 es8 ( g4 ) g8 f2 f4
  f8. f16 es8 ( g4 ) g8 f4 ( es ) d
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  b2. es f b f b4 f2 f2. b4 f2 b4 es2 f2 g4:m es2. f2 b2
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
          "Ubi sunt qui ante nos"
          "in mundo fuere?"
          "Vadite ad superos"
          "transite ad inferos"
          "ubi iam fuere."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Vita nostra brevis est,"
          "brevi finietur,"
          "venit mors velociter,"
          "rapit nos atrociter"
          "nemini parcetur!"
        }
      }
      \vspace #Absatz
      \line {
        \bold "4."
        \column {
          "Vivat academia,"
          "vivant professores!"
          "Vivat membrum quodlibet,"
          "vivant membra quaelibet,"
          "semper sint in flore! "
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "Vivat et res publica,"
          "et qui illam regit!"
          "Vivat nostra civitas,"
          "maecenatum caritas,"
          "quae nos hic protegit!"
        }
      }
      \vspace #Absatz
      \line {
        \bold "6."
        \column {
          "Pereat tristitia"
          "pereant osores"
          "pereat diabolus"
          "quivis antiburschius"
          "atque irrisores "
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold " "
        \column {
          "Sagt mir doch, wo trifft man an,"
          "die vor uns gewesen?"
          "Schwingt euch auf zur Sternenbahn,"
          "geht hinab zu Charons Kahn,"
          "wo sie längst gewesen!"
        }
      }
      \vspace #Absatz
      \line {
        \bold " "
        \column {
          "Kurz ist unsre Lebenszeit,"
          "sie vergeht geschwinde;"
          "unter Sorgen, Müh’ und Streit"
          "schwindet Jugend-Fröhlichkeit,"
          "wie der Rauch vom Winde."
        }
      }
      \vspace #Absatz
      \line {
        \bold " "
        \column {
          "Blüh’, du edler Musenthron,"
          "blühet auch, ihr Lehrer!"
          "Jedem braven Musensohn"
          "werde Ehr’ und Glück zum Lohn,"
          "ihm, der Weisheit Hörer!"
        }
      }
      \vspace #Absatz
      \line {
        \bold " "
        \column {
          "Staat und Städtchen sei beglückt,"
          "auch der Landesvater!"
          "Vivat wer uns Nummos schickt,"
          "wenn die Schuldenlast uns drückt,"
          "vivat Freund und Rather!"
        }
      }
      \vspace #Absatz
      \line {
        \bold " "
        \column {
          "Gram und Sorgen, fliehet jetzt!"
          "Sterbet, Burschenfeinde!"
          "Mag verderben, wer uns verpetzt,"
          "uns belächelt und verhetzt"
          "mit dem besten Freunde!"
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
  Gau -- de -- a -- mus i -- gi -- tur,
  ju -- ve -- nes dum su -- mus,
  post iu -- cun -- dam iu -- ven -- tu -- tem,
  post mo -- les -- tam se -- nec -- tu -- tem
  nos ha -- be __ bit __ hu __ mus,
  nos ha -- be __ bit __ hu __ mus.
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  U -- bi sunt, qui an -- te nos
  in mun -- do fu -- e -- re?
  Va -- di -- te ad su -- pe -- ros,
  tran -- si -- te ad in -- fe -- ros,
  u -- bi iam fu -- e -- re.
}
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"1. "  {
    Laßt uns, weil wir jung noch sind,
    uns des Le -- bens freu -- en!
    Denn wir kom -- men doch ge -- schwind _
    wie ein Pfeil durch Luft und Wind _
    zu der Tod -- ten Rei -- hen,
    zu der Tod -- ten Rei -- hen.
  }
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
      \new Lyrics \with {
        % alignBelowContext = "leadsheet"
      } \lyricsto "melody" {
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
        "Text: Christian Wilhelm Kindleben (1748-1786), Halle 1781"
        "Deutscher Text: Johann Christian Günther (1695-1723), 1717"
        "Melodie: Studentenlied, ursprünglich mittelalterliches Bußlied, 1788"
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))