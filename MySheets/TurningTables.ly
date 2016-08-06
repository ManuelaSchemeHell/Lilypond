\version "2.19.37"
\language "deutsch"
\include "myScheme.ily"

FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))
#(set-global-staff-size 20)

\paper {
  #(set-paper-size "a4")
  myStaffSize = #20
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
  annotate-spacing = ##f
  %left-margin = #15
  %page-count = #4
  top-margin = #10
  ragged-right = ##f
  bottom-margin = #10
  last-bottom-spacing.basic-distance = #10
  #(set-paper-size "a4")
  %left-margin = #15
  line-width = #180
  #(include-special-characters)
}

\layout {
  indent = #15
  ragged-last-bottom = ##t
  ragged-last = ##f
  ragged-bottom = ##f
  line-width = #185
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
    \Staff
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    \consists Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override StaffSymbol.thickness = #0.35 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
    \override TimeSignature.style = #'numbered
  }

  \context {
    \Score
    \remove Bar_number_engraver
    \override NonMusicalPaperColumn.line-break-permission = ##f
    \override NonMusicalPaperColumn.page-break-permission = ##f
    \remove Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override KeyCancellation.break-visibility = #'#(#f #t #t)
    \override TextScript.self-alignment-X = #LEFT
    \override TextScript.staff-padding = #3.5
  }

  \context {
    \Voice
    \override Hairpin.thickness = #2.5
    \override PhrasingSlur.outside-staff-priority = #150
    \override Slur.outside-staff-priority = #150
    \override Script.stencil = #bold-tenuto-script-stencil
  }
}

RH= \relative c' {
  \key es \major
  \time 2/2
  \tempo 4=70
  \clef treble
  \repeat unfold 4 { c8 es c es b' es, b' es, }
  c d c es g es g es c es c es g es g es c es c es as es as es c es c c' b c, es4
  r2 es'4 d8 es~ es4 d8 es~ es4 d8 c~ c1
  r2 es4 es8 es~ es4 c2. r4 r8 c es4 es8 c~ c1~ c
  r2 es8 es d es~ es es f g~ g4 es c1 r2 d4 es8 es~
  es4 c2. r4 r8 es es8. es16 es8 es~ es es f c~ c2~ c1
  < as c >4 es8 < b' d >~ q f < c' es >4
  as8 < d f >4 f,8 \stemUp < c' es > as < b d > f \stemNeutral
  < as c >4 es8 < b' d >~ q f < c' es >4
  as8 < d f >4 f,8 \stemUp < c' es > as < b d > f \stemNeutral
  < as c >4 es8 < b' d >~ q f < c' es >4~
  < c es > < b es, >2 < b d >4~ q1 q2. r8 b \bar "||"
  < es g b >4. < c es g >8~ q2 < es g b >4. < c es g >8~ q2
  < b es g >4 g'8 q8~ q4 f8 < c es as >~
  \time 3/4
  q4 < as c g' > < as c es >
  \time 4/4
  < es' g b >2 < c es g >
  \time 5/4
  < es g b > < c es g >2.
  \time 4/4
  < b es g >4 g'8 q~ q4 f8 < c f as >~
  q4 < as c g' > < as c es >8 < as c f >4 < c es g >8~
  q < es g b >4. es,8 b' < es b' >4
  < c, es g >4. < es g b >8 es2
  < c' es as c >4 < b b' >8 < b es g b >~ q4 < g g' >8 < as c es as >
  < g g' > < f b d f >~ q4 r8 < f f' > q < g g' >
  < c f as >4. < b es g >4~ q8 < es, as c es >4~ q2. < c c' >4
  r4 r8 f' es4 d8 es~ es~ es4. < b es, >2
  < c, g > < es b' > < as c > < es b' > < as es >4. f'8 es4 d8 es~
  es < es b' >~ q2.
}

LH = \relative c {
  \clef bass
  \key es \major
  < c c, >2 b'~ b4. g8 b4. es,8
  as,4. es'8 b'2~ b4. es,8 b'4. es,8
  f,4. c'8 as'2~ as4. c,8 as'4. es8
  < as, as' >4. es'8 as2~ as es4. g,8
  \clef treble
  < c c' > es' c es b' es, b' es, < c c, > es c es b' es, b' es,
  c es c es b' es, b' es,
  < c c, > es c es g es g es < c f, > es c es g es g es
  c es c es g es g es < c as > es c es b' es, b' es,
  c es c as' g c, es g,
  < c c, > es c es g es g es c es c es g es g es
  < as, as, > as c es b' es, b' es,
  c es c es b' es, b' es,
  < c f, > es c es g es g es c es c es g es g es
  < c as > es c es b' es, b' es, c es c as' g c, es g,
  \clef bass
  < as as, >4. q8~ q4 q4~ q8 q4. q4 q
  < f f, >4. q8~ q4 q~ q8 q4. q4 q
  < as as, >4. q8~ q4 q~ q q f < b b,>~ q1~ q1
  < c, c, >8 c g' < g c >~ q c, q c
  < as as, >8 as es' < es as >~ q as, q as
  < es' es, >8 es b' < b es >~ q es, q es
  < f f, >8 f c' < c f >~ q f,,
  < c' c, >8 c g' < g c >~ q c, q c
  < as as, >8 as es' < es as >~ q as, q as < as as, > es
  < es' es, >8 es b' < b es >~ q es, q es
  < f, f, > f c' f c' f, < f c > f,
  < c c' > es' < g es' > < g b > c, g' < g c > c,
  < as as, > as es' as c as es as
  < as as, >4. < g g, >8~ q c4 < b, b, >8
  f' < b d >4 f8 f,4 < b b, >
  < f' f, >8 c' f, < es es, >~ q es, < as as, >4~ q1~ q
  < c c, >8 es c es b' es, b' es,
  c es c es b' es, b' es,
  < as, as, > as c es b' es, b' es, c es c es b' es, b' es,
  < c f, > es c es g es g es
}

AK = \chordmode {
  c:m
}

Struktur= {
  s1 * 4 \break
  s1 * 4 \break
  s1 * 4 \break
  s1 * 4 \break
  s1 * 4 \break
  s1 * 4 \pageBreak
  s1 * 5 \break
  s1 * 6 \break
  s1 * 4 \break
  s1 * 5 \break
  s1 * 4 \break
}

\score
{
  \new PianoStaff \with {
    instrumentName = \markup {
      \center-column {
        \line \large { Piano }
      }
    }
    shortInstrumentName = ""
  }
  <<
    \new Staff="up" \with {
      \consists Bar_number_engraver
      \override BarNumber.break-visibility = #end-of-line-invisible
      \override BarNumber.padding = #0
      \override BarNumber.self-alignment-X = #CENTER
    }
    <<
      \context Voice \RH
      \context Voice \Struktur
      % \context Voice \ghostRH
    >>
    % \context ChordNames \AK
    \new Staff="down" \LH
    % \new Dynamics \Pedal
  >>
  %% Falls erforderlich Zeilenlänge und Einzug ändern

  \midi {
    \context {
      \ChordNames
      \remove "Staff_performer"
    }
    \tempo 2 = 70
  }

  \layout {
  }
}
