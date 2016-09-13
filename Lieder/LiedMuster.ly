\version "2.19.37"
\language "deutsch"
Absatz=#0.5
smallerNoteHead= #-1.5
KommSingMit=\markup { \italic "Komm sing mit 2" }
%myFont=#"MS Mincho"
myFont=#"TeX Gyre Heros"
%myFont=#"Oranda BT"
%myFont=#"Palatino Linotype"
%myFont=#"Cambria Math"
%myFont=#"Georgia"
%myFont=#"DejaVu Serif"
%myFont=#"Monospac821 BT"

#(set-global-staff-size 18)

FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))
\paper {
  #(set-paper-size "a4")
  annotate-spacing = ##f
  top-margin = 25\mm
  ragged-right = ##f
  ragged-bottom = ##f
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
}
\layout {
  \context {
    \name FirstVoice
    \type "Engraver_group"
    \alias Voice
    \consists "Note_heads_engraver"
    \consists "Text_engraver"
    \consists "Stem_engraver"
    \consists "Beam_engraver"
    \consists "Slur_engraver"
    \consists "Rest_engraver"
    \consists "Breathing_sign_engraver"
    \consists "Dots_engraver"
    \consists "Rhythmic_column_engraver"
    \consists "Script_engraver"
    %\consists "Script_column_engraver"
    %\consists "Dynamic_engraver"
    autoBeaming = ##f
    \override NoteCollision.merge-differently-dotted = ##t
    \override NoteCollision.merge-differently-headed = ##t
    \override Stem.direction = #UP
    \override Slur.direction = #UP
    \override Tie.direction = #UP
    \override NoteColumn.horizontal-shift = #0
  }
  \context {
    \name SecondVoice
    \type "Engraver_group"
    \alias Voice
    \consists "Note_heads_engraver"
    \consists "Text_engraver"
    \consists "Stem_engraver"
    \consists "Beam_engraver"
    \consists "Slur_engraver"
    \consists "Rest_engraver"
    \consists "Dots_engraver"
    \consists "Rhythmic_column_engraver"
    autoBeaming = ##f
    \override NoteCollision.merge-differently-dotted = ##t
    \override NoteCollision.merge-differently-headed = ##t
    \override NoteHead.font-size = #smallerNoteHead
    \override Stem.direction = #DOWN
    \override Slur.direction = #DOWN
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
    % \set Beam.autoBeaming = ##f
    %\remove System_start_delimiter_engraver
  }
  \context {
    \StaffGroup
    \remove System_start_delimiter_engraver
  }
  \context {
    \Score
    %\remove Bar_number_engraver
    \remove System_start_delimiter_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override RehearsalMark.outside-staff-priority=##f
    \override RehearsalMark.extra-offset = #'(-3 . 4)
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

myTitel="LiedTitel1"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  c
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  c
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  c
}
%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) = \markup
{
  \hspace #5
  \override #'(line-width . 85)
  \left-column
  {
    "Frisch auf drum, frisch auf drum im hellen Sonnenstrahl"
    "wohl über die Berge, wohl durch das tiefe Tal."
    "Die Quellen erklingen, die Bäume rauschen all;"
    "mein Herz ist wie ’ne Lerche und stimmet ein mit Schall."
     \vspace #Absatz

  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. " ca
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = "aus Tirol"
     composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Christian Wilhelm Kindleben (1748-1786), Halle 1781"
        "Deutscher Text: Johann Christian Günther (1695-1723), 1717"
        "Melodie: Studentenlied, ursprünglich mittelalterliches Bußlied, 1788"
      }
    }
    piece = #KommSingMit
    opus = "S. 294"
  }

}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)
