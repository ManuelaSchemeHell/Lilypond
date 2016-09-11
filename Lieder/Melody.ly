smallerNoteHead= #-1.5

"mHoch auf dem gelben Wagen" =
\relative c' {
  \autoBeamOff
  \key f \major
  c4 f8 g b4 c a ( g ) f2 c4 f8 g b4 g f2. r4
  c4 f8 g b4 c a ( g ) f r g4 g g8 [ f ] e f g2. r4
  d4 d8 d g4 g8 a f2 c4 r
  g'4 g8 g c4 g b2 r4 \bar "||" a4
  \repeat volta 2
  {
    d,4 d8 d f4 e8 d c4 ( f8 [ a ] ) c2
    c2 h4 c d2 c4 b
  }
  \alternative { {a2 r4 a } { a2 r2 } }
  \bar "|."
}

"mWiegende Welle" =
\relative c'' {
  \autoBeamOff
  \key g \major
  h4 h8 a g4 g8 e d4 g8 a h4 r
  a4 a8 g fis g a c h2 g4 r
  h4 h8 a \slurDotted g4 ( g8 ) e d4 g8 a h4 r
  a4 a8 g fis g a h g4 r4 r4 r8 g
  e4 g c4. e,8 d4 g h4. g8 fis4. g8 a g a c
  h2 g4 r8 g e e g g c4. e,8
  d d g g h4. g8 fis4. g8 a g a h g2 r
}

"mWir lieben die Stürme1" =
\relative c' {
  \autoBeamOff
  \key a \major
  \partial 8
  e8 e4 a8 h8 cis4 h8. a16 h4 a8. gis16 a4 e8 e
  fis4 a8 fis e4 e4 d e8 d cis4 r8 e
  e4 a8 h cis4 h8. a16 h4 a8. gis16 a4 e8 e fis4 a8 [ fis ] e4 e8. e16
  e4 a8 [ gis ] a4 r
  \bar ".|:"
  \stemDown
  e2 a cis a4 e8 e a e a h cis4 d cis h8 a h4 a8. gis16 a2. r8
  \bar ":|."
}

"mWir lieben die Stürme2" =
\relative c'' {
  \autoBeamOff
  \key a \major
  \partial 8 s8 s1 * 8
  \stemUp \override NoteHead.font-size = #smallerNoteHead
  cis2cis e cis4 e8 e cis cis cis d e4 fis e d8 cis d4 e8. e16 cis2.

}

"mDie grauen Nebel" =
\relative c' {
  \autoBeamOff
  \key g \major
  \partial 2
  r8 d8 g a h4 h h8 a g h d4 d2 c8 h a4 a a8 c h a g2 r8
  d8 g a h4 h h8 a g h d4 d2 c8 h a4 a a8 c h a g2 r2
  h2 h h4 c d2 a4 a8 h c4 a h e d2
  d4 e d r h2 h h4 c d2
  a4 a8 c h4 a g2
}


"mWir ziehen über die Straßen1" =
\relative c' {
  \autoBeamOff
  \key g \major
  \partial 4
  d4 g4. fis8 g4 a8 a h2 g4 r8 h
  a4. g8 fis4 a g2. \breathe
  \stemUp
  d4 h'4. a8 h4 c d2 h4. d8
  c4. h8 a4 c h2. h4\rest \bar "||" \bar ".|:"
  \repeat volta 2 { h2 h d h4 d c4. h8 a4. c8 }
  \alternative { { h8 a h c d4 h4\rest \bar ":|." } { h2 h4\rest } }
  \bar "|."
}

"mWir ziehen über die Straßen2" =
\relative c' {
  \autoBeamOff
  \key g \major
  \partial 4
  s4 s1 * 3 s2.
  \stemDown  \override NoteHead.font-size = #smallerNoteHead
  d4 g4. fis8 g4 a h2 g4. h8 a4. g8 fis4 a g2. s4
  < g d >2 q < g h > < g d >4 < g h > < a d, >4. < g d >8
  < fis d >4. < a d, >8 < g g>8 < g fis > < g g> < g a > < g h >4 s < g g >2
}

voltaItalicOne = \markup { \text \fontsize #4 "1.-4." }
voltaItalicThree = \markup { \text \fontsize #4 "5." }
"mLili Marleen1" =
\relative c' {
  \set Staff.doubleRepeatType = "|"
  \autoBeamOff
  \key c \major
  \stemUp \repeat volta 2 {
    \slurDotted e8 ( e ) e8 f g4 e
    f8. f16 f8 c' h2
    d,8. d16 d8 e f4 f8 g h8. a16 f8. f16 e2 \breathe
    a4 h8. c16 h4 a a g h4. a8
    g4 f a4. g8 f4 e g4. \breathe e8 g4. f8 f4 d'
    c2. e,4 g4. f8 f4 h,
  }
  \alternative {
    {
      \set Score.repeatCommands = #(list (list 'volta voltaItalicOne) 'start-repeat)
      c2 h'2\rest \bar ":|."
    } {
      \set Score.repeatCommands = #(list (list 'volta #f) (list 'volta voltaItalicThree) 'end-repeat)
      c,1
    }
  }
  \bar "|."
}

"mLili Marleen2" =
\relative c' {
  \autoBeamOff
  \key c \major
  \stemDown
  \override NoteHead.font-size = #smallerNoteHead
  \override Flag.font-size = #smallerNoteHead
  % \override Stem.length = #(magstep smallerNoteHead)
  \slurDotted c8 ( c ) c d e4 c d8. d16 d8 a'
  <<
    { \stemDown  \override NoteHead.font-size = #smallerNoteHead g2 }
    \\ {
      \stemDown  \override NoteHead.font-size = #smallerNoteHead
      \override Flag.font-size = #smallerNoteHead
      \once \override NoteColumn.force-hshift = #1
      h4.
      \once \override NoteColumn.force-hshift = #-1
      d,8
    }
  >>
  h8. h16 h8 c8 d4 d8 e g8. f16 e8. d16 c2
  f4 g8. a16 g4 f f e g4. f8
  e4 d f4. e8 d4 c e4. c8
  e4. d8 d4 f e2. c4 e4. d8 d4 f e2 s2
  \once \override NoteColumn.force-hshift = #0.2
  e1
}

"mVom Barette schwankt die Feder1" =
\relative c' {
  \autoBeamOff
  \key g \major

  \set Voice.baseMoment = #(ly:make-moment 1/8)
  \set Voice.beatStructure = #'(2 2 2 2 )  %% abhÃ¤ngig vom Takt
  \autoBeamOn
  d4 d g g h8  a g a h4 g
  g4. h8 a g fis g a4 a a r e e a a
  c8 h a h c4 a
  \slurDotted \slurDashed
  d4 ( d8 ) e\noBeam d4 c h a g \breathe d \bar "||"
  \slurSolid
  g2 g h4 ( a g fis ) e2 e
}

"mVom Barette schwankt die Feder2" =
\relative c'' {
  \autoBeamOff
  \key g \major
  \stemDown
  \override NoteHead.font-size = #smallerNoteHead
  \override Flag.font-size = #smallerNoteHead
  s1 * 8 g4 d g d
}

"mMusterLied" =
\relative c' {
  \autoBeamOff
  \key f \major
}

"mMusterLied" =
\relative c' {
  \autoBeamOff
  \key f \major
}

"mMusterLied" =
\relative c' {
  \autoBeamOff
  \key f \major
}

"mMusterLied" =
\relative c' {
  \autoBeamOff
  \key f \major
}
