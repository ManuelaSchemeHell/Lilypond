%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Die lustigen Hammerschmiegsölln
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Die lustigen Hammerschmiegsölln"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  \time 3/4
  \partial 4
  \slurDashed
  g8  g  c4 h c4 g a e f f g h r r f f g h r r
  e, e g c r g8 g c4 h c8 c g4 a e8 e
  f4 f g h r r
  f f g h r r c2 \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  e8 e
  e4 e g4 e e c c h d d s2 d4 d d d s2
  c4 c e g s
  e8 e
  e4 e g8 g8 e e c c h d d s2 d4 d d d s2 < e g >2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 c2. c g:7 g g g c c c c g:7 g:7 g:7 g c
}
%% Text
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "3."
        \column {
          "Blau Montag, blau Dienstag," "das ist uns all's oans,"
          "|: Ist uns all's oans, :|"
          "Wenn ma a Geld hab'n," "tun ma an Rausch hab'n,"
          "Wenn ma an Rausch hab'n, hab'n ma koans,"
          "Rausch ham, hammer koans, koans."
        }
      }
      \vspace #Absatz
      \line {
        \bold "4."
        \column {
          "Gebt's Wein her, gebt's Bier her," "gebt's Holderbeerschnapps,"
          "|: Holderbeerschnapps, :|"
          "Bei uns, da geht's groß her,"
          "Bei uns gibt's nix Knapps,"
          "Da gibts nix Knapps, Knapps."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "5."
        \column {
          "Was ist dös für a lumpige" "Herbergwirtschaft,"
          "|: Herbergwirtschaft, :|"
          "Haun ma d'Stühl z'samm," "haun ma d'Bänk z'samm,"
          "Haun ma all's z'samm mit Kraft,"
          "All's z'samm mit Kraft, Kraft!"
        }
      }
      \vspace #Absatz
      \line {
        \bold "6."
        \column {
          "Drum Hammaschmied, Hammaschmied,"
          "Hammerts nur zua,"
          "|: Hammerts nur zua! :|"
          "Un wamma gnua ghammert ham," "gemma a Ruah,"
          "Gemma a Ruah, Ruah. "
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
  Ja mir san holt die lu -- sti -- gen Ham -- ma -- schmied -- gsölln,
  Ham -- ma -- schmied -- gsölln, Ham -- ma -- schmied -- gsölln,
  kem -- ma da bleib'n, kem -- ma furt gehn,
  kem -- ma toan, was ma wölln,
  toa, was ma wölln, wölln.
}

% Song Lyrics 2. Strophe
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) =
\lyricmode {
  \set stanza = #"2. "
  \set ignoreMelismata = ##t
  San ma schwarz, san ma weiß,
  ja was liegt den da dran,
  liegt den da dran, liegt den da dran,
  so __ _ lang sich a __ _ Ham -- ma -- schmied __ _ o -- wo -- schn kon,
  o -- wo -- schn kon, kon!
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
        "Text: Volkslied aus der Steiermark"
        "Melodie: erzgebirgisches Vugelbärbaamlied "
      }
    }
    piece = ""
    opus = ""
  }

}

%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))