\version "2.19.38"

\layout {
  \context {
    \StaffGroup
    \override SystemStartBracket.stencil = ##f
  }
  \context {
    \Staff
    \consists "Mark_engraver"
    \override RehearsalMark.self-alignment-X = #LEFT
  }
  \context {
    \Score
    \omit SystemStartBar
    \remove "Mark_engraver"
    \override StaffGrouper.staffgroup-staff-spacing.basic-distance = #15
  }
}
\new StaffGroup
<<
  \new Staff="up" \relative c'' { \mark "StaffGroup without connection lines" c d e }
  \new Staff="down" \relative c { \clef bass c d e }
>>
