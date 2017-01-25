Tonleiter = \relative c' { c1 d e f g a b }

\score
{
\new Staff {
\override Staff.BarLine.stencil = ##f
\override Score.BarNumber.stencil = ##f
\override Staff.TimeSignature.stencil = ##f
\set Staff.explicitKeySignatureVisibility = #end-of-line-invisible
\override Staff.KeyCancellation.break-visibility = #center-visible
\mark "C-Dur"
\Tonleiter \break
\key g \major
\mark "G-Dur"
\transpose c g \Tonleiter
\break
\mark "D-Dur"
\key d \major
\transpose c d \Tonleiter
}
\layout {
  indent = #0
  ragged-last-bottom = ##t
  ragged-right= ##t
  ragged-last = ##t
ragged-bottom = ##t
}

}
