%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Unser Leben sei ein Fest
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Unser Leben sei ein Fest"
%% Voice 1
firstvoice =
\relative c' {
  \key g \major
  \partial 4
  d8 d g4 h r a8 h c4 r2 c8 h
  a4 a8 a4 g8 a4 h h r
  h8 a g4 g8 g4 fis8 g4 a a r
  a8 g fis4 fis8 fis4 e8 fis4
  g h r d,8 d g4 h r
  a8 h c4 r r8 c c h
  a4 a8 a g fis4 g8~ g4 r2 \bar "|."
}
%% Voice 2
secondvoice =
\relative c' {
  d8
}
%% Chords
songchords =
\chordmode {
  s4 g1 c d:7 g e:m a:m d:7 g g c d:7 g
}


%% Song Lyrics
firststrophe = \lyricmode {
  \set stanza = #"1. "
  Un -- ser Le -- ben sei ein Fest,
  Je -- su Geist in un -- ser -- er Mit -- te,
  Je -- su Werk in un -- ser -- en Hän -- den,
  Je -- su Geist in un -- ser -- en Wer -- ken.
  Un -- ser Le -- ben sei ein Fest,
  an die -- sem A -- bend und je -- den Tag.
}

secondstrophe = \lyricmode {
  \set stanza = #"2. "
  Un -- ser Le -- ben sei ein Fest,
  Je -- su Hand auf unserem Le -- ben,
  Je -- su Licht auf un -- se -- ren We -- gen,
  Je -- su Wort als Quell un -- ser -- er Freu -- de.
  Un -- ser Le -- ben sei ein Fest,
  an die -- sem Mor -- gen und je -- den Tag.
}

thirdstrophe = \lyricmode {
  \set stanza = #"3. "
  Un -- ser Le -- ben sei ein Fest,
  Je -- su Kraft als Grund uns -- rer Hoff -- nung,
  Je -- su Brot als Mahl der Ge -- mein -- schaft,
  Je -- su Wein als Trank neu -- en Le -- bens.
  Un -- ser Le -- ben sei ein Fest,
  in die -- ser Stun -- de und je -- den Tag.
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
        "Text: Volkslied"
        "Melodie: Volksweise"
      }
    }
    piece = ""
    opus = ""
  }

}
