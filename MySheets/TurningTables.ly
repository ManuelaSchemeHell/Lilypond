\version "2.19.37"
\language "deutsch"

\include "myScheme.ily"
%\include "Papier+Layout.ly"
#(set-global-staff-size 20)

\header {

  composer  =  \markup  {
    \right-column {
      %\once \override TextScript.extra-offset = #'( 0 . 0.5)
      %\draw-circle #0.5 #0.3 ##f
      \line { Words and Music by Adele Adkins }
      \line { and Ryan Tedder }
    }
  }
  title    = \markup \fontsize #0 { "Turning Tables" }
  subtitle = \markup \fontsize #0.9 { "" }
  %piece      =  "Moderade Ballad"
  poet = "Moderade Ballad"
}

%% wenn erforderlich linken Abstand ändern
\paper {
  #(set-paper-size "a4")
  myStaffSize = #20
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
  annotate-spacing = ##f
  %left-margin = #15
  line-width = #180

  %page-count = #4
  top-margin = #10
  ragged-last-bottom = ##f
  ragged-right = ##f
  bottom-margin = #10
  last-bottom-spacing.basic-distance = #10
  #(include-special-characters)
}

\layout {
  indent = #15
  ragged-last = ##f
  ragged-bottom = ##f
  %line-width = #180

  \context {
    \Staff
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
  }
  \context {
    \ChordNames
    chordNameLowercaseMinor = ##f
    chordRootNamer = #germanChords
    chordNoteNamer = #note-name->german-markup
    chordNameExceptions = #chExceptions
    %"Tahoma"
    %"Luxi Mono"
    %"Nimbus Sans,Nimbus Sans L"
    %"DejaVu Serif"
    %"ArnoldBoeD"
    %"Verdana"
    %%"Lucida Sans Unicode"
    %"Georgia"
    %"Gentium Book Basic"
    % "Constantia"
    %%"Palatino Linotype"
    %%"Consolas"
    %%"Arrus Blk BT"
    %"Trebuchet MS" %%""
    %"Nimbus Sans,Nimbus Sans L"
    %"Luxi Mono"
    \override ChordName.font-name = #"Monospace821 BT"
    \override ChordName.font-name = #"Trebuchet MS"
    \override ChordName.font-name = #"Consolas"
    \override ChordName.font-name = #"Constantia"
    \override ChordName.font-name = #"Candara"
    %\override ChordName.font-name = #"Amerigo BT"
    %\override ChordName.font-name = #"AmeriGarmnd BT"
    %\override ChordName.font-name = #"Comic Sans MS"
    %\override ChordName.font-name = #"Verdana"
    %\override ChordName.font-name = #"Georgia"
    %\override ChordName.font-name = #"Gentium Book Basic"
    %\override ChordName.font-name = #"Lucida Sans Unicode" %% !!
    %\override ChordName.font-name = #"Nimbus Sans"
    %\override ChordName.font-name = #"Palatino Linotype" %% !!
    \override ChordName.font-name = #"Hobo BT" %% ausgefallen, vll. ganz nett!
    %\override ChordName.font-name = #"DejaVu Sans"
    %\override ChordName.font-name = #"Corbel"
    %\override ChordName.font-name = #"Calibri"
    %\override ChordName.font-name = #"Arial"
    %\override ChordName.font-name = #"Arimo"
    %\override ChordName.font-name = #"Gautami"  %% !!
    \override ChordName.font-name = #"Candara"
    \override ChordName.font-name = #"Tahoma"
    %\override ChordName.font-name = #"Iskoola Pota" %% interessant, muss vergrößert werden
    %\override ChordName.font-name = #"LettrGoth12 BT" %% zu eng
    %\override ChordName.font-name = #"Flareserif821 BT" %% interessant
    %\override ChordName.font-name = #"Euphemia" %% wirkt schlank & elegant
    %\override ChordName.font-name = #"Ebrima" %% zu dünn!
    \override ChordName.font-name = #"Myanmar Text" %% m zu breit
    \override ChordName.font-name = #"Tahoma"
    \override ChordName.font-name = #"Tahoma"
    \override ChordName.font-name = #"Tahoma"
    \override ChordName.font-name = #"Tahoma"
    %\override ChordName.font-name = #"Vani" %% geht auch
    %\override ChordName.font-name = #"Oranda BT" % klein, ausgefallen, nicht schlecht
    %\override ChordName.font-name = #"Narkisim" %% eckig, auch überlegenswert
    \override ChordName.font-name = #"Orator10 BT" %% groß und schlank, wirkt modern; definitiv interessant
    %\override ChordName.font-name = #"Tahoma" %% auch möglich
    %\override ChordName.font-name = #"Verdana" %% zu fad
    \override ChordName.font-size = #1.6
    \override ChordName.font-series = #'bold %medium, bold, bold-narrow
    %\override ChordName.font-series = #'narrow %medium, bold, bold-narrow
    %\override ChordName.font-shape =#'italic %upright, italic, caps
  }
  \context {
    \Score
    %\remove Bar_number_engraver
    \override BarNumber.break-visibility = #end-of-line-invisible
    \override BarNumber.padding = #0
    %\override BarNumber.break-visibility = #end-of-line-invisible
    \override BarNumber.self-alignment-X = #CENTER
    \override NonMusicalPaperColumn.line-break-permission = #'allow
    \override NonMusicalPaperColumn.page-break-permission = #'allow
    \override RehearsalMark.self-alignment-X = #LEFT
    \override StaffSymbol.thickness = #0.3 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
  }
  \context {
    \Voice
    \override Hairpin.thickness = #2.5
    \override PhrasingSlur.outside-staff-priority = #150
    \override Slur.outside-staff-priority = #150
    \override Script.stencil = #bold-tenuto-script-stencil
  }
}
AK = \chordmode {
  \set chordChanges = ##f
  c1:m7 as:7 f:m9 as
  c1:m7 as:7 f:m9 as
  c1:m7 as:7 f:m9 as
}

global = {
  \key es \major
  \numericTimeSignature
  \time 4/4
}

lmy={ c4 c c8. c16 c8. c16 }
lny={ c8. c16 c4 }
loy={ c8. c16~ c8 c~ c4 c }
rmy={ c8. c16 c8 c8 c16 c8. c8 c }
rny={ c8. c16 c c c c }
TaktIr= { c16 es c es b' es, b' es, }
TaktIl= { c4 b' c,8. g'16 b8. es,16 }

right = \relative c' {
  \global
  \tempo "moderat" 4 = 70
  \repeat unfold 4 { \TaktIr }
  c es c es g es g es c es c es g es g es
  c es c es as es as es c es c as' g c, es c
  c es c8 es d16 es~ es8 d16 es~ es8 d16 c~
  c4 b'16 es, b' es, c es c8 es es16 es~
  es8 c g'16 es g es c16 es8 c16 es8 es16 c~
  c4 r r2
  c16 es c8 es16 es d es~ es es f g~ g8 es
  c4 b'16 es, b' es, c es c es d8 es16 es~
  es8 c g'16 es g es c es c es \tuplet 3/2 { es8 es es~ }
  es16 es f c as' es as es c es c as' g c, es c
  \changePitch \rmy {
    < es, as c > < f~ as~ d~ > < f as d > < g~ as~ es'~ > < g as es' > < as c f > < as c es > d
    < f, as c > < g~ as~ d~ > q < as~ c~ es~ > q < as c f > < as c es > < as c d >
    < es as c > < es~ as~ d~ > q < es~ as~ es'~ >
  }
  q8 < es as b >4 < f~ b~ d~ >8 q2.~ q8. es'16
  \changePitch \rny {
    < c es b' > < c~ es~ g~ > q c es c
    < c es b' > < c~ es~ g~ > q c es c
  }
  < b es g >8 g'16 < b, es g >~ q8 f'16 < c es as>~ q8 < c es g> < c es > < c es b' >~
  q < c es g >4 < c es b' >8~ q8 < c es g >4.
  < b es g>8 g'16 < b, es g >16~ q8 f'16 < c es as >~ q8 < c es g > < c es>16 f8 < c es g>16~
  q8 < c es b'>~ q16 q8.
  \tuplet 3/2 { <es' g>8[ < d f > < c es >] }
  \tuplet 3/2 { < as c >[ < g b > < f as>] }
  < es as c>8 b'16 < es, g b>~q8 g16 < b, es g>~ q < b d f >8.~ q16 es f g
  \time 2/4
  < c, f as >8. < b es g>16~ q8
  <<
    {
      < es>~ \time 4/4
      es2~ es8. es16 es8 d16 es_~ es es c es
    } \\
    {
      \stemUp
      \once \omit Flag
      < as, c >8~
      < as c >1
    }

  >>
  b'16 es, b' es, c es c es b' es, b' es,
  \override Score.RehearsalMark.self-alignment-X = #CENTER
  %\once \override Score.RehearsalMark.extra-offset = #'( -5 . 0 )
  \mark \markup {
    \center-column {
      \line {  \fontsize #0.7 "To Coda" \musicglyph #"scripts.coda" }
      % \line { \musicglyph #"scripts.coda" }
    }
  }
  c es c es b' es, b' es, c es c es c8 d16 es~
  es es c es g es g es c es c es g es g es
  c es c es as es as es c es c as' g c, es c
  c es c8 es d16 es~ es8 d16 es es8 d16 es~
  es8 c16 es b' es, b' es, c8 es16 f as g f es~
  es4 es16 es d es~ es8 es16 g~ g8 es16 c~
  c es c es as es as es c es c as' g c, es c
  c es c es g g g < c, es g >~ q8 g'16 < c, es b'>~ q4~
  q16 g' < c, es as> g' < c, f>16 es8. c16 es c es es f g < c, es b'>~
  q8 es16 < c f >~ q8 < c es g >16 f < c es > c8. r16 < c es g >8 q16~
  \override Score.RehearsalMark.self-alignment-X = #RIGHT
  q4~ q16 f g f < c es >8 c16 as' g c, es c
  \allgShift #'( 0 . 4) Score RehearsalMark
  \mark \markup {   "D.S. al Coda" }
}

RCoda= \relative c' {
  \break
  \override Score.RehearsalMark.self-alignment-X = #LEFT
  %\once \override Score.RehearsalMark.extra-offset = #'( -5 . 0 )
  \mark \markup {
    \center-column {
      \line { \bold \fontsize #0.7 "Coda" }
      \line { \musicglyph #"scripts.coda" }
    }
  }
  c16 es c es b' es, b' es, c es c es b' as g as
  g16 f es8 g16 es g es c es c es g es g es
  c es c es as es as es c es c as' g c, es c
}

left = \relative c {
  \global
  \set Timing.beamExceptions = #'()
  \set Timing.baseMoment = #(ly:make-moment 1/4)
  \set Staff.beatStructure = #'(2 2 ) % abhängig vom Takt
  \repeat unfold 3
  {
    \changePitch \lmy { c b' c, g' b es, }
    \changePitch \lny
    {
      as, es' b' as, es' b'
      f, c' as' f, c' as'
      as, es' as
    }
    as,2
  }
  \set Staff.beatStructure = #'(1 1 1 1 ) % abhängig vom Takt

  \changePitch \loy {
    as as as as as as
    f f f f f f
    as as as as
  }
  as4. b8~ b1
  c2 as es f4. c'8 ~
  c4. as8~ as2
  es2 f c' as
  as8. g16~ g8. b16~ b b8.~ b4
  f8. es16~ es8 as~ as1
  \repeat unfold 3 {
    \changePitch \lmy { c b' c, g' b es, }
    \changePitch \lny
    {
      as, es' b' as, es' b'
      f, c' as' f, c' as'
      as, es' as
    }
    as,2
  }

}

\score {
  \new PianoStaff \with {
    \once \override InstrumentName.font-name = #"Orator10 BT"
    instrumentName = "Piano"

    shortInstrumentName = ""
  } <<
    \new Staff = "right"
    <<

      \context ChordNames \AK
      \context Voice \right
    >>
    \new Staff = "left" { \clef bass \left }
  >>
  \layout { }

  \midi {
    \context {
      \ChordNames
      \remove "Staff_performer"
    }
    \tempo 4 = 70
  }
}
