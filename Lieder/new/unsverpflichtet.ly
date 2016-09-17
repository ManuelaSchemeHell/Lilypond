%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Uns verpflichtet das Wort
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Uns verpflichtet das Wort"
%% Voice 1
firstvoice =
\relative c' {
  \key g \major
  \time 3/4
  d2 d4 d e fis e2.
  a4 a4. g8 fis2 e4
  g g4. fis8 e2 d4 d2 d4
  d e fis e2. a4 a4. g8 fis2 e d2
  \bar "||"
  d4 d d d e fis e d2
  c4 c c c d e d c2
  h4 h h h c d c h2
  h4 h h d d d cis a2
  a4 c e a, c e d d4. d8
  c4 c4. c8 h2. a
}

%% Voice 2
secondvoice =
\relative c' {
  d2
}
%% Chords
songchords =
\chordmode {
  d2. d a:7 a a g g
  d a:7 a d d d
  d d d a a a
  h h h h h h
  a a d a h a
}


%% Song Lyrics
firststrophe = \lyricmode {
  \set stanza = #"Refrain: "
  Uns ver -- pflich -- tet das Wort,
  ge -- het in Frie -- den, ge -- het in Frie -- den,
  Herr, Du lässt uns nicht fort
  oh -- ne ein Frie -- dens -- wort.
  \set stanza = #"1. "
  Du gabst uns Au -- gen zu se -- hen,
  Oh -- ren, da -- mit wir ver -- ste -- hen,
  Lass uns Dein Wort nicht nur hö -- ren,
  son -- dern den Frie -- den ver -- meh -- ren.

}

secondstrophe = \lyricmode {
  \repeat unfold 28 { \skip 1 }
  \set stanza = #"2. "
  Weil wir nur zö -- gernd ent -- schei -- den,
  meh -- ren sich Un -- recht und Lei -- den.
  Dass wir nicht end -- los be -- ra -- ten,
  hilf uns zu Frie __ _ dens -- ta -- ten.
\override LyricText.font-shape =#'upright
  \set stanza = #"1.-3."
  Du denkst Ge -- dan -- ken des Frie -- dens
  und nicht des Ver -- der -- bens.
}

thirdstrophe = \lyricmode {
  \repeat unfold 28 { \skip 1 }
  \set stanza = #"3. "
  Du willst ja Frie -- den ver -- lei -- hen,
wenn wir ein -- an -- der ver -- zei -- hen,
Doch Du bist taub un -- serem Be -- ten,
wenn wir im Streit vor Dich tre -- ten.
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
        "Text: Herbert Schaal"
        "Melodie: südamerikanische Volksweise"
      }
    }
    piece = ""
    opus = ""
  }

}

