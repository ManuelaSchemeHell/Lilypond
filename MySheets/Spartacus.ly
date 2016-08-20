\version "2.19.37"

\header{
  % title = "Etüde Op. 38, Nr. 15"
  composer = "Aram Il'yich Khachaturian (6.6.1903-1.5.1978)"
  title = "Spartacus"
  subtitle = "Adagio of Spartacus and Phrygia"
  tagline = ""
}
\language "deutsch"
%\include "G:\\Lilypond\\__MySheets\\myScheme.ily"
\include "G:/Lilypond/__MySheets/myScheme.ily"
%A4 21 cm x 29,7 cm = 8.27 x 11.69 in
FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))
#(set-global-staff-size 18)
#(define afterGraceFraction (cons 15 16))
md=\markup { \fontsize #-1 \italic "m.d." }
ms=\markup { \fontsize #-1 \italic "m.s." }
#(define afterGraceFraction (cons 15 16))
%#(set! paper-alist (cons '("mein Format" . (cons (* 8.27 in) (* 11.69 in))) paper-alist))
\paper {
  #(set-paper-size "a4")
  myStaffSize = #20
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
  annotate-spacing = ##f
  left-margin = #10
  top-margin = #10
  ragged-right = ##f
  bottom-margin = #10
  last-bottom-spacing.basic-distance = #10
  #(include-special-characters)
}

\layout {
  line-width = #190
  \context {
    \ChordNames
    chordNameLowercaseMinor = ##f
    chordRootNamer = #germanChords
    chordNoteNamer = #note-name->german-markup
    \override ChordName.font-name = #"Orator10 BT" %% groß und schlank, wirkt modern; definitiv interessant
    \override ChordName.font-size = #1.6
    \override ChordName.font-series = #'bold %medium, bold, bold-narrow
  }
  \context {
    \Staff
    %explicitClefVisibility = #'#(#t #t #t) %#all-visible
    %explicitKeySignatureVisibility = #'#(#t #t #t)
    %\override KeySignature.break-visibility = #all-visible
    \consists Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override DynamicLineSpanner.staff-padding = #3
    %\RemoveAllEmptyStaves
    \consists "Span_arpeggio_engraver"
    connectArpeggios = ##t
    %\override OttavaBracket.ottavation = #"8"
  }
  \context {
    \Score
    \override BarNumber.padding = #1
    \override BarNumber.self-alignment-X = #CENTER
    \override BarNumber.break-visibility = #end-of-line-invisible
    \override BarNumber.outside-staff-priority = #'()
    \override NonMusicalPaperColumn.line-break-permission = ##f
    \override NonMusicalPaperColumn.page-break-permission = ##f
    \remove Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override KeyCancellation.break-visibility = #'#(#t #t #t)
    \override TextScript.self-alignment-X = #LEFT
    \override TextScript.staff-padding = #3.5
    \override OttavaBracket.shorten-pair = #'(0.1 . 1)
    subdivideBeams = ##t
    %\remove "Timing_translator"
    %ottavation = #"8"
  }
  \context {
    \ChoirStaff
    \remove System_start_delimiter_engraver
    %\remove Keep_alive_together_engraver
  }
  \context {
    \PianoStaff
    %\remove Keep_alive_together_engraver
    connectArpeggios = ##t
    %ottavation = #"8"
  }
  \context {
    \Voice
    \override PhrasingSlur.outside-staff-priority = #150
    \override Slur.outside-staff-priority = #150
    \override Slur.height-limit = #8
    \remove "Forbid_line_break_engraver"
    beamExceptions = #'()
    beatStructure = #'(4 4)
    %{
    beamExceptions =
    #'((end .                   ;entry for end of beams
         (                       ;start of alist of end points
           ((1 . 32) . (4 4 4 4 4 4 4))   ;rule for 1/32 beams -- end each 1/16
           ))) %}
    baseMoment = #(ly:make-moment 1/8)
  }
}

%% rechte Hand
VoiceI = \relative c'' {
  \time 4/4
  \numericTimeSignature
  \clef treble
  \key c \major
  \tempo "Adagio" 4=69
  % \voiceOne
  \override Score.BarNumber.avoid-slur=#'inside
  \set Voice.beatStructure=#'(2 2 2 2)

  < es as c es >8\arpeggio < as, c es>4 ( q8 ) q8 ( q4 q8 )
  r8 as ( < c es > as ) r as ( q as )
  r8 as ( < c es > as ) r as ( q as )
  r as ( q as ) r as ( q as )
  %\override TrillSpanner.to-barline = ##t
  \once \override TrillSpanner.bound-details.left.text =
  \markup \line { \musicglyph #"scripts.trill" \raise #1 \teeny \flat }

  des'1_\p~\startTrillSpan_\<
  \override Hairpin.bound-padding = 2
  \once \override Hairpin.to-barline = ##f
  \afterGrace des_\f \> { c!16\stopTrillSpan des\! }
  #(ly:expect-warning "Zusamm")
  c4 r4 #(ly:expect-warning "Zusamm") r2
  d!1_\p~\startTrillSpan_\< \afterGrace d_\f \> { cis16\stopTrillSpan ( d\! }
  %#(ly:expect-warning "zu viele")
  cis4 ) c4\rest c2\rest
  \clef bass
  r8 gis,,, ( a^\< c cis e g\! gis\!
  \clef treble
  a c cis e^\> g gis ) h\! ( c )
  < es es' >2.\arpeggio h'8 c
  < es es, >2.\arpeggio h8 c
  < es es, >2.\arpeggio \tuplet 3/2 { f8 es f }
  <<
    {
      es4
      % \once \override NoteColumn.force-hshift = #-0.5
      <des>2.\arpeggio
    } \\ \relative c'' {
      r8 as < b des >\arpeggio as r as q as
    }
  >>
  <<
    {
      < es es, >2.\arpeggio  \tuplet 3/2 { cis8 dis cis }
    } \\ \relative c'' {
      r8 gis a cis e gis a4
    }
  >>
  \stemDown
  <<
    {
      < c c, >2~\arpeggio  q8
    } \\ {
      %\set Voice.fontSize = #-2 \hideNotes \grace c8 %workaround shift arpeggio horizontally
    }
  >>
  r8 \tuplet 3/2 { c16 des c } b16 c
  h4 < fis fis' >2\arpeggio gis'8 fis
  < f,! g'! >2\arpeggio( q8 ) b8\noBeam
  \tuplet 3/2 { f16 ( ges f } e f
  \tupletSpan 4
  \tuplet 3/2 { fis8 b, h cis d fis }
  b a
  \allgShift #'(0 . 5.5 ) Voice TextScript
  as\prall^\markup { \fontsize #-3 \flat } ges f2 ) r8
  %\slurShiftx #'(0 . 4) #'(-1 . 1)
  f'8~ ( f f8
  < e, e' >4\arpeggio cis'8 e gis4 fis8\prall^\markup { \fontsize #-4 \sharp } e
  < es, es'>2~ ) q8 r \tuplet 3/2 { es'16 ( dis es } d es
  \tuplet 3/2 { e!8 gis, a c des e }
  as g
  \allgShift #'(0 . 8.5) Voice TextScript
  fis\prall^\markup { \fontsize #-4 \sharp } e
  < es es, >2\arpeggio~ ) q8\noBeam es8~ es es
  < es es, >2\arpeggio~ q8\noBeam es8~ es es
  <<
    { es1 } \\ \relative c {
      r8 \clef bass
      \once \override Voice.Slur.height-limit = #4
      < es fis > ( < es gis > < es fis a >
      < fis a c > < fis a c des > < fis a c es > < a c es f! >
      \clef treble
      \stemNeutral
      \set Voice.beatStructure = #'(4 4)
      < a c es fis >8 < c es fis as >< c es fis a > < es fis a c >
      < es fis a cis>< es fis as c es > <fis a c e > < fis gis c f! > )
    }
  >> \bar "||"
  \key des \major
  < as,, des f as >2. < e e' >8 ( < f f' > )
  < as c f as >2. < e e' >8 ( < f f' > )
  < as ces f as >2. \tuplet 3/2 { < b b' >8 ( < as as' > < b b' > ) }
  <<
    \relative c'' {
      \voiceOne
      \set subdivideBeams = ##f
      < as b es as >4^( ges'4 ) s4 <c, c,>8--\noBeam < des des,>--
      < d, a' d as'! >4\arpeggio ( < fis fis'>8 )
      s8 s8
      \slurUp \stemDown
      < gis gis' >4 ( < fis fis' >8
      \stemUp
      < f as c f >2 )
      s8 < f f' >8\noBeam (

      < fis fis' >16 < f f'> < e e' > < f f' > )
    } \\ \relative c'' {
      \voiceTwo
      \tupletSpan 4
      \set Voice.baseMoment = #(ly:make-moment 1/8)
      \set Voice.beatStructure = #'(4 4 )
      s8 r32 ges b es ges ges, b es ges b es
      \ottava #1
      \set Staff.ottavation = #"8"
      ges b ges \ottava #0
      es b ges es b ges c, ges' es b \showStaffSwitch
      \set subdivideBeams=##f
      \set Voice.baseMoment = #(ly:make-moment 1/4)
      \set Voice.beatStructure = #'(1 1 1 1 )
      \change Staff="down" ges\noBeam [ es b ges ]
      \tuplet 6/4 { des16 a' d fis a d }
      \change Staff="up"
      \tuplet 6/4 { fis16 a d fis a d }
      \tuplet 5/4 { fis32 d a fis d }
      \set Voice.baseMoment = #(ly:make-moment 1/8)
      \set Voice.beatStructure = #'(2 2 1 1 1 1)
      s4
      s4 \tuplet 3/2 { r16 f, as }
      \tuplet 6/4 {
        c f as c \myottava #1
        f as
      }
      \tuplet 5/4 { c32 as f \ottava #0 c as }
    }
  >>
  < e, g! h e >4 ( < h' e g! h >4. )
  < cis cis' >8 ( < b b' >4 < b es g b >2) s8
  \once \override Slur.height-limit = #4
  < b b'>8 (
  \set subdivideBeams = ##f
  < h h'>16 < b b'> < a a'> < b b' >
  \tuplet 3/2 { < h e g h >8 ) < dis, dis' > ( < e e' > < g g' > < gis gis' > < h h' > }
  \set beatStructure = #'(4 4 )

  < dis g h dis > < d d'> < cis cis'> < h h' >
  < b es g b >2 ) s8
  <<
    {
      \override Slur.height-limit = #4
      \stemDown < b b'>4
      ( q8
      \stemUp
      < a d fis a >4 ) < fis fis' >8 (  < a a' > < dis d fis cis' >4
      < h h' >8 < a a' >8 < as des f as >2 )
    } \\ {
      s4 s8
      \tuplet 3/2 { r8 <des f > q }
      s4
      \tuplet 3/2 { r8 q q }
    }
  >>
  \revert Slur.height-limit
  \stemNeutral
  s8 as'8\noBeam ( < a a, >16 < as as, > < g! g,! > < as as, >
  \set Voice.beatStructure = #'(2 2 2 2)
  \tuplet 3/2 {
    < a, d fis a >8 < cis cis, > < d d, >
    < eis eis,> < fis fis, > < a a,>
  }
  < c, f cis' > < c! c'! >
  \allgShift #'(0 . 6) Voice TextScript
  < h h'>\prall^\markup { \fontsize #-4 \sharp } < a a'>
  < a d f a >2 )
  s8 as'4 ( < as as,>8
  \bar "||"
  \key c \major
  < gis, h! e! gis >2 )
  s8 gis'4~ < gis gis, >8
  < gis, h e gis>8. < g h e g >16 < gis h e gis >8. < ais h e ais >16
  < gis h e gis>8. < g h e g >16 < gis h e gis>8. < a h e a >16
  < gis h e gis>8. < g h e g >16 < gis h e gis >8. < ais h e ais >16
  \tuplet 3/2 {
    < cis d e gis cis >8-> ( < h h'> < ais ais'> < a a'> < gis gis' > < g g'> )
    < f! as ces f!>( < es as ces es > < f! as ces f!>)
    < as ces es as > ( < f ces' es f > < as ces es as > )
    < ces es f ces' > ( < as es' f as > < ces es f ces' > )
    < es f as es' > ( < ces f as ces > < es f as es' > )
  }
  < f as ces f >4
  \once \override BreathingSign.Y-offset = #4
  \override Slur.height-limit = #3
  \breathe < h h, >-> q-> q->
  <<
    \relative c'' {
      < h h' >4-> ( < ais ais' >)
      < ais ais' > ( < a a'> )
      < gis gis' >2-> ( < g g' >~ q4 )
    } \\ \relative c'' {
      < cis e! >2 < c es > < a cis >1
    }
  >>
  e,4\fermata ( dis cis a gis g e dis cis a gis
  g1~ ) g1 r1
}

DY= {
  s1
}

%% Stimme LH mit ganzen Noten
VoiceIII= \relative c {
  <as es' as c >1\arpeggio
  \clef treble
  as'' < c, es g > < c es ges >
  < b des f > < a! cis e > < ges c es >
  \clef bass
  < fis h d > < f b d > < e ais cis >
  \clef treble < gis cis e a >\arpeggio
  r1 s1 s1 s1
  \clef bass
  < as f' > s1
  \clef treble
  %\once \override NoteColumn.force-hshift = #1
  < as es' >\arpeggio
  < gis d' > q < gis, d' > q
  < gis' e'> < as es' > < gis e'!>
  as as as,,
}

%% Stimme LH mit halben Noten
VoiceIIII= \relative c' {
  \voiceTwo
  s1 as2 as as as as as
  as as as as as as
  \once \override NoteColumn.force-hshift = #1 gis
  gis
  \once \override NoteColumn.force-hshift = #1 as
  as
  \once \override NoteColumn.force-hshift = #1 gis gis
  s1 s1
  % \set PianoStaff.connectArpeggios = ##f
  < as as' >2 as2 < as g'! > as < as ges' >\arpeggio as
  s1
  < gis e'! >2 r2 s1 s1 s1 s1 s1
}

%% Stimme LH mit Achtelnoten
VoiceII = \relative c' {
  s1 s s s
  \change Staff="up" \stemDown \slurDown
  r8 f ( < b des > f ) r f ( q f )
  r8 e ( < a cis > e ) r e ( q e )
  r es ( < g c > es ) r es ( q es )
  r d ( < fis h > d ) r d ( q d )
  \change Staff="down"
  \stemNeutral
  s1 s1 s1 s1
  f'8\rest as, ( < c es > as ) f'8\rest as, ( q as )
  f'8\rest as, ( q as ) f'8\rest as, ( q as )
  f'8\rest as, ( q as ) f'8\rest as, ( q as )
  r as,, ( b des f a! b des )

  r8 cis ( < e a > cis )
  #(ly:expect-warning "Zusammen")
  r cis ( q cis )
  g''8\rest es, ( < g as c > es ) g'8\rest es, ( < g as c > es )
  g'8\rest fis, ( < h d > fis ) g'8\rest fis, ( q fis )
  g'8\rest f,! ( < as b d > f ) g'8\rest f, ( q f )
  \clef bass h,8\rest \clef treble gis ( < d' fis h > gis, )
  g''8\rest gis,, ( < d' fis h > gis, )
  \clef bass h8\rest \clef treble gis ( < d' f b > gis, )
  g''8\rest gis,, ( < d' f b > gis, )
  h'8\rest e, ( < gis a cis > e ) h'8\rest e,(  < gis a cis > e )
  h'8\rest es, ( < g as c > es ) h'8\rest es, ( < g as c > es )
  h'8\rest e, ( < gis a cis > e ) h'8\rest e, ( < gis a cis > e )
  h'8\rest es, ( < g a c > es ) h'8\rest es, ( < g a c > es )
  h'8\rest es, ( < ges a c > es ) h'8\rest es, ( < ges a c > es )
  \clef bass
  d,8\rest < c as > q q q < as cis > < as dis > < c es f >
  < c es fis > < dis fis gis > < dis fis a! > < dis fis a c > < dis fis a cis>
  < dis fis a c es > < fis a c e > < fis gis c f >
  \override TupletBracket.bracket-visibility = #'if-no-beam
}

LHDes=
\relative c, {
  \key des \major
  \tupletSpan 4
  \set Voice.baseMoment = #(ly:make-moment 1/4)
  \set Voice.beatStructure=#'(1 1 1 1)
  \tuplet 6/4 {
    < des des, >16 as' des f as des \clef treble f as des f as des
    f des as f des as
    \clef bass
    f des as f des as
    des,16 as' c f as c
  }
  \set Voice.baseMoment = #(ly:make-moment 1/8)
  \set Voice.beatStructure=#'(2 2 2 2)
  %\set Voice.subdivideBeams=##f
  \clef treble f32 as c f as c
  \ottava #1
  \set Staff.ottavation = #"8"
  f as c as f \ottava #0 c as f c as
  \clef bass
  \set Voice.subdivideBeams=##f
  \tuplet 6/4 {
    des,16 c as f c as
    des, as' ces f as ces
  }
  \set Voice.subdivideBeams=##t
  \clef treble
  f32 as ces f as ces
  \myottava #1
  f as ces as f  \ottava #0 ces as f ces as
  \clef bass
  \set Voice.subdivideBeams=##f
  \tuplet 6/4 { des,16 ces as f ces as }
  \tuplet 5/4 { des,32 b' es ges b } < es, es' >8--
  < f f' >-- < ges ges' >-- < as as' >-- < b b' >--
  s4 s4  s8 \clef treble < cis cis' >8 ( < c c' > )
  \tuplet 3/2 { r16 a' fis }
  \clef bass
  \tuplet 6/4 { d16 a fis d a fis }
  \tuplet 5/4 { des32 as' c f as }
  c8\noBeam ( < f f, > < ges ges, > < as as, >\noBeam )
  \stemDown
  \clef treble \tuplet 3/2 { f16 c' as } \clef bass
  \tuplet 5/4 { c, as f c as }
  \stemNeutral
  \mytuplet 6/4 { des, h' e g h c }
  \clef treble
  es32 b' es g b %\myottava #1
  es g b

  \mytuplet 5/4 { g es b g es }
  \stemDown
  \tuplet 3/2 { r16 h g }
  \clef bass
  \override Voice.Accidental.stencil = #(ly:make-stencil empty-stencil)
  \mytuplet 6/4 { e16 h g e h g }
  \revert Voice.Accidental.stencil
  \mytuplet 6/4 { des16 b' es g b es }
  \clef treble
  g32 b es g b \myottava #1 es g b
  \mytuplet 5/4 { g [ es \ottava #0 b g es ]}

  \tuplet 3/2 { r16 g, es }
  \clef bass
  \mytuplet 6/4 { b g es b g es }
  des16 h' e g h e
  \clef treble g h e
  \override Voice.Accidental.stencil = #(ly:make-stencil empty-stencil)
  h g e
  \clef bass
  h g e h
  \revert Voice.Accidental.stencil
  \mytuplet 6/4 { des, b' es g b es }
  \clef treble
  %\set subdivideBeams = ##t
  g32[ b es g] b es \myottava #1 g b
  \tuplet 5/4 { g es \ottava #0 b g es }
  \clef bass
  \set Voice.baseMoment = #(ly:make-moment 1/8)
  \set Voice.beatStructure=#'(1 1 1 1 1 1 1 1)
  \tupletSpan 8
  \tuplet 3/2 { r16 g,16 es b g es } b g
  \tupletSpan 4
  \once \override Beam.skip-quanting = ##t
  \once \override Beam.beamed-stem-shorten = #'(0 0 0)
  \once \override Stem.no-stem-extend = ##t
  \mytuplet 3/2 {
    des?8 < a'' d fis > q q q q
    des,? q q q q q
  }
  \set Voice.beatStructure=#'(2 2 2 2)
  \stemNeutral

  \mytuplet 6/4 {
    des,16 as' des f as des
    \clef treble f as des f as des
  }
  f32 des as f \tuplet 3/2 { as,16 [ des as ]}
  \clef bass
  \set Voice.subdivideBeams=##f
  \tuplet 6/4 { f16 des as f des as }
  des,16 a' d fis \clef treble a d fis a des a fis d
  \override Voice.Accidental.stencil = #(ly:make-stencil empty-stencil)
  \clef bass a fis d a
  \revert Voice.Accidental.stencil
  \mytuplet 6/4 { des,16 as' des f as des }
  \clef treble
  \tuplet 3/2 { f as des }
  \myottava #1 f32 as des f
  \tuplet 5/4 { as f des as f }
  \ottava #0
  \tuplet 3/2 { as,16[ des as] }
  \clef bass
  \mytuplet 6/4 { f des as f des as }
  \key c \major
  \mytuplet 6/4 {
    cis,16 h' e gis h e
    \clef treble gis h e g! h e
  }
  \tuplet 5/4 { gis32 [ e h g e] }
  \tuplet 3/2 { gis,16 h gis }
  \clef bass
  \mytuplet 6/4 { e16 h gis e h gis }
  \tuplet 3/2 {
    < d d, >8 < d gis h> < gis h e >
    < d' gis h > < gis h e > < d gis h >
    r < d, gis h > < gis h e >
    < d' gis h > < gis h e > < d gis h >
    r < d, gis h > < gis h e > < d' gis h > < gis h e > < d gis h >
    < cis' d e gis > h ais a gis g
    < es, as ces es > < es' as ces > < f as ces> < as ces es > <f ces' es> < as ces es>
    \clef treble
    \stemNeutral
    < ces es f > < as es' f > < ces es f >
    < ces es f > < as es' f > < ces es f >
  }
  < f as ces >4 h,-> h-> h->
  \clef bass
  <<
    \relative c' {
      < cis e >2-> < ais ais' > < ais cis >1
    } \\ \relative c' {
      h4 ais ais a gis2 ( g~ g4 )
    }
  >>
  r4\fermata r2
  \override Rest.X-offset = #8
  r1 r1
  \revert Rest.X-offset
  r4 e, ( dis cis )
  <<
    \relative c {
      \set Voice.beatStructure = #'( 2 2 2 2)
      \tupletSpan 4
      \tuplet 3/2 {
        gis8 e' a cis a e r e a cis a e
        
      }
    } \\ \relative c {
      gis1
    }
  >>
}


% hier kommt die Dateistruktur als eigene Stimme
% für Zeilenumbrüche etc.
Struktur =
{
  s1 * 4 \break
  s1 * 4 \break
  s1 * 4 \break
  s1 * 4 \break
  s1 * 3 \pageBreak
  s1 * 3 \break
  s1 * 3 \break
  s1 * 3 \break
  s1 * 2 \break
  s1 s2 \bar "" \break
  s2 s1 \pageBreak
  s1 s2 s4 \bar "'" \break
  s4 s1 s2 \bar "'" \break
  s2 s1 s2 \bar "'" \break
  s2 s1 s2 \bar "'" \break
  s4 s4 s1 s2 s4 \bar "'" \break
  s4 s1 \break
  s1 s1 s1 \pageBreak
  s1 * 6 \break
}

\score
{
  \new PianoStaff
  <<
    \set PianoStaff.connectArpeggios = ##t
    \new Staff = "up"
    <<
      \set Staff.instrumentName= "R.H."
      \set Staff.shortInstrumentName =""
      \clef treble
      \key c \major
      \new Voice="Noten" \VoiceI
      \new Voice="breaks" \Struktur
    >>
    \new Staff = "down"
    {
      <<
        \set Staff.instrumentName= "L.H."
        \set Staff.shortInstrumentName =""
        \clef bass
        \new Voice \VoiceII
        \new Voice \VoiceIII
        \new Voice \VoiceIIII
      >>
      \LHDes
    }
  >>
  \header {
    piece = \markup { \fontsize #2 \bold "Piano" }
    %opus = \markup { \italic "Adagio" }
  }
  \layout {
  }
  %{
  \midi {
    \context {
      \ChordNames
      \remove "Staff_performer"
    }
  }
  %}
}
