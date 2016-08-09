\language "deutsch"

\version "2.19.37"
% automatically converted by musicxml2ly from D:/Noten/Adele/bal4#.xml

\header {
  composer            =       \markup {  "M: Paul de Senneville, Olivier Toussaint" }
  title               =       "Ballade pour Adeline" %"50 Melodische Übungsstücke"
  % piece               =       \markup { "Op:" \number \tiny 840 "Etüde" \number \tiny \exercise }
}

\include "myScheme.ily"
%\include "Papier+Layout.ly"
\include "ghostvoice.ily"

\paper {
  #(set-paper-size "a4")
  myStaffSize = #20
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
  annotate-spacing = ##f
  left-margin = #15

  %page-count = #4
  top-margin = #10
  ragged-right = ##f
  bottom-margin = #10
  last-bottom-spacing.basic-distance = #10
  #(include-special-characters)
}

\layout {
  indent = #15
  ragged-last-bottom = ##t
  ragged-last = ##f
  ragged-bottom = ##f
  line-width = #180

  \context {
    \Staff
    %\omit ClefModifier
    %\override Clef.break-visibility = #'#(#f #t #t)
    %\consists "Bar_number_engraver"
    %\override BarNumber.padding = #0
    % \override BarNumber.self-alignment-X = #CENTER
    % \override BarNumber.break-visibility = #end-of-line-invisible
    %\override Slur.outside-staff-priority = #150
    % \override OttavaBracket.outside-staff-priority = #1000
    % \override TextScript.outside-staff-priority = #100
    %\override OttavaBracket.outside-staff-priority = #'()
    %\override OttavaBracket.Y-offset = #0
    %\override OttavaBracket.extra-offset = #'(0 . 8)
    %\override OttavaBracket.padding = #5
    %\override OttavaBracket.staff-padding = #6
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    \consists Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    %\override StaffSymbol.thickness = #0.5 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
    %\override Hairpin.thickness = #2
    % \override BarLine.hair-thickness =1.6 %1.9*staff-line thickness  Thickness of the thin line in a bar line.
    %\override BarLine.thick-thickness = 5 %6*staff-line thickness Bar line thickness, measured in line-thickness
  }

  \context {
    \Score
    %\remove "Bar_number_engraver" % Taktnummerierung
    %\override BarNumber.break-visibility = #'#(#f #f #f)
    \remove Bar_number_engraver
    %\override BarNumber.break-visibility = #end-of-line-invisible
    %\override BarNumber.padding = #0
    %\override BarNumber.break-visibility = #end-of-line-invisible
    %\override BarNumber.self-alignment-X = #CENTER
    \override NonMusicalPaperColumn.line-break-permission = ##f
    \override NonMusicalPaperColumn.page-break-permission = ##f
    \remove Mark_engraver
    %\override Hairpin.thickness = #2
    \override RehearsalMark.self-alignment-X = #LEFT
    \override KeyCancellation.break-visibility = #'#(#f #t #t)
    \override TextScript.self-alignment-X = #LEFT
    \override TextScript.staff-padding = #3.5
  }
  \context {
    \ChordNames
    \remove "Staff_performer"
  }
  \context {
    \Voice
   % \override Hairpin.thickness = #2.5
    %\override PhrasingSlur.padding = #4
    \override PhrasingSlur.outside-staff-priority = #150
    \override Slur.outside-staff-priority = #150
    %\override Beam.beam-thickness = #0.4 % 0.48
    %\override Slur.line-thickness = #0.5 % 0.8
    %\override Tie.line-thickness = #0.5
    \override Script.stencil = #bold-tenuto-script-stencil
  }
}

myPat= { c4 c2 c8. c16 }
nyPat= { c4 c c16 c c c c c c c }
oyPat= { c8-> }
mdms=\markup {
  \hspace #4 \fontsize #-1.5 \column {
    \vspace #1.3
    \line { "m.d." } \vspace #1 \line { "m.s." }
  }
}

RH =  \relative c'' {
  \clef "treble" \key c \major
  \time 4/4
  \set Timing.beamExceptions = #'()
  \set Timing.baseMoment = #(ly:make-moment 1/4)
  \set Staff.beatStructure = #'(1 1 1 1 1 1 1 1 )  %% abhängig vom Takt
  \set fingeringOrientations = #'(up up )     %% für Akkorde!
  %\override Fingering.direction = #UP      %% für Einzelnoten!
  \override Fingering.padding = #0.8
  \override Fingering.staff-padding = #'()
  \override Fingering.avoid-slur = #'inside
  %\override Slur.direction = #UP
  %\mark \markup "Lento."
  \allgShift #'(-4 . 5) Score MetronomeMark
  \tempo "Lento" 4 = 60
  r16 g  c  d  r g, c d r g, c d r g, c d
  r g,  e' g,  r g e' g, r g e' g,
  r g e' g,
  \changePitch \myPat { < g-1 e'-4> q  <g e'>  <a-2 f'-5> }
  \changePitch \nyPat { <a-1 f'-4> q q q q q q q q <h-2 g'-5> }
  \changePitch \myPat { <h g'> q q <c a'> }
  <g e'>1
  \changePitch \myPat { < g e'> q  <g e'>  <a f'> }
  \changePitch \nyPat { <a f'> q q q q q q q q <h g'> }
  \changePitch \myPat { <h g'> q q <c a'> }
  %\changePitch \myPat { <h g'> q q <c a'> }
  < g e' >1
  r16 e' < c' e > e, < h' d > e, < a c > e
  r16 h < g' h > h, < fis' a > h, < e g > h
  < c a' >4 < h g'>8 f' < d g >32  e d c g16 c < e, g >4
  r16 e < c' e > e, < h' d > e, < a c > e
  r16 h < g' h > h, < fis' a > h, < e g > h
  < c f a >4 g'8 f16 < c d g  > q g c d d c d f
  \set Timing.beamExceptions =
  #'(                         ;start of alist
      (end .                   ;entry for end of beams
        (                       ;start of alist of end points
          ((1 . 32) . (4 4 4 4 4 4 4))   ;rule for 1/32 beams -- end each 1/16
          )))
  g,32 d' f g g, d' f g d f g d' d, f g d'
  g, d' f g g, d' f g d f g d' d, f g d' g,
  % Achtung, ein Taktwechsel löscht die beamExceptions
  \set Timing.beamExceptions =
  #'(                         ;start of alist
      (end .                   ;entry for end of beams
        (                       ;start of alist of end points
          ((1 . 32) . (4 4 4 4 4 4 4))   ;rule for 1/32 beams -- end each 1/16
          )))
  d' f g g, d' f g g, h d g g, h d g  %^\markup { \musicglyph #"scripts.segno" } )

  \changePitch \myPat { < g, e'>  < g e' >  q  <a f'> }
  \changePitch \nyPat { <a f'> q q q q q q q q <h g'> }
  \changePitch \myPat { <h g'> q q <c a'> }
  < g e' >4  g'16 es b g f' c a f < a d > h g8
  \changePitch \nyPat { <g e'> q q q q q q q q <a f'> }
  \changePitch \nyPat { <a f'> q q q q q q q q <h g'> }
  \changePitch \myPat { <h g'> q q <c a'> }
  < c e >1
  r16 e, < c' e > e, < h' d > e, < a c > e
  r16 h < g' h > h, < fis' a > h, < e g > h
  < f' a >4 < h, g'>8 f'16 g g \tuplet 3/2 { e32 d c } g16 e g4
  r16 e < c' e > e, < h' d > e, < a c > e
  r16 h < g' h > h, < fis' a > h, < e g > h
  <<
    {
      a'4  g8 f16 g g2
    } \\ {
      a16 c, f c g' c, f g r8
      \stemUp
      c,16 d h'16\rest c, d f
    }
  >>
  \set Timing.beamExceptions =
  #'(                         ;start of alist
      (end .                   ;entry for end of beams
        (                       ;start of alist of end points
          ((1 . 32) . (4 4 4 4 4 4 4))   ;rule for 1/32 beams -- end each 1/16
          )))
  g,32 d' f g g, d' f g d f g d' d, f g d'
  g, d' f g g, d' f g d f g d' d, f g d'
  g,
  \set Timing.beamExceptions =
  #'(                         ;start of alist
      (end .                   ;entry for end of beams
        (                       ;start of alist of end points
          ((1 . 32) . (4 4 4 4 4 4 4))   ;rule for 1/32 beams -- end each 1/16
          )))
  d' f g g, d' f g g, h d g g, h d g
  \changePitch \myPat { < g, e'> < g e' > q <a f'> }
  \changePitch \nyPat { <a f'> q q q q q q q q <h g'> }
  \changePitch \myPat { <h g'> q q <c a'> }
  < g e' >4 g'16 es b g f' c a f < a d > h g8
  \changePitch \nyPat { <g e'> q q q q q q q q <a f'> }
  \changePitch \nyPat { <a f'> q q q q q q q q <h g'> }
  \changePitch \myPat { <h g'> q q <c a'> } < c e >2
  f16 a, c f g h, d g
  \changePitch \nyPat { <g, e'> < g e'> q q q q q q q <a f'> }
  \changePitch \nyPat { <a f'> q q q q-> q q q q <h g'> }
  \changePitch \myPat { <h g'> q q  <c a'> }
  < g e'>2 r16 a c f g h, d g
  q2 r16 a, c f g h, d g
  \set fingeringOrientations = #'(right)
  %\allgShift #'(0 . 2) Staff TextScript
  < e,-1 g-2 c-4 e-5 >1\arpeggio-\mdms
}

LH = \relative c' {
  \clef bass
  \key c \major
  \set fingeringOrientations = #'(right) %% für Akkorde!
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  %\override Fingering.direction = #UP  %% für Einzelnoten!
  \override Fingering.padding = #0.8
  \override Fingering.staff-padding = #'()
  \override Fingering.avoid-slur = #'inside
  %\override Slur.direction = #UP
  \set Timing.beamExceptions = #'()
  \set Timing.baseMoment = #(ly:make-moment 1/4)
  \set Staff.beatStructure = #'(2 2 )  %% abhängig vom Takt
  %\stemDown
  c4  c c c
  << { c c c c } \\ { c,1 } >>
  c8 g' e' g, c g c g
  d a' f' a, d a d a
  g, d' h' d, g d g d
  c g' e' g, c g g g,
  c, g' e' g c g c g
  d a' f' a, d a d a
  g, d' h' d, g d g d
  c g' e' g, c, g' < c e >[ h]
  a, e' a c e,, h' e g
  f,16 ( c' f c ) g[ ( d' g d )] c4~ c16 g' < c, \twpa c' > < h \twpa h' >
  < a \twpa a' >8 e' a c e,, h' e g
  f,16[ c' f c] f, c' f g,~ g4 g'
  \set Timing.baseMoment = #(ly:make-moment 1/4)
  \set Staff.beatStructure = #'(2 2 )  %% abhängig vom Takt
  g,8 g g' g g,8 g' g, g'
  g, g' g, g,
  c-5 g''-1 e'-2 g,-5 c g c g
  d a' f' a, d a d a
  g, d' h' d, g d g d
  c g' < es g b >4 < f a c > g8. g,16
  \slurShiftx #'(0 . 0)  #'(2 . 2)
  < \twpa c, c' >8 ( g'' e'
  \slurShiftx #'(0 . 0)  #'(2 . 2)
  g, ) c, ( g' e' g, )
  < \twpa d, d'>( a'' f' a, )
  \slurShiftx #'(0 . 0)  #'(2 . 2)
  d,( a' f' a, )
  \slurShiftx #'(0 . 0)  #'(2 . 2)
  g, ( d' h' d, h' d ) r4
  c,8 g' e' g, c g c g
  a, e' a c e,, h' e g
  \slurShiftx #'(0 . 0)  #'(2 . 2)
  f,16 ( c' f c )
  \slurShiftx #'(0 . 0)  #'(2 . 2)
  g[ ( d' g d )]
  c'8-> d->
  \slurShiftx #'(0 . 0)  #'(2 . 2)
  c16 ( g c, h )
  < a \twpa a' >8 e' a c e,, h' e g
  f,4 r g16 g' s8  g4
  \stemDown
  \changePitch \oyPat { g,8 g8 g' g g, g' g, g' g g' g, g, }
  \stemNeutral
  \slurShift #'(0 . -5)
  c,-> ( g'' e' g, c g c g )
  \slurShiftx  #'(0 . 2)  #'(0 . 4)
  d ( a' f' a, d a d a )
  g, d' h' d, g d g d
  c g' < es g b >4 < f a c > g8. g,16
  \slurShiftx #'(0 . 1 ) #'( 0 . 1 )
  < \twpa c, c' >8 ( g'' e' g, )
  \slurShiftx #'(0 . 1 ) #'( 0 . 1 )
  c, ( g' e' g, )
  \slurShiftx #'(0 . 1 ) #'( 0 . 1 )
  < \twpa d, d'>( a'' f' a, )
  \slurShiftx #'(0 . 1 ) #'( 0 . 1 )
  d,( a' f' a, )
  \slurShiftx #'(0 . 0.5 ) #'( 0 . 1 )
  g, ( d' h' d, h' d ) r4
  \slurShiftx #'(0 . 1 ) #'( 0 . 2 )
  c,8 ( g' c e ) a,4-- h--
  \slurShiftx #'(0 . 1 ) #'( 1 . 1 )
  < \twpa c,, c' >8 ( g'' e' g, )
  \slurShiftx #'(0 . 1 ) #'( 0 . 1 )
  c, ( g' e' g, )
  \slurShiftx #'(0 . 1 ) #'( 0 . 1 )
  < \twpa d, d'>( a'' f' a, )
  \slurShiftx #'(0 . 1 ) #'( 0 . 1 )
  d,( a' f' a, )
  \slurShiftx #'(0 . 0.5 ) #'( 1 . 0 )
  g, ( d' h' d, h' d ) r4
  \slurShiftx #'(0 . 0.5 ) #'( 2 . 1 )
  c,8 ( g' c e ) a,4 h
  \slurShiftx #'(0 . 0.5 ) #'( 2 . 1 )
  c,8 ( g' c e ) a,4 h
  \change Staff = "up" < c-5 g'-2 c-1  >1\arpeggio_\loco
}

Akk=\chordmode {
  \set alignAboveContext = #"up"
  c1 c c d:m g:7 c c d:m g:7 c
  a2:m e:m
  f4 g:7 c8 g:7 c g/h
  a2:m e:m f g:7sus
  g1:7 g2:7
  c1 d:m g:7 c4 es f g:7
  c1 d:m g:7 c
  a2:m e:m f4 g:7 c2
  a:m e:m f g:7sus
  g1:7 g2:7
  c1 d:m g:7 c4 es f g:7
  c1 d:m g:7 c2 f4 f
  c1 d:m g:7 c2 f4 g
  c2 f4 g
  c
}

Struktur= {
  s1 * 3 \break
  s1 * 4 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 2 \pageBreak %\break
  s2
  s1 * 2 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break %\break
  s1 * 2 \pageBreak
  s2
  s1 * 2 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
}

Pedal= {
  %\override Staff.SustainPedal.padding = #4
  \repeat unfold 10 { s1\NSus }
  s2\NSus s2\NSus s4\NSus s4\NSus s8\NSus s8\NSus s\NSus s16 s\FSus
  s2\NSus s\NSus s4\NSus s8 s8\FSus s2
  s1\NSus s4 s\NSus
  %\once \override TextScript.self-alignment-X=#LEFT
  \override Staff.SustainPedal.extra-spacing-width = #'(0 . 0 ) % verschiebt die Note auch mit!
  %\override Staff.SustainPedal.right-padding= #12
  s1\NSus % c8\NSus s8 s4 s2
  s1\NSus s\NSus
  s4\NSus s\NSus s\NSus s\NSus
  s1\NSus s1\NSus s4\NSus s2 s4\FSus
  s2\NSus s\NSus s\NSus s\NSus
  s4\NSus s8\NSus s8\NSus s4 s4\NSus
  s2\NSus s\NSus s4\NSus s\NSus s\NSus s\NSus
  s1\NSus s4 s\NSus s1\NSus s\NSus s\NSus
  s4\NSus s4\NSus s4\NSus s4\NSus
  s1\NSus s\NSus s2\NSus s4 s4\FSus
  s2\NSus s4\NSus s\NSus
  s1\NSus s1\NSus s2\NSus s4 s\FSus
  s2\NSus s4\NSus s\NSus
  s2\NSus s4\NSus s\NSus
  s\NSus
}


%\displayLilyMusic \ghostMusic \PartPOneVoiceOne

% The score definition

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
    \context ChordNames \Akk
    \new Staff="up" \with {
      \consists Bar_number_engraver
      \override BarNumber.break-visibility = #end-of-line-invisible
      \override BarNumber.padding = #0
      \override BarNumber.self-alignment-X = #CENTER
    }
    <<
      \context Voice \RH
      \context Voice \ghostRH
      \context Voice \Struktur
    >>
    \new Staff="down" \LH
    \new Dynamics \Pedal
  >>
  %% Falls erforderlich Zeilenlänge und Einzug ändern
  \layout {
  }
  \midi {
    \context {
      \ChordNames
      \remove "Staff_performer"
    }
    \tempo 4 = 60
  }
}
