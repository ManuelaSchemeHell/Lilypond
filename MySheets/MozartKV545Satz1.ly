\version "2.19.32"
\language "deutsch"

\include "myScheme.ily"
%\include "Papier+Layout.ly"

\header {
  title = "Sonate 16 in C major"
  subtitle = "Sonata facile"
  composer = "W. A. Mozart"
  opus = "K 545"
}

#(define afterGraceFraction (cons 15 16))
\paper {
  #(set-paper-size "a4")
  myStaffSize = #20
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
  annotate-spacing = ##f
  left-margin = #15
  page-count = #4
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
  line-width = #185

  \context {
    \Staff
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    \consists Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override StaffSymbol.thickness = #0.35 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
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
    \ChordNames
    \remove "Staff_performer"
  }
  \context {
    \Voice
    \override Hairpin.thickness = #2.5
    \override PhrasingSlur.outside-staff-priority = #150
    \override Slur.outside-staff-priority = #150
    \override Script.stencil = #bold-tenuto-script-stencil
  }
}
soft =
-\tweak stencil
#(lambda (grob)
   (grob-interpret-markup grob
     (if (eq? UP (ly:grob-property grob 'direction))
         #{
           \markup
           \with-dimensions #'(-0.7 . 0.7) #'(-0.7 . 0)
           \postscript
           #"0.15 setlinewidth -0.7 0 moveto 0 0 0.7 180 0 arc stroke"
         #}
         #{
           \markup
           \with-dimensions #'(-0.7 . 0.7) #'(0 . 0.7)
           \postscript
           #"0.15 setlinewidth 0.7 0 moveto 0 0 0.7 0 180 arc stroke"
         #})))
\fermata

Akk=\chordmode {
  % \set alignAboveContext = #"down"
  c1 g:7 f2 c
  g:7 c
  d2.:m d4:m7
  c1 d2.:m7 g4
  g2. a4:m d1:m d2.:m d4
  g/h c g/h c g1 s
  g s g s
  g2/d c
  d:7 h:m e:m a:m d g
  a1:m a
  g d g2 d:7
  g2. d4:7 g1
  g2.:m d4:7
  g1:m g:m
  a2 d:m d2.:m a4:7
  d2.:m a4:7
  d1:m a:m a:m
}

RH= \relative c'' {
  \override Script.stencil = #bold-tenuto-script-stencil
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
  %\mark \markup "Lento."
  \allgShift #'(-4 . 8) Score MetronomeMark
  \tempo "Allegro" 4 = 120
  \phrasingSlurDashed
  \allgShift #'(4 . 5) Score RehearsalMark
  \mark \markup \box "A"
  c2-1-\pleg (
  e4-3 g-5
  h,4.-1 c16 d c4 ) r
  \slurShiftx #'( 0 . 3 ) #'( -2 . 3)
  a'2-3 (-> g4\< c\!
  g-3 f8\trill\> e16 f e4)\! r
  a,8-1 \p \< \( h16 c d-1 e f g\!  a-5 \> g f e d-1 c-4 h a\!
  g8_1\< a16 h c-1 d e f\!  g-5 \> f e d c_1
  h_4
  a g\!
  f8-1 \< g16 a h-1 c d e\!  f-5 \> e d c
  h_1 a_4 g f-2 \!
  e8-1 \< f16-2 g  a-1 h c d\!  e-5 \> d c h a_1
  g_4 f e_2 \! \)
  d8_1-\markup {
    \dynamic "p"
    \parenthesize \italic \fontsize #1 "cresc."
  } \( e16 f-3  g_1 a h cis-4 d-5 a-1 \< h cis-3 d-1 e f g-1 \!
  a h c!-4 h  a g-1 f-3 e-2 f-3 g-4 a-5 g  f e d-1 c-2 \)

  h8-1 \f g' e-3 c-1  d-2 g e c
  d4-\markup {
    \parenthesize \dynamic "f"
  }
  <h d g> g_2 r4
  % \allgShift #'(4 . 5) Score RehearsalMark
  \mark \markup \box "B"
  r1-\markup {
    \parenthesize \dynamic "p"
  }
  d''8\mp( h) g4.( a16 h a8 g)
  g8.\trill-3( fis16-2) fis4-3 r2
  d'8\mp( h ) g4.( a16 h a8 g)

  g8.\trill-3( fis16) fis4 r2
  d'4-5 r16 d16-5 h-4 g-2 e4-1 r16 e16(-1 g-2 e)
  c'4 r16 c( a fis d4)
  r16 d16( fis d)
  % 20
  h'4-5 r16 h( g e c4) r16 c( e c
  a'4-5) r16 a-5( fis-4 d-2 h4)  r16 g'-5( d-3 h-2
  a2\p) \acciaccatura h16-2 c4-3\< \acciaccatura dis16-2 e4-3\!

  \acciaccatura { gis16-2 } a4.-> h32 ( a gis a c8-5 a-3) c( a)
  h-3(\f g-1) d'2-5 (\sf c16 h a g)

  \startTrillSpan  \afterGrace a1 { g32[ a] }
  g4-\markup {
    \parenthesize \dynamic "f"
  } \stopTrillSpan g16-2( d-\soft g h-4 d-5 h-4 g h-4 c-5 a-3 fis-2 a-4
  g4) g,16-2( d_\soft g h-4 d h-4 g h-4 c a-3 fis-2 a-4
  g4) <d' h'> <h g'-4> r4 \bar ":..:"
  \mark \markup \box "C"
  g4 g'16-2( d-\soft g b-3 d-5 b-3 g b c-5 a-3 fis-2 a-4
  g4) g,16-2_( d_\soft g b-3 d b-3 g b  c-5 a-3 fis-2 a-4
  g4) r r16 g'-2 b-4 a g f e-4 d

  cis4\sf r r16 cis'-3( e d  cis b a g-3
  f4\sf)  d16-2( a-1-\soft d f-4 a f-4 d-2 f g-5 e-3 cis-2 e-4
  d4) d,16-2 a_\soft d f-4  a f d-2 f  g-5 e-3 cis e

  r16 d-1( e f  g-1 a h cis d4\sf) r4
  r16 h-1( c d e-1 fis gis a h4\sf) r
  r16 a-1( e'-5 d c h a g f4\sf) r

  r16 g-1( d'-5 c h a g f-3 e4\sf) r
  r16 f-1( c'-5 h a g f e-3 d4\sf) r
  r16 e-1( h'-5 a gis f e d-3 c4\sf) r

  r16 b-3-\markup {
    \parenthesize \italic \fontsize #1 "dim."
  }
  \override Fingering.direction = #DOWN
  d-5 c  b a g f-3  e-2 \> f-1 g a  b c^1 d e\!
  \override Fingering.direction = #UP
   \allgShift #'(-2 . 6) Score RehearsalMark
  \mark \markup \box "D"
  f2-1 (\mp a4-3 c-5
  e,4.-1 f16 g f4 )  r4
  %\once \override Script.outside-staff-priority = #1000 %##f %'()
  \slurShift #'( 0 . -4 )
  d'2-3 ( c4\< f\!
  c-3 b8 \trill\> a16 b a4 )\! r4 % \break

  d,8-1 \p \< \( e16 f g-1 a b c\!  d-5\> c b a g-1 f-4 e d\!
  c8-1 \< d16 e f-1 g a b-4 \! c-5 \> b a g f-1
  e-3 d c-1 \!
  b8-2 \< c16-1 d-2 e-3 f-1 g-2 a-3 \! b-4 \> a g f-1 e-3 d c b-2\!

  a8-1 \< b16-2 c-3  d-1 e f g\!  a-5\> g f e d-1 c-3 b a-1 \! \)
  a'4-5 r r <c, a'-5>
  <c g'-4> r r <c g'-5>
  <c f-4> r r <h f'-5>
  <c-2 e-4> r r <c-5 e-3>
  \override Fingering.direction = #DOWN
  d16-4-\markup {
    \parenthesize \italic \fontsize #1 "cresc."
  }


  \( d,-1 e f  g-1 a h cis
  \override Fingering.direction = #UP
  d-5 a-1 h cis  d-1 e f g-1

  a h c-4 h  a g-1 f-3 e-2 f-3 g-4 a-5 g  f e d-1 c-2 \)
  h8-1 \f  g'-5   e-3 c-1  d-2 g  e c
  d4-\markup {
    \parenthesize \dynamic "f"
  }
  <h d g> g r4
  % \allgShift #'(4 . 5) Score RehearsalMark
  \mark \markup \box "E"
  r1-\markup {
    \parenthesize \dynamic "p"
  }
  g'8\mp( e) c4.( d16 e d8 c-. )
  c8.\trill-3( h16-2) h4-3 r2
  g'8\mp( e) c4.( d16 e d8 c-. )

  c8.\trill-3 ( h16) h4 r2

  g'4-5 r16 g16-5 e-4 c-2 a4-1 r16 a16(-1 c-2 a)
  f'4 r16 f( d h g4)
  r16 g'16 ( h g
  % 20
  e'4-5 ) r16 e( c a f4) r16
  \slurShiftx #'( -1 . 2.5 ) #'( 3 . 0 )
  f (  a f
  d'4-5) r16
  \slurShiftx #'( 0 . 2 ) #'( 0 . 2 )
  d-5 ( h-4 g-2 e4)  r16 c'-5( g-3 e-2
  d2-\markup {
    \dynamic "p"
    \parenthesize \italic \fontsize #1 "cresc."
  } ) \acciaccatura cis16-2 d4 \acciaccatura cis16 d4
  a'2\p \acciaccatura gis16-2 a4 \acciaccatura gis16 a4

  g!8-1\f \( a16 h c-1 d e-3 d c-1 h-4 a g  f e-3d c

  \afterGrace d1 \startTrillSpan {
    c32[ d] \)
    \stopTrillSpan
  }

  c4-\markup {
    \parenthesize \dynamic "f"
  }
  c16-2 \( g-\soft c e-4  g e-4 c e-4  f d-3 h d-3 c4
  \override Fingering.direction = #DOWN
  c,16-2 g_\soft c e-4  g e-4 c e-4  f d-3 h d-3
  \set fingeringOrientations = #'(left)
  c4 \) <e'-1 g-2 c-5> c-2 r
  \bar ":|."
}

LH=  \relative c'' {
  \clef treble
  \key c \major
  \set fingeringOrientations = #'(up down) %% für Akkorde!
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \override Fingering.direction = #DOWN  %% für Einzelnoten!
  \override Fingering.padding = #0.8
  \override Fingering.staff-padding = #'()
  \override Fingering.avoid-slur = #'inside
  \phrasingSlurDashed
  %\override Slur.direction = #UP
  %\set Timing.beamExceptions = #'()
  \set Timing.baseMoment = #(ly:make-moment 1/4)
  \set Staff.beatStructure = #'(2 2 )  %% abhängig vom Takt
  \set Timing.beamExceptions =
  #'(                         ;start of alist
      (end .                   ;entry for end of beams
        (                       ;start of alist of end points
          ((1 . 16) . (4 4 4 4))   ;rule for 1/16 beams -- end each 1/4
          )))
  c,8-5 \( g'-1 e-3 g  c,  g' e g
  d-4 g-1 f-2 g  c,-5 g'-1 e-3 g
  c, a'-1 f-2 a  c, g'-1 e-3 g
  h,-5 g'-1 d-3 g  c,-4 g'-1 e-2 g

  f4 \) r r
  \clef bass <f, c'>-4
  <e c'> r r <e c'>-4
  <d c'> r r <d h'>-4
  <c c'> r4 r4 <c-5 e-3>
  <f-2 a-1>1
  f4.-3( g8 a4. fis8_2)
  g,16-5 \( h-3 d-2 g-1  g,-5 c-3 e-2 g-1  g, h d g  g, c e g
  g,4\) g' g, r
  \override Fingering.direction = #UP
  cis'16-2( d cis d  cis d cis d  c-2 d c d  c d c d)

  h^3 d h d \repeat unfold 3 { h d h d }
  c-2 d h-3 d  a-4 d h-3 d  c d h d  c d a d
  \repeat unfold 4 { h d h d }

  c d h d  a d h d  c d h d  c d a d
  \clef treble r16
  \override Fingering.direction = #DOWN
  h-5( d-4 g-2 h4) r16 c,-5( e-4 g-2 c4)
  r16 a,-5( c-4 fis-2 a4) r16 h,-5( d-4 fis-2 h4)
  r16 g,-5( h-4 e-2 g4) r16 a,-5( c-4 e-2 a4)
  r16 fis,-5( a-4 d-2 fis4) r16 g,-5( h-4 d-2 g4)
  \repeat unfold 16 <c, e>8

  d16-5 h'-1 g-2 h \repeat unfold 3 { d, h' g h }
  \repeat unfold 4 { d, c' fis, c' }

  <g-2 h-1>4 r r <a c d,>
  <g-2 h-1> r r
  \clef bass <d, a' c>
  <g h> <g g,> <g g,> r
  <g, g'>4 r r
  \clef treble <d'' a' c>(
  <g-3 b-1>) r r
  \clef bass <d, a' c>
  r16 g,-5( a b  c d e-3 fis g4\sf) r
  r16 a,-5 ( h c
  \override Fingering.direction = #UP
  d e fis-3 gis a4\sf) r
  <d, d'>4 r r
  \clef treble <a' e' g>(
  <d-3 f-1>4) r r
  \clef bass <a, e' g>(

  <d_5 f_4>4) r r16 d'^3( f e d c^1 h a
  gis4)\sf r r16 gis-3( h a gis f!-1 e d
  c4)\sf r
  \override Fingering.direction = #DOWN
  \clef treble r16 d'-5( a'-1 g f e-1 d c


  h4\sf) r r16 c-5( g' f  e d-1 c h
  a4\sf) r r16 h-5-( f' e  d c-1 h a
  \clef bass gis4\sf ) r
  \override Fingering.direction = #UP
  r16 a-3( c-1 h  a g-1 f e

  d2\sf) <c g' b>\sf
  \clef treble
  \override Fingering.direction = #DOWN
  f'8-5( c'-1 a-3 c  f,  c' a c)
  g-4 c-1 b-2 c  f,-5 c'-1 a-3 c
  f, d'-1 b-2 d  f, c'-1 a-3 c
  e,-5 c'-1 g-3 c  f,-4 c'-1 a-2 c

  b4 r4 r4 \clef bass <b, f'>_4
  <a f'> r4 r4 <a f'>-4
  <g f'> r4 r4 <g e'>-4
  <f f'>4 r4 r2
  \override Fingering.direction = #UP
  f8-3_\( g16-2 a-1  b-3 c-2 d-1 e-3 f-2 e-3 d-1 c-2  b-3 a-1 g-2 f-3
  e8-4 f16 g  a-1 h-4 c d  e-1 d c h-4  a-1 g f e
  d8-5 e16 f  g a-1 h-3 c d-1 c h a-4 g-1 f e d
  c8-5 d16 e  f g-1 a-3 h c-1 h a-3 g-1  f e d c-5
  <f-2 a-1>1 \)
  f4.-3 g8 a4. fis8-2
  \override Fingering.direction = #DOWN
  g,16-5 \( h-3 d-2 g-1  g,-5 c-3 e-2 g-1  g, h d g  g, c e g
  g,4 \) g' g, r
  \clef treble
  fis''16-2-\( g fis g  fis g fis g  f_2 g f g  f g f g \)

  e-3 \( g e g e g e g e g e g e g e g \)
  f-2\mp \( g e-3 g  d-4 g e-3 g  f g e g  f g d g \)
  e \( g e g e g e g e g e g e g e g \)

  f \( g e g  d g e g  f g e g  f g d g \)
  \override Fingering.direction = #UP
  \clef bass
  r16 e,-5 ( g-4 c-2 e4 ) r16 f,-5 ( a-4 c-2 f4 )
  r16
  %\slurShiftx #'(0 . -2) #'( 1 . 1 )
  d,-5 ( f-4 h-2 d4) r16 e,-5( g-4 h-2 e4)
  \override Fingering.direction = #DOWN
  \clef treble
  r16 c-5( e-4 a-2 c4) r16 d,-5( f-4 a-2 d4)
  \override Fingering.direction = #DOWN
  r16 h,-5( d-4 g-2 h4)
  r16 c,-5( e-4 g-2 c4)
  r8 \repeat unfold 7 { <f, a>8 }
  \clef bass r8
  \override Fingering.direction = #UP
  \repeat unfold 7 { <fis, c' es>8 }
  \repeat unfold 4 { g16-5 e' c-2 e }
  \repeat unfold 4 { g,16 f' h, f' }
  \set fingeringOrientations = #'(right)
  <c-2 e-1>4 r r <g  d' f>

  <c-3 e-1> r r <g, d' f>
  <c e> <c c'> <c c,> r
}

Struktur= {
  s1 * 4 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \pageBreak
  s1 * 3 \break
  \acciaccatura s16 s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \pageBreak
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \pageBreak
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break

}
%\displayLilyMusic \ghostMusic \RH
%%{
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
    % \context ChordNames \Akk
    \new Staff="down" \LH
    % \new Dynamics \Pedal
  >>
  %% Falls erforderlich Zeilenlänge und Einzug ändern

  \midi {
    \tempo 4 = 120
  }

  \layout {
  }
}
%}
