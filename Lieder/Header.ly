\version "2.19.37"
\language "deutsch"
Absatz=#0.5
smallerNoteHead= #-1.5
%KommSingMit=\markup { \italic "Komm sing mit 2" }
%myFont=#"MS Mincho"
%myFont=#"TeX Gyre Heros"
%myFont=#"Oranda BT"
myFont=#"Palatino Linotype"
%myFont=#"Cambria Math"
%myFont=#"Georgia"
%myFont=#"DejaVu Serif"
%myFont=#"Monospac821 BT"

#(set-global-staff-size 18)

FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))

leftbrace = \set stanza = \markup {
  \translate #'(0 . -1) "1. "
  \hspace #-0.5
  \translate #'(0 . -0.6) \left-brace #25
}

rightbrace = \set stanza = \markup {
  " "
  \hspace #-17
  \translate #'(0 . 0.4) \right-brace #25 \hspace #8 "1.-3."
}

dropLyrics = {
  \override LyricText.extra-offset = #'(0 . -1.5)
  \override LyricHyphen.extra-offset = #'(0 . -1.5)
  \override LyricExtender.extra-offset = #'(0 . -1.5)
  \override StanzaNumber.extra-offset = #'(0 . -1.5)
}

undropLyrics= {
  \revert LyricText.extra-offset
  \revert LyricHyphen.extra-offset
  \revert LyricExtender.extra-offset
}

\paper {
  #(set-paper-size "a4")
  annotate-spacing = ##f
  top-margin = 25\mm
  ragged-right = ##f
  ragged-bottom = ##t
  bottom-margin = 5\mm
  indent = #0
  line-width = 150\mm
  #(include-special-characters)
  print-all-headers = ##t
  % system-system-spacing.minimum-distance = #60 %50
  %system-system-spacing.extra-distance = #10
  %system-system-spacing.basic-distance = #50 %30
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
  tocItemMarkup = \tocItemWithDotsMarkup
  first-page-number = #0
  print-first-page-number = #f
  %% Abstand von Liedtext zu nachfolgender Überschrift
  markup-markup-spacing  = #'((basic-distance . 5)
                              (padding . 5)
                              (stretchability . 0))

  %% Abstand des Textes nach den Noten
  score-markup-spacing  = #'((basic-distance . 3)
                             (padding . 3)
                             (stretchability . 0))
  %{
  #(define fonts
    (set-global-fonts
      #:music "emmentaler"
      #:brace "emmentaler"
      #:roman "Century Schoolbook L"
      #:sans "sans-serif"
      #:typewriter "monospace"
      #:factor (/ staff-height pt 20)
  ))
  %}
}
\layout {
  \context {
    \Voice
    \name FirstVoice
    \alias Voice
    autoBeaming = ##f
    \override NoteCollision.merge-differently-dotted = ##t
    \override NoteCollision.merge-differently-headed = ##t
    \override Stem.direction = #UP
    \override Slur.direction = #UP
    \override Tie.direction = #UP
    \override NoteColumn.horizontal-shift = #0
  }
  \context {
    \Voice
    \name SecondVoice
    \alias Voice
    \remove "Slur_engraver"
    autoBeaming = ##f
    \override NoteCollision.merge-differently-dotted = ##t
    \override NoteCollision.merge-differently-headed = ##t
    \override NoteHead.font-size = #smallerNoteHead
    \override Stem.direction = #DOWN
    \override Tie.direction = #DOWN
    \override NoteColumn.horizontal-shift = #0
  }
  \context {
    \Staff
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    %\consists Mark_engraver
    \override StaffSymbol.thickness = #0.5 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
    \accepts FirstVoice
    \accepts SecondVoice
    \consists "Bar_number_engraver"
    \override BarNumber.break-visibility = #end-of-line-invisible
    \override BarNumber.outside-staff-priority =#'()
    \override BarNumber.padding = #1
    \override BarNumber.self-alignment-X = #CENTER
    % \set Beam.autoBeaming = ##f
    %\remove System_start_delimiter_engraver
  }
  \context {
    \StaffGroup
    \remove System_start_delimiter_engraver
    \accepts AltLyrics
  }
  \context {
    \Lyrics
    \name AltLyrics
    \alias Lyrics
    \override StanzaNumber.font-series = #'medium
    \override LyricText.font-shape = #'italic
    \override LyricText.color = #(x11-color 'grey20)
  }
  \context {
    \Score
    %\remove Bar_number_engraver
    \remove System_start_delimiter_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override RehearsalMark.outside-staff-priority=##f
    \override RehearsalMark.extra-offset = #'(-3 . 4)
    \override SpacingSpanner.base-shortest-duration =
    #(ly:make-moment 1/16)
    \remove "Bar_number_engraver"
    startRepeatType = #"|"
    endRepeatType = #":|"
    doubleRepeatType = #":|:"
    beamExceptions = #'()
  }
  \context {
    \ChordNames
    chordNameLowercaseMinor = ##f
    majorSevenSymbol = \markup { maj7 }
    chordChanges = ##f
    \override ChordName.font-name = \myFont
    \override ChordName.font-series = #'bold
    \germanChords
    alignAboveContext = #"leadsheet"
  }
  \context {
    \Voice
    \override NoteCollision.merge-differently-dotted = ##t
    \override NoteCollision.merge-differently-headed = ##t
    beamExceptions = #'()
    autoBeaming = ##f
  }
}

\markuplist \table-of-contents \pageBreak
smallerNoteHead= #-1.5
slurShifts=
#(define-music-function (amount offsets)
   (pair? pair?)
   #{
     \once \override Slur.positions =
     #(lambda (grob)
        `(,(+ (car offsets) (cdar (ly:slur::calc-control-points grob))) .
           ,(+ (cdr offsets) (cdr (cadddr (ly:slur::calc-control-points grob))))))
     \once \override Voice.Slur.extra-offset = $amount
   #}
   )
