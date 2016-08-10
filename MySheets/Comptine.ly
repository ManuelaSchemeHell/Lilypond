\version "2.18.2"

\header{
  % title = "Etüde Op. 38, Nr. 15"
  composer = "Yann Tiersen"
  title = "Comptine D'Un Autre Été L'Aprés Midi"
  subtitle = "(Long version)"
  tagline = "fra filmen om Amélie Poulain"
}
\language "deutsch"
\include "myScheme.ily"
%A4 21 cm x 29,7 cm = 8.27 x 11.69 in
FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))
#(set-global-staff-size 20)
%#(set! paper-alist (cons '("mein Format" . (cons (* 8.27 in) (* 11.69 in))) paper-alist))

\paper {
  #(set-paper-size "a4")
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
  annotate-spacing = ##f
  %left-margin = #15
  %page-count = #4
  top-margin = #10
  ragged-right = ##f
  bottom-margin = #10
  indent = #15
  last-bottom-spacing.basic-distance = #10
  %left-margin = #15
  line-width = #180
  #(include-special-characters)
}

\layout {
  \context {
    \ChordNames
    chordNameLowercaseMinor = ##f
    chordRootNamer = #germanChords
    chordNoteNamer = #note-name->german-markup
    \override ChordName.font-name = #"Orator10 BT" %% groß und schlank, wirkt modern; definitiv interessant
    \override ChordName.font-size = #-0.3
    \override ChordName.font-series = #'bold %medium, bold, bold-narrow
  }
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
    \once \override Staff.OttavaBracket.outside-staff-priority = #'()
    \once \override Staff.OttavaBracket.Y-offset = 0
    \once \override Staff.OttavaBracket.extra-offset = #'(0 . 8)
    %\override OttavaBracket.padding = #5
    %\override OttavaBracket.staff-padding = #6
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    \consists Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override StaffSymbol.thickness = #0.5 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
  }
  \context {
    \Dynamics
    \override DynamicLineSpanner.staff-padding = #3
    \override TextScript.staff-padding = #3
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
    \Voice
    % \override Hairpin.thickness = #2.5
    %\override PhrasingSlur.padding = #4
    \override PhrasingSlur.outside-staff-priority = #150
    \override Slur.outside-staff-priority = #150
    %\override Beam.beam-thickness = #0.4 % 0.48
    %\override Slur.line-thickness = #0.5 % 0.8
    %\override Tie.line-thickness = #0.5
    %\override Script.stencil = #bold-tenuto-script-stencil
  }
}

RH = \relative c'' {
  \time 4/4
  \numericTimeSignature
  \clef treble \tempo "Andante" 4=100
  \key g \major
  \set Timing.beamExceptions = #'()
  \set Timing.baseMoment = #(ly:make-moment 1/4)
  \set Staff.beatStructure = #'(1 1 1 1 )  %% abhängig vom Takt

  %\autoBeamOff % wenn das Timing richtig gewählt wurde, kann \autoBeamOff weggelassen werden
  %\set Staff.beatStructure = #'(1 1 1 1) % abhängig vom Takt
  %wird hier die Länge der automatischen Balken gewählt, ausprobieren ob 1 oder 2
  % hier kommt die Melodie
  {

    r1
    R | % 3
    R | % 4
    R \bar ".|:"
    | % 5
    r8  g16(-1 fis-2
    g8-1 h16 c  h2 ) | % 6
    r8 fis16^(  g  fis8  g16 a  g2 ) | % 7
    r8  fis16 (  e  fis8   h16 c  h2 ) | % 8
    r8 fis16^( e fis2.)
    \bar ":|."
    | % 9
    \slurShiftx #'(0 . 0) #'(0 . -4)
    e'4.^(-3 h8 ~ h2)-1
    d4.( h8 ~ h2) | % 11
    fis'4.( h,8 ~ h2) | % 12
    fis'4.( a,8 ~ a2) | % 13
    < h-2 g'-5 >4.( < g-1 e'-4 >8~  < g e' >2) | % 14
    < h g' >4.( < g d' >8~  < g d' >2) | % 15
    < h fis' >4.( < fis d' >8~ < fis d' >2) | % 16
    < a fis' >4.( < fis d' >8~ < fis d' >2)
    \repeat volta 2 {
      | % 17
      h16-> e h' h, e h' h, e h' h,
      e h'
      \once \override Tie.staff-position = #3.5
      h,(->
      e c-> e
      h)->  d h' h,  d  h' h, d  h'  h,
      d h'  h,->   d a-> d  | % 19
      fis,->  h fis' fis,  h  fis' fis, h
      fis'  fis, h fis'  fis,  h g h
    }

    \alternative {
      {
        a->  d a' a,  d  a' a, d  a'
        a, d a'  a,->  d g,-> d'
      }
      {
        | % 21
        a->  d a' a,  d  a' a, d  a'
        a, d a'  a,  d a'8
      }
    } | % 22
    \ottavaShifts #'( ( 0 . 9) (0 . 9.5) (0 . 10.5) (0 . 11.5) ;22-32
                      (0 . 12) (0 . 11) ( 0 . 13) (0 . 12) (0 . 12) ; 36-45
                      (0 . 8) ( 0 . 8) (0 . 8) ( 0 . 8) (0 . 8) ( 0 . 8) ; 47-57
                      (0 . 8.5) ( 0 . 8) (0 . 8.5) ( 0 . 8.5) (0 . 13) ( 0 . 10) ; 59-75
                      )
    \ottava #1 | % 22
    e(-1  g16-3 fis-2  g8-3  h16-4 c
    h2 ) | % 23
    r8 fis16^(-2 g-3 fis8 g16 a  g2 ) | % 24
    r8 fis16^(-2 e fis8  h16-4 c  h2 ) | % 25
    r8 fis16^(-2 e fis2.) | % 26
    r8 < e^1 g-3>16^(  fis-2  g8-3  h16-4 c-5  < e,-1 h'-4 >2 ) | % 27
    r8 < d^1 fis-2 >16^(  g-3  fis8-2  g16-3 a-4  < d,-1 g-3 >2 ) | % 28
    r8 < d^1 fis-3 >16^(  e-2  fis8-3  h16-4 c-5  < d,-1 h'-4 >2 ) | % 29
    r8 < d^1 fis-3 >16^(  e-2  < d fis >2. ) |
    e'4.-4 ( h2-1 ) e16-4 (  h-1  | % 31
    d4.-3 h8 ~ h2-1 ) | % 32
    fis'4.-4 ( h,2-1 ) d16-2 (  e-3  | % 33
    fis4.-4 a,8-1 ~ a2 ) | % 34
    < h^2 g'-5 >4. ( < g-1 e'-4 >8~ < g e' >2) | % 35
    < h^2 g'-5 >4. ( < g-1 d'-3 >8 ~ < g d' >2 ) | % 36
    < h^2 fis'-5 >4. ( < fis d' >8 ~  < fis d' >2 ) | % 37
    < a fis' >4.^( < fis d' >8 ~  < fis d' >2)
    \repeat volta 2 {
      | % 38
      h16->^(-1  e-2 h'-5 h,  e  h' h, e  h'  h,
      e h'  h,->-1   e-2 c->-1 e-2  | % 39
      h->-1   d-2 h'-5 h,  d  h'-5 h,-1 d-2  h'-5  h,-1
      d h'  h,  d a d  |
      fis,->-1  h-4 fis'-5 fis, h  fis' fis, h
      fis'  fis, h fis'  fis,->  h g-> h
    }
    \alternative {
      {
        | % 41
        a->-1  d-2 a'-5 a,  d  a' a, d  a'
        a, d a'  a,->-1  d-2 g,->-1 d')-2
      }
      {
        | % 42
        a->-1( d-2 a'-5 a,  d  a' a, d  a'
        a, d a'  a,  d a' a,
      }
    }
    \bar ":..:"
    | % 43
    g'->-5 g,-1 h-2 e-4 g,  h g' g,  h  e
    g, h  g'-> g, a'->  g,  | % 44
    g'-> g, h d  g,  h g' g,  h  d
    g, h  g'->    g, d'->  e  | % 45
    fis->   fis, h d  fis,  h fis' fis,
    h  d fis, h  fis'->    fis, e' -> fis,  | % 46
    fis'    fis, a d  fis,  a fis' fis,  a
    d fis, a  fis'    fis, e'  fis,)
    \bar ":..:"
    | % 47
    \stemDown
    e'-5-> e,-1 g-2 h-3  e, g e'-5 e,  g  h
    e, g  e'-5-> e,-1 h'-3->  e,-1  | % 48
    \stemNeutral
    d'-> d, g h  d,  g d' d, g h
    d, g  d'-> e, h'->  d,  | % 49
    d'-> d, fis h  d,  fis d' d,  fis
    h d, fis  d'->  d, h'->  d,  |
    d'    d, fis a  d,  fis d' d,  fis
    a-5 d,-1 fis  d'   d, a'  d,
    \bar ":..:"
    | % 51
    < h e h' >8. < h e g >16~ q8 < h e h' >8~ q16 e16 h e  < h e h' >8
    < h e c' >
    <h d h'>8. <h d g>16~ q8 < h d h' >8~ q16 d16 h d  < h d h' >8 <a d a'>
    <fis h d fis>8. <fis h d fis>16~ q8 <fis h d fis>8~ q4 <fis h fis'>8  <g h g'>
    <a d fis a>8. <a d fis a>16~ q8 <a d fis a>8~ q4 <a d a'>8  <g d' g>
    \bar ":..:"
    r  <g h e>8~ q16 < h e g >16~ q8  < e g h >8. < g h e >16~ q8  < h e g >8
    r8 <h d g>8~ q16 < g h d >8. < d g h >8. < h d g >16~ q8 < g h d >8  | % 57
    r  <fis h d>8~ q16 <h d fis>8. <d fis h>8. <fis h d>16~ q8 <h d  fis >8  | % 58
    r  <a d fis>8~ q16 <fis a d>8. <d fis a>  <a d fis>16~ q8 <fis a d>8 \bar ":|."
    < e' g >^(  g16 fis  g8  h16 c  h2) | % 64
    r8  fis16^(  g  fis8  g16 a  g2) | % 65
    r8  fis16^(  e  fis8  h16 c  h2) | % 66
    r8  fis16^(  e  fis2. ) | % 67
    r8  < e g >16^(  fis g8  h16 c < e, h' >2) | % 68
    r8  < d fis >16^(  g fis8 g16 a < d, g >2) | % 69
    r8  < d fis >16^(  e fis8 h16 c < d, h' >4.) d16^(  e
    |
    < d fis > e fis8 ~  fis2.)
    \bar ".|:"
    | % 71
    < h g' >4.^( < g e' >8~ < g e' >2 ) | % 72
    < h g' >4.^( < g d' >8~ < g d' >2 ) | % 73
    < h fis' >4.^( < fis d' >8~  < fis d' >2 ) | % 74
    < a fis' >4.^( < fis d' >8~ < fis d' >2 )
    \bar ":..:"
    \repeat volta 2 {
      | % 75
      h16(-> e h' h,  e h' h, e  h'  h,
      e h'  h,->   e c->  e  | % 76
      h-> d h' h,  d  h' h, d  h'  h,
      d h'  h,->   d a->  d  | % 77
      fis,->-1 d'-2 fis-5 fis,  d'  fis fis, d'
      fis fis, d' fis  fis,->-1 d' g,->-1  d'
    }
    \alternative {
      {
        | % 78
        a->-1 d-2 a'-5 a, d a' a, d a'
        a, d a'  a,-> d g,->  d')
      }
      {
        | % 79
        \slurShifts #'(0 . -2) #'(-2 . 1)
        a(->\mf   d_"ritardando..." a' a,  d
        a' a, d  a'  a, d a'_"nota... a... nota..."\p   a,
        d a' g)
      }
    } |
    < g, h e>1\pp   \arpeggio \arpeggio \arpeggio \ottava #0 \bar "|."
  }
}

DY= {
  s
  \p s
  \< s \!
  s
  \> s \!
  \mf  s8 \< s16 \! s s8 \> s16 s s4 s \!
  s8 \< s16 \! s s8 \> s16 s s4 s \!
  s8 \> s16  s s8  s16 s s4 s \!
  s1
  \p s \< s \! s \> s \!
  \mf s \< s \! s \> s \!
  \mf s \< s \!
  s \> s2 \! \>
  s-\markup {
    \italic "ritardando"
  } \!
  s-\markup {
    \italic "a tempo"
  } s s1
  \< s \!
  s s s s s s \p s
  \< s \!
  s \> s \! \mf
  s \< s \!
  s s \mf
  s \< s \!
  s
  \> s \! \> s \!
  \p s s1*26 s1 \p
  s \< s \! s \> s \!

}


LH = \relative c {
  \clef bass
  \key g \major
  \set Timing.beamExceptions = #'()
  \set Timing.baseMoment = #(ly:make-moment 1/4)
  \set Staff.beatStructure = #'(1 1 1 1 )  %% abhängig vom Takt

  \repeat unfold 5
  <<
    {
      e'8 h e h e h e h d h d h d h d h
      d h d h d h d a d a d a d a d a
    } \\
    {
      e4 g e g d g d g d fis d fis d fis d fis
    }
  >>
  <<
    {
      d'8 a d a d a d a
    } \\
    {
      d,4 fis d fis
    }
  >>
  \repeat unfold 5
  <<
    {
      e'8 h e h e h e h d h d h d h d h
      d h d h d h d a d a d a d a d a
    } \\
    {
      e4 g e g d g d g d fis d fis d fis d fis
    }
  >>

  <<
    {
      d'8 a d a d a d a
    } \\
    {
      d,4 fis d fis
    }
  >>
  \repeat unfold 8
  {
    <<
      {
        e'8 h e h e h e h d h d h d h d h
        d h d h d h d a d a d a d a d a
      } \\
      {
        e4 g e g d g d g d fis d fis d fis d fis
      }
    >>
  }
  <<
    {
      d'8 a d a d a d a
    } \\
    {
      d,4 fis d fis
    }
  >>
  < e h' e >1   \arpeggio \arpeggio \arpeggio
}


% hier kommt die Dateistruktur als eigene Stimme
% für Zeilenumbrüche etc.
Struktur =
{
  s1 * 4 \break
  s \break
  s \break
  s \break
  s1 * 2 \pageBreak
  s1 * 2 \break
  s1 * 3 \break
  s1 * 4 \break
  s \break
  s \pageBreak
  s1 * 3 \break
  s1 * 2 \break
  s \break
  s \break
  s \pageBreak
  s1 * 2 \break
  s \break
  s1 * 2 \break
  s1 * 2 \break
  s1 * 2 \break
  s \pageBreak
  s1 * 4 \break
  s \break
  s \break
  s1 * 2 \break
  s  \break
}

AK = {
  \chordmode {
    % \germanChords
    e1:m g:m/d h:m/d d
    e:m g:7/d h:m/d d
    e:m g/d h:m/d d
    e:m g/d b:m/d d
    e:m g:9/d b:m/d d:11 d
    e:m g:7/d h:m/d d
    e:m g:7/d h:m/d d
    e:m g:7/d h:m/d d
    e:m g:7/d h:m/d d
    e:m g:9/d h:m/d d:11 d
    e:m g:9/d h:m/d d:11
    e:m g:9/d h:m/d d:11
    e:m g:9/d h:m/d d:11
    e:m g:9/d h:m/d d:11
    e:m g:7/d h:m/d d
    e:m g:7/d h:m/d d
    e:m g/d h:m/d d
    e:m g:9/d h:m/d d:11 d:11 e:m
  }
}

\score

{
  \new PianoStaff
  <<
    \context ChordNames \AK
    \new Staff \with {
      \consists Bar_number_engraver
      \override BarNumber.break-visibility = #end-of-line-invisible
      \override BarNumber.padding = #0
      \override BarNumber.self-alignment-X = #CENTER
    }
    <<
      \new Voice = "upper"  \RH
      \new Voice\Struktur
      \new Dynamics \DY
      %  \new Lyrics \lyricsto "upper" { \StropheII }
    >>
    \new Staff = "Bass" \LH
  >>
  \header {
    piece = \markup { \fontsize #2 \bold " " }
    opus = \markup { \italic "fra filmen om Amélie Poulain" }
  }
  \layout {
  }
  \midi {
    \context {
      \ChordNames
      \remove "Staff_performer"
    }
  }
}
