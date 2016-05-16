\version "2.19.37"

\language "deutsch"
\include "myExceptions.ily"
\include "myPitch2String.ily"
\include "myChordList.ily"
#(set-global-staff-size 18)

#(define format-key-info-markup
   (lambda (root-1 scale-1 root-2 scale-2 root-3 scale-3)
     (markup
      ;#:bold
      (let ((german-strg
             (format #f "~a"
               root-1
               (symbol->string scale-1))))
        (if (eq? scale-1 'Moll)
            german-strg
            german-strg)))))

myContext =  \layout {

  \context {
    \Score
    \remove "Bar_number_engraver" % Taktnummerierung
    \override RehearsalMark.self-alignment-X = #LEFT
    \override KeyCancellation.break-visibility = #'#(#f #f #f)
    \override TextScript.direction = #UP
    \override NonMusicalPaperColumn.page-break-permission = ##f
    proportionalNotationDuration = #(ly:make-moment 1/1)
  }
  \context {
    \ChordNames
    chordNameLowercaseMinor = ##f
    chordRootNamer = #germanChords
    chordNoteNamer = #note-name->german-markup
    \override ChordName.font-name = #"Monospac821 BT"
    chordNameExceptions = #chExceptions
    \override ChordName.font-size = #1
    \override ChordName.font-series = #'bold
  }
  \context {
    \Staff
    \remove "Time_signature_engraver"
    \override TextScript.direction = #UP
    \override KeySignature.break-visibility = #begin-of-line-visible
    \override Staff.printKeyCancellation = ##f
    explicitKeySignatureVisibility = #end-of-line-invisible
  }
  \context {
    \Voice
    \override TextScript.direction = #UP
    \override TextScript.font-size = #1.2
    \override TextScript.font-series = #'normal
    \override TextScript.padding = #0
    \override TextScript.outside-staff-priority = ##f
  }
}

MeinHeader =
#(define-music-function (Pitch1 Pitch2 mkup mus)
   (ly:pitch? ly:pitch? markup? ly:music?)
   #{ <<
     \new Voice \with {
       \override TextScript.direction = #UP
       \override TextScript.font-size = #3
       \override TextScript.font-series = #'bold %normal
       \override TextScript.padding = #-8
       \override TextScript.outside-staff-priority = ##f
       \consists #annotate-key-engraver
       \override annotate-key-engraver.outside-staff-priority = ##f
       \override TextScript.extra-offset = #'(0 . -7)
     }
     {
       \omit Staff.KeySignature
       \omit Staff.Clef
       \omit Staff.TimeSignature
       \omit Staff.BarNumber
       \omit Staff.BarLine
       \stopStaff
       \override  Staff.StaffSymbol.line-count = #0
       \startStaff
       \textLengthOn
       \key $Pitch1 \major
       \annotateKey  \markup "Mehrklänge mit Grundton" s1
       \key $Pitch2 \major
       \annotateKey \markup "in" s1 s1-$mkup   s1 * 10
       \stopStaff
     }
      >>
      <<
        \new Staff {
          \break
          \stopStaff
          \override  Staff.StaffSymbol.line-count = #5
          \startStaff
          $mus
        }
      >>
   #}
   )

MehrKlang =
<<
  \new Voice
  {
    <<
      \MeinHeader c g "-Dur" {
        <<
          \new Voice
          {
            \key g \major
            \CChordsGDur  \bar "|." \break
          }
          \new ChordNames
          {
            \CChordsGDur
          }
        >>
      }
    >>
    <<
      \MeinHeader c c "-Dur" {
        <<
          \new Voice
          {
            \key c \major
            \CChordsCDur  \bar "|." \break
          }
          \new ChordNames
          {
            \CChordsCDur
          }
        >>
      }
    >>
    <<
      \MeinHeader c f "-Dur" {
        <<
          \new Voice
          {
            \key f \major
            \CChordsFDur  \bar "|." \break
          }
          \new ChordNames
          {
            \CChordsFDur
          }
        >>
      }
    >>
    <<
      \MeinHeader c b "-Dur" {
        <<
          \new Voice
          {
            \key b \major
            \CChordsBDur  \bar "|." \break
          }
          \new ChordNames
          {
            \CChordsBDur
          }
        >>
      }
    >>
    <<
      \MeinHeader c es "-Dur" {
        <<
          \new Voice
          {
            \key es \major
            \CChordsEsDur  \bar "|." \break
          }
          \new ChordNames
          {
            \CChordsEsDur
          }
        >>
      }
    >>
    <<
      \MeinHeader c as "-Dur" {
        <<
          \new Voice
          {
            \key as \major
            \CChordsAsDur  \bar "|." \break
          }
          \new ChordNames
          {
            \CChordsAsDur
          }
        >>
      }
    >>
    <<
      \MeinHeader c des "-Dur" {
        <<
          \new Voice
          {
            \key des \major
            \CChordsDesDur  \bar "|." \stopStaff s1 *5 s1 s1 s1  \break
          }
          \new ChordNames
          {
            \CChordsDesDur
          }
        >>
      }

    >> \pageBreak
  }
>>

\book {
  %% book paper, which is inherited by all children bookparts
  \paper {
    #(set-paper-size "a4")
    ragged-last-bottom = ##t
    line-width = 190
    left-margin = 10
    bottom-margin = 10
    top-margin = 10
    ragged-right = ##f
    %annotate-spacing = ##t
    system-system-spacing.basic-distance = #10
    system-system-spacing.minimum-distance = #8
    system-system-spacing.extra-distance = #0
    system-system-spacing.padding = #1
    score-system-spacing.basic-distance = #0
    last-bottom-spacing.basic-distance = #20
    print-first-page-number = ##f
  }
  \header {
    title = ""
    %copyright = "Copyright Manuela Gößnitzer"
    parttagline = "Part tagline"
    copyright = \markup \fill-line {
      \abs-fontsize #9 { \FootLeft }
      % \abs-fontsize #7.0 { \italic { \FootCenter } }
      \abs-fontsize #9 { \FootRight }
    }
    copyright =\markup \abs-fontsize #7 "Copyright Manuela Gößnitzer"

    tagline = ""
  }
  \bookpart {
    %% a different page breaking function may be used on each part
    \paper { page-breaking = #ly:minimal-breaking }
    \header {
      %subtitle = "Alle leitereigenen Drei-, Vier- und Fünfklänge"
      title = \markup \fontsize #10 \center-column
      {
        " " " "
        \fontsize #1.4 {
          "(Fast Alle)"
          "Mehrklänge"
          "zu"
          "einem Grundton"
          { "in"  }
          "verschiedenen"
          "Tonleitern"
        }
      }

      copyright = \markup \fill-line {
        \abs-fontsize #9 { \FootLeft }
        % \abs-fontsize #7.0 { \italic { \FootCenter } }
        \abs-fontsize #9 { \FootRight }
      }
      tagline = ""
    }
    %\markup \fontsize #20 { The first book part }
    %\markup { a page break }
    \pageBreak
    \markup { first part last page }
    %\markuplist \table-of-contents
    %\markup \wordwrap { with ragged-last-bottom (see the space below this text) }
  }
  \bookpart {
    \score {
     % \multipleTransposes { c g d a e h, fis ges des as es b f } \MehrKlang
      \multipleTransposes { c g fis des f } \MehrKlang
    }

  }

  \myContext
}
