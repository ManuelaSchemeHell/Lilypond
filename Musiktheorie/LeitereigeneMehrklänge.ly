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
  indent = #0
  ragged-last-bottom = ##t
  ragged-last = ##f
  ragged-bottom = ##t
  line-width = #170
  page-count = #1
  top-margin = #30

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
    %\remove "Key_engraver"
    \override TextScript.direction = #UP
    \override KeySignature.break-visibility = #all-invisible
    \override Staff.printKeyCancellation = ##f
    %\override Staff.explicitKeySignatureVisibility = #end-of-line-invisible
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
       \override TextScript.font-size = #2
       \override TextScript.font-series = #'bold %normal
       \override TextScript.padding = #-10
       \override TextScript.outside-staff-priority = ##f
       \consists #annotate-key-engraver
       \override annotate-key-engraver.outside-staff-priority = ##f
     }
     {
       \omit Staff.KeySignature
       \omit Staff.Clef
       \omit Staff.TimeSignature
       \omit Staff.BarNumber
       \omit Staff.BarLine
       \override  Staff.StaffSymbol.line-count = #0
       \stopStaff
       \textLengthOn
       \key $Pitch1 \major
       \annotateKeyRoot $mkup s1 %\markup "Leitereigene" s1
       \key $Pitch2 \major
       \annotateKey \markup "-Mehrklänge in" s1 s1-$mkup   s1 s1 s1
     }
      >>
      <<
        \new Voice { \break $mus }
      >>
   #}
   )

MeinLeiterHeader =
#(define-music-function (Pitch mkup mus)
   (ly:pitch? markup? ly:music?)
   #{
     <<
       \new Voice \with {
         \override TextScript.direction = #UP
         \override TextScript.font-size = #3
         \override TextScript.font-series = #'bold %normal
         \override TextScript.padding = #-8
         \override TextScript.outside-staff-priority = ##f
         \consists #annotate-key-engraver
         \override annotate-key-engraver.outside-staff-priority = ##f
         \override TextScript.extra-offset = #'(0 . -3)
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
         \key $Pitch \major
         \annotateKey  \markup "Leitereigene Mehrklänge in" s1 s1-$mkup  s1 s1
         \stopStaff
       }
     >>
     <<
       \new Staff
       {
         \break
         $mus
       }
     >>
   #}
   )

MehrDur =
<<
  \new Voice
  {
    <<
      \new Voice
      {
        \key c \major
        \DurLeitereigeneDreiklaenge \bar "|." \break
      }
      %%{
      \new Voice \with {
        \override TextScript.direction = #UP
        \override TextScript.font-size = #1.5
        \override TextScript.font-series = #'normal
        \override TextScript.self-alignment-X = #CENTER
        \override TextScript.padding = #6
        \override Score.RehearsalMark.padding = #0
        \override TextScript.outside-staff-priority = #1000
        \override Score.RehearsalMark.outside-staff-priority = ##f
      }
      {
        \mark \markup \fontsize #1.2 "Dreiklänge "
        s1^\markup "Stufe I" s1^"II"  s1^"III"
        s1^"IV"  s1^"V"  s1^"VI"  s1^"VII"
        \startStaff
      } %}
      \new ChordNames
      {
        \DurLeitereigeneDreiklaenge \bar "|." \break
      }
    >>
    <<
      \new Voice
      {
        \key c \major
        \mark \markup \fontsize #1.2 "Vierklänge "
        \DurLeitereigeneVierklaenge \bar "|." \break
      }
      \new ChordNames
      {
        \DurLeitereigeneVierklaenge
      }
    >>
    <<
      \new Voice
      {
        \key c \major
        \mark \markup \fontsize #1.2 "Fünfklänge"
        \DurLeitereigeneFuenfklaenge \bar "|." \break
      }
      \new ChordNames
      {
        \DurLeitereigeneFuenfklaenge
      }
    >>
  }
>>

MehrMoll =
<<
  \new Voice
  {
    <<
      \new Voice
      {
        \tocItem \markup {  "Moll" }
        \key c \minor
        \MollLeitereigeneDreiklaenge \bar "|." \break
      }
      \new Voice \with {
        \override TextScript.direction = #UP
        \override TextScript.font-size = #1.5
        \override TextScript.font-series = #'normal
        \override TextScript.self-alignment-X = #CENTER
        \override TextScript.padding = #6
        \override Score.RehearsalMark.padding = #0
        \override TextScript.outside-staff-priority = #1000
        \override Score.RehearsalMark.outside-staff-priority = ##f
      }
      {
        \mark \markup \fontsize #1.2 "Dreiklänge"
        s1^\markup "Stufe I" s1^"II"  s1^"III"  s1^"IV"  s1^"V"  s1^"VI"  s1^"VII"
      }
      \new ChordNames
      {
        \MollLeitereigeneDreiklaenge \bar "|." \break
      }
    >>
    <<
      \new Voice
      {
        \key c \minor
        \mark \markup \fontsize #1.2 "Vierklänge "
        \MollLeitereigeneVierklaenge \bar "|." \break
      }
      \new ChordNames
      {
        \MollLeitereigeneVierklaenge
      }
    >>
    <<
      \new Voice
      {
        \key c \minor
        \mark \markup \fontsize #1.2 "Fünfklänge"
        \MollLeitereigeneFuenfklaengeh \bar "|." \break
      }
      \new ChordNames
      {
        \MollLeitereigeneFuenfklaengeh
      }
    >>
  }
>>

EineSeite =
{
  \MeinLeiterHeader c "-Dur"  \MehrDur
  \transpose c a, {
    \MeinLeiterHeader c "-Moll" \MehrMoll
  }
  \transpose c c {
    \MeinLeiterHeader c "-Moll" \MehrMoll
  }
  \pageBreak
}

MeineTonarten = { c g d }
FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootRight = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))

\book {
  %% book paper, which is inherited by all children bookparts
  \paper {
    #(set-paper-size "a4")
    ragged-last-bottom = ##t
    line-width = 170
    left-margin = 20
    bottom-margin = 10
    top-margin = 10
    ragged-right = ##f
    %annotate-spacing = ##t
    system-system-spacing.basic-distance = #5
    system-system-spacing.minimum-distance = #15
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
        "(Fast Alle)"
        " "
        \fontsize #1.4 "Leitereigenen"
        " "
        \fontsize #1.4  "Drei-, Vier-"
        \line { "und" \fontsize #1.8  " " }
        \fontsize #1.4 "Fünfklänge"
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
    \markuplist \table-of-contents
    %\markup \wordwrap { with ragged-last-bottom (see the space below this text) }
  }

  \bookpart {
    \score {
      {
        \multipleTransposes { c g d a, e h, fis ges des as, es b, f } \EineSeite
        %\multipleTransposes { c g   des f } \EineSeite
      }
    }
  }
  \myContext
}
