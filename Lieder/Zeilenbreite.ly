\paper {
  #(set-paper-size "a4")
  indent = #0
  ragged-right = ##f
 line-width = 120\mm

 % check-consistency = ##t
}
\score {
  \relative c'' { \repeat unfold 40 c4 }
  \layout {
    line-width = 150\mm
    short-indent = -15\mm
    indent = -15\mm
    ragged-right = ##f
  }
}
\markup 
\line \override #'(line-width . 30)
{ \fill-with-pattern #1 #RIGHT . 30 right }
\markup  \line
{ \override #'(line-width . 50)
\fill-with-pattern #1 #RIGHT . 50 right
}
