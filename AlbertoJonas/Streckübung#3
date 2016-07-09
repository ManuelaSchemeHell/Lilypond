\version "2.19.37"

\language "deutsch"

\include "Papier+Layout.ly"
\include "myScheme.ily"
%\include "hanon-definitions.ily"

exercise ="15"
%% wenn erforderlich linken Abstand ändern
\paper {
  %% hier für den Fall, dass Änderungen erforderlich sind
  %%l eft-margin = #15
  %% top-margin = #20
  %% system-system-spacing.basic-distance = #8
  %min-systems-per-page = #6

}

Grund={
  c16-1 e-2 g-3 c-4 e-5 c-4 g-3 e-2 c e g c e c g e
}

GrundV= {
  c-1 e-2 c-1 e-2 g-3 e-2 g-3 c-4 g-3 c-4 e-5 c-4 e-5 c-4 e-5
  c-4 g-3 c-4 g-3 e-2 g-3 e-2 c-1 e-2
}

Erste=
{
  e16-1 g-2 c-3 e-4 g-5 e-4 c-3 g-2 e g c e g e c g
}

ErsteV=
{
  e-1 g-2 e-1 g-2 c-3 g-2 c-3 e-4 c-3 e-4 g-5 e-4 g-5 e-4 g-5
  e-4 c-3 e-4 c-3 g-2 c-3 g-2 e-1 g-2
}

Zweite=
{
  g16-1 c-2 e-3 g-4 c-5 g-4 e-3 c-2 g c e g c g e c
}

ZweiteV=
{
  g16-1 c-2 g-1 c-2 e-3 c-2 e-3 g-4 e-3 g-4 c-5 g-4 c-5 g-4 c-5
  g-4 e-3 g-4 e-3 c-2 e-3 c-2 g-1 c-2
}

DritteI=
{
  c'16-5 g-4 es-3 c-2 g-1 c-2 es-3 g-4 c g es c g c es g
}

Dritte=
{
  c16-5 g-4 es-3 c-2 g-1 c-2 es-3 g-4 c g es c g c es g
}
DritteV=
{
  c-5 g-4 c-5 g-4 es-3 g-4 es-3 c-2 es-3 c-2 g-1 c-2
  g-1 c-2 g-1 c-2 es-3 c-2 es-3 g-4 es-3 g-4 c-5 g-4
}

Vierte=
{
  g-5 es-4 c-3 g-2 es-1 g-2 c-3 es-4 g es c g es g c es
}


VierteV=
{
  g-5 es-4 g-5 es-4 c-3 es-4 c-3 g-2 c-3 g-2 es-1 g-2
  es-1 g-2 es-1 g-2 c-3 g-2 c-3 es-4 c-3 es-4 g-5 es-4
}

Funfte=
{
  es-5 c-4 g-3 es-2 c-1 es-2 g-3 c-4 es c g es c es g c
}

FunfteV=
{
  es-5 c-4 es-5 c-4 g-3 c-4 g-3 es-2 g-3 es-2 c-1 es-2
  c-1 es-2 c-1 es-2 g-3 es-2 g-3 c-4 g-3 c-4 es-5 c-4
}

myPattern = {
  c16. c32
}

nyPattern= {
  c32 c16.
}

oyPattern = {
  c16*2/3_> c c
}

Auf= {
  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )
  \Grund \bar ":..:"
  \changePitch \myPattern \Grund \bar ":..:"
  \changePitch \nyPattern \Grund \bar ":..:"

  \set baseMoment = #(ly:make-moment 1/8)
  \set beatStructure = #'( 2 2 2 2)
  \changePitch \oyPattern \GrundV \bar ":..:"
  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )

  \Erste \bar ":..:"
  \changePitch \myPattern \Erste \bar ":..:"
  \changePitch \nyPattern \Erste \bar ":..:"
  \set baseMoment = #(ly:make-moment 1/8)
  \set beatStructure = #'( 2 2 2 2)
  \changePitch \oyPattern \ErsteV \bar ":..:"

  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )

  \Zweite
  \bar ":..:"
  \changePitch \myPattern \Zweite \bar ":..:"
  \changePitch \nyPattern \Zweite \bar ":..:"

  \set baseMoment = #(ly:make-moment 1/8)
  \set beatStructure = #'( 2 2 2 2)
  \changePitch \oyPattern \ZweiteV \bar ":..:"

}

Bab= {
  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )

  \DritteI
  \bar ":..:"
  \changePitch \myPattern \Dritte \bar ":..:"
  \changePitch \nyPattern \Dritte \bar ":..:"

  \set baseMoment = #(ly:make-moment 1/8)
  \set beatStructure = #'( 2 2 2 2)
  \changePitch \oyPattern \DritteV \bar ":..:"

  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )

  \Vierte
  \bar ":..:"
  \changePitch \myPattern \Vierte \bar ":..:"
  \changePitch \nyPattern \Vierte \bar ":..:"

  \set baseMoment = #(ly:make-moment 1/8)
  \set beatStructure = #'( 2 2 2 2)
  \changePitch \oyPattern \VierteV \bar ":..:"

  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )

  \Funfte
  \bar ":..:"
  \changePitch \myPattern \Funfte \bar ":..:"
  \changePitch \nyPattern \Funfte \bar ":..:"

  \set baseMoment = #(ly:make-moment 1/8)
  \set beatStructure = #'( 2 2 2 2)
  \changePitch \oyPattern \FunfteV \bar ":..:"

}

RH=  {
  \set Staff.explicitKeySignatureVisibility = #end-of-line-invisible
  \set Timing.beamExceptions = #'()
  \set subdivideBeams = ##t
  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )
  \set fingeringOrientations = #'(left)     %% für Akkorde!
  % \override Fingering.direction = #UP      %% für Einzelnoten!
  \override Fingering.padding = #0.8
  \override Fingering.staff-padding = #'()
  \override Fingering.avoid-slur = #'inside
  \override Slur.direction = #UP
  \mark \markup { \abs-fontsize #12 "Langsam, legato und kräftig" }
  \Auf
  \mark \markup  { \abs-fontsize #12 "C-Moll" }
  \Bab
  \mark \markup  { \abs-fontsize #12 "Des-Dur" }
  \transpose c des { \relative c' \Auf }
  \mark \markup  { \abs-fontsize #12 "Cis-Moll" }
  \transpose c cis { \relative c'' \Bab }
}

LH=  {
  \clef bass
  \set Staff.explicitKeySignatureVisibility = #end-of-line-invisible
  \set Timing.beamExceptions = #'()
  \set subdivideBeams = ##t
  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )
  \set fingeringOrientations = #'(left)     %% für Akkorde!
  % \override Fingering.direction = #UP      %% für Einzelnoten!
  \override Fingering.padding = #0.8
  \override Fingering.staff-padding = #'()
  \override Fingering.avoid-slur = #'inside
  \override Slur.direction = #UP
  \Auf
  \Bab
  \transpose c des { \relative c \Auf }
  \transpose c cis { \relative c \Bab }
}

RHd=  {
  \set Staff.explicitKeySignatureVisibility = #end-of-line-invisible
  \set Timing.beamExceptions = #'()
  \set subdivideBeams = ##t
  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )
  \set fingeringOrientations = #'(left)     %% für Akkorde!
  % \override Fingering.direction = #UP      %% für Einzelnoten!
  \override Fingering.padding = #0.8
  \override Fingering.staff-padding = #'()
  \override Fingering.avoid-slur = #'inside
  \override Slur.direction = #UP
  \mark \markup { \abs-fontsize #12 "D-Dur" }
  \transpose c d { \relative c' \Auf }
  \mark \markup  { \abs-fontsize #12 "D-Moll" }
  \transpose c d { \relative c'' \Bab }
  \mark \markup  { \abs-fontsize #12 "Es-Dur" }
  \transpose c es { \relative c' \Auf }
  \mark \markup  { \abs-fontsize #12 "Es-Moll" }
  \transpose c es { \relative c'' \Bab }
}

LHd=  {
  \clef bass
  \set Staff.explicitKeySignatureVisibility = #end-of-line-invisible
  \set Timing.beamExceptions = #'()
  \set subdivideBeams = ##t
  \set baseMoment = #(ly:make-moment 1/4)
  \set beatStructure = #'(2 2 2 2 )
  \set fingeringOrientations = #'(left)     %% für Akkorde!
  % \override Fingering.direction = #UP      %% für Einzelnoten!
  \override Fingering.padding = #0.8
  \override Fingering.staff-padding = #'()
  \override Fingering.avoid-slur = #'inside
  \override Slur.direction = #UP
  \transpose c d { \relative d \Auf }
  \transpose c d { \relative d \Bab }
  \transpose c es { \relative d \Auf }
  \transpose c es { \relative d \Bab }
}
Struktur = {
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \pageBreak
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \pageBreak
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \pageBreak
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
}

\score
{
  \new PianoStaff
  <<
    \new Staff="upper"
    \relative c' {
      \clef treble
      <<
        \RH
        \context Voice { \Struktur }
      >>
    }
    \new Staff="lower"
    \LH
  >>
}

\score
{
  \new PianoStaff
  <<
    \new Staff="upper"
    \relative c' {
      \clef treble
      <<
        \RHd
        \context Voice { \Struktur }
      >>
    }
    \new Staff="lower"
    \LHd
  >>
}
