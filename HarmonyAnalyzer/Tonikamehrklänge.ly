\version "2.19.37"

#(use-modules (scm display-lily))

\language "deutsch"
\include "myExceptions.ily"
\include "myScheme.ily"
\include "VollstndigeChordliste.ly"
\include "myHarmonyAnalyse.ily"

#(set-global-staff-size 18)

book-init =
\book {
  %% book paper, which is inherited by all children bookparts
  \paper {
    #(set-paper-size "a4")
    ragged-last-bottom = ##f
    %ragged-last = ##t
    line-width = 190
    left-margin = 10
    bottom-margin = 10
    top-margin = 10
    ragged-right = ##f
    %annotate-spacing = ##t
    %system-system-spacing.basic-distance = #10
    %system-system-spacing.minimum-distance = #8
    %system-system-spacing.extra-distance = #0
    %system-system-spacing.padding = #1
    %score-system-spacing.basic-distance = #0
    %last-bottom-spacing.basic-distance = #20
    print-first-page-number = ##f
    indent = 0
  }
  \header {
    title = ""
    parttagline = "Part tagline"
    copyright = \markup \fill-line {
      \abs-fontsize #9 { \FootLeft }
      % \abs-fontsize #7.0 { \italic { \FootCenter } }
      \abs-fontsize #9 { \FootRight }
    }
    copyright =\markup \abs-fontsize #7 "Copyright Manuela G."

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
          "So ziemlich"
          "alle"
          "Mehrklänge"
          "auf die Tonika"

          "in allen"
          "Dur-Tonleitern"
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
}

#(define format-key-info-markup
   (lambda (root-1 scale-1 root-2 scale-2 root-3 scale-3)
     (markup
      ;#:bold
      (let ((german-strg
             (format #f "~a ~a"
               root-1
               (symbol->string scale-1))))
        (if (eq? scale-1 'Moll)
            german-strg
            german-strg)))))

\layout {
  \context {
    \Score
    \remove "Bar_number_engraver" % Taktnummerierung
    \override RehearsalMark.self-alignment-X = #LEFT
    \override KeyCancellation.break-visibility = #'#(#f #f #f)
    %\override NonMusicalPaperColumn.page-break-permission = ##f
    proportionalNotationDuration = #(ly:make-moment 1/2)
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
    printKeyCancellation = ##f
    explicitKeySignatureVisibility = ##(#f #f #t)
  }
  \context {
    \Voice
    \override TextScript.padding = #0
    \override TextScript.direction = #UP
    \override TextScript.font-size = #3
    \override TextScript.font-series = #'bold %normal
  }
}

annotateKey =
#(define-music-function (mrkp-1)(markup?)
   #{
     \once \override TextScript.before-line-breaking =
     #(lambda (grob)
        (ly:grob-set-property! grob 'text
          (markup #:line (mrkp-1 (ly:grob-property grob 'text)))))
     \once \override TextScript.annotate-key = ##t
   #})


#(define (sim-music ev-chrd p m)
   ;; Return a list of sublists containing scores
   (map
    (lambda (t)
      (scorify-music
       #{
         \transpose c $t
         <<
           \new Voice \with { \consists #annotate-key-engraver }
           {
             \key $p \major
             \annotateKey
             \markup #(format #f "Mehrklänge mit Grundton ~a in "
                        (string-capitalize
                         (symbol->string (note-name->lily-string t))))
             $m \bar "|."
           }
           \new ChordNames $m
         >>
       #}))
    (event-chord-pitches ev-chrd)))

#(define (scores ev-chrd tonics chrds)
   ;; process `sim-music' and reorder the result

   (define (reorder-list ls rl)
     ;; '((1 2 3)(a b c)(x y z))
     ;; -> '((1 a x)(2 b y)(3 c z))
     (if (every null? ls)
         (reverse rl)
         (reorder-list
          (map cdr ls)
          (cons (map car ls) rl))))

   (let ((lst
          (reverse
           (map
            (lambda (tonic music) (sim-music ev-chrd tonic music))
            (event-chord-pitches tonics)
            chrds))))

     (reorder-list lst '())))

MeineTonleiter= { <c d e f g a h > }
%CChordsGDur={ \transpose c c' { \ChordsInScale \CChords \transpose c g \MeineTonleiter } }

print-book =
#(define-void-function (which tonics chords)(ly:music? ly:music? list?)
   ;; add all bookparts to `book-init'
   (for-each
    (lambda (bp) (ly:book-add-bookpart! book-init bp))
    ;; wrap all scores in every sublist of (scores which chords) into a bookpart
    (map ly:make-book-part (scores which tonics chords)))
   ;; process the book to make it ready for output
   (ly:book-process
    book-init
    $defaultpaper
    $defaultlayout
    (ly:parser-output-name)))

\print-book
<c g d a e h, fis ges des as es b f>
<g c f b es as des>
#(list
  #{
    \transpose c c' { \ChordsInScale \CChords \transpose c g \MeineTonleiter }
    \transpose c c' { \ChordsInScale \CChords \MeineTonleiter }
    \transpose c c' { \ChordsInScale \CChords \transpose c f \MeineTonleiter }
    \transpose c c' { \ChordsInScale \CChords \transpose c b \MeineTonleiter }
    \transpose c c' { \ChordsInScale \CChords \transpose c es \MeineTonleiter }
    \transpose c c' { \ChordsInScale \CChords \transpose c as \MeineTonleiter }
    \transpose c c' { \ChordsInScale \CChords \transpose c des \MeineTonleiter }
  #}
  )
