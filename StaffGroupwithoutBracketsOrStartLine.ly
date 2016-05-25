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
    \override SystemStartBrace.style = #'bar-line
    \omit SystemStartBar
    \override SystemStartBrace.padding = #-0.1
    \override SystemStartBrace.thickness = #1.6
    \remove "Mark_engraver"
    \override StaffGrouper.staffgroup-staff-spacing.basic-distance = #15
  }
}
\new StaffGroup
<<
  \new Staff="up" \relative c'' { \mark "StaffGroup without connection lines" c d e }
  \new Staff="down" \relative c { \clef bass c d e }
>>
