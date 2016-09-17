%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Muster
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Die Sonne hoch am Himmelszelt"
%% Voice 1
firstvoice =
\relative c' {
  \key f \major
  \time 3/4 \partial 4
  f4 a2 g4 f2 c4 d2 f4 c2. a'4 a a
  a2 f4 g2. r4 r f a2 g4 f2 c4 d2 f4 c2.
  a'4 a a a2 g4 f2. R2. \bar ".|:"
  \repeat volta 2 {
    c'2. a2 d4
    c2. a f4 f f g2 g4
  }
  \alternative {
    { a2.~ a2 r4 \bar ":|." }
    { f2.~ f2 }
  } \bar "|."
}
%% Voice 2
secondvoice =
\relative c' {
  f4 f2
}
%% Chords
songchords =
\chordmode {
  s4 f2. f b f f f c:7 f
  d:m b c:7 f f c:7 f
  f f f b c:7 f f
}


%% Song Lyrics
firststrophe = \lyricmode {
  \set stanza = #"1. "
  Die Son -- ne hoch am Him -- mels -- zelt,
  al -- les hat Gott ge -- macht,
  die Ster -- ne und die wei -- te Welt,
  al -- les hat Gott ge -- macht.

}

secondstrophe = \lyricmode {
  \set stanza = #"2. "
  Die Blu -- men, Vö -- gel, je -- des Tier,
  al -- les hat Gott ge -- macht,
  er schenk -- te sie zur Freu -- de mir,
  al -- les hat Gott ge -- macht.
  \override LyricText.font-shape = #'upright
  \set stanza = #"1.-3."
  Nie -- mand ist grö -- ßer als un -- ser Herr und Gott!
  Gott!
}

thirdstrophe = \lyricmode {
  \set stanza = #"3. "
  Die Wäl -- der, Flüs -- se und das Meer,
  al -- les hat Gott ge -- macht,
  und da -- rum lo -- ben wir ihn sehr,
  al -- les hat Gott ge -- macht.
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" \firstvoice
        \context SecondVoice="sndvoice" \secondvoice

      >>
      \new Lyrics \lyricsto "melody" \firststrophe
      \new AltLyrics \lyricsto "melody" \secondstrophe
      \new Lyrics \lyricsto "melody" \thirdstrophe
    >>
    \context ChordNames \songchords
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Hermann Bergmann"
        "Melodie: Hartmut Wortmann"
      }
    }
    piece = ""
    opus = ""
  }

}
