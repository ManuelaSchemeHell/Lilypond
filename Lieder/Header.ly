\version "2.19.37"

\language "deutsch"
Absatz=#0.5
smallerNoteHead= #-1.5

myFont=#"Palatino Linotype"

#(set-global-staff-size 18)

FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))

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

#(define-markup-command (my-header layout props arg)
   (markup?)
   #:properties ((thickness 1) (offset 2)
                  (font-size 0)
                  (word-space 1)
                  (baseline-skip 2))
   (let* ((thick (ly:output-def-lookup layout 'line-thickness))
          (underline-thick (* thickness thick ))
          (increment 2)
          (m (interpret-markup layout
               (prepend-alist-chain 'font-family 'sans
                 (cons
                  `((baseline-skip . ,(* baseline-skip (magstep increment)))
                    (word-space . ,(* word-space (magstep increment)))
                    (font-size . ,(+ font-size increment)))
                  props))
               arg))
          (m2 (ly:stencil-scale m 1.1 1))
          (x1 (car (ly:stencil-extent m2 X)))
          (x2 (cdr (ly:stencil-extent m2 X)))
          (y (* thick (- offset) (magstep increment)))
          (line (make-line-stencil underline-thick x1 y x2 y)))
     (ly:stencil-add m2 line)))

#(define-markup-command (page-ref layout props label gauge default)
   (symbol? markup? markup?)
   #:category other
   (let* ((gauge-stencil (interpret-markup layout props gauge))
          (x-ext (ly:stencil-extent gauge-stencil X))
          (y-ext (ly:stencil-extent gauge-stencil Y)))
     (ly:stencil-add
      (make-transparent-box-stencil x-ext y-ext))
     (ly:make-stencil
      `(delay-stencil-evaluation
        ,(delay (ly:stencil-expr
                 (let* ((table (ly:output-def-lookup layout 'label-page-table))
                        (page-number (if (list? table)
                                         (assoc-get label table)
                                         #f))
                        (number-type 'arabic) ;(ly:output-def-lookup layout 'page-number-type))
                        (page-markup (if page-number
                                         (number-format number-type page-number)
                                         default))
                        (page-stencil (interpret-markup layout props page-markup))
                        (gap (- (interval-length x-ext)
                               (interval-length (ly:stencil-extent page-stencil X)))))
                   (interpret-markup layout props
                     (markup #:hspace gap page-markup))))))
      x-ext
      y-ext)))

#(define-markup-list-command (index layout props) ()
   (cons (interpret-markup layout props
           (ly:output-def-lookup layout 'indexTitleMarkup))
     (space-lines (chain-assoc-get 'baseline-skip props)
       (map (lambda (index-item)
              (let ((label (car index-item))
                    (index-markup (cadr index-item))
                    (text (caddr index-item)))
                (interpret-markup
                 layout
                 (cons (list (cons 'index:page
                               (markup #:page-ref label "XXX" "?"))
                         (cons 'index:text text))
                   props)
                 (ly:output-def-lookup layout index-markup))))
         (index-items)))))

%%%%%%%%%% wird nicht verwendet, trotzdem eingefügt um Fehlermeldungen zu vermeiden
#(define-public (add-index-item! markup-symbol text sorttext) #f)
#(define-public (index-items) #f)

#(let ((index-item-list (list)))
   (set! add-index-item!
         (lambda (markup-symbol text sorttext)
           (let ((label (gensym "index")))
             (set! index-item-list
                   ;; We insert index items sorted from the beginning on and do
                   ;; not sort them later - this saves pretty much computing time
                   (insert-alphabetical-sorted!
                    (list label markup-symbol text sorttext)
                    index-item-list))
             (make-music 'EventChord
               'page-marker #t
               'page-label label
               'elements (list (make-music 'LabelEvent
                                 'page-label label))))))
   (set! index-items (lambda ()
                       index-item-list)))

#(define (insert-alphabetical-sorted! iitem ilist)
   (if
    (null? ilist) (list iitem)
    (if
     (string-ci<? (cadddr iitem) (cadddr (car ilist))) (cons iitem ilist)
     (cons (car ilist) (insert-alphabetical-sorted! iitem (cdr ilist)))
     )
    )
   )

indexItem =
#(define-music-function (parser location sorttext text) (string? markup?)
   (add-index-item! 'indexItemMarkup text sorttext))

%%%%%%%%%%%%%%%%%%%%%%%%%%%
#(set! paper-alist (cons '("mein Format" . (cons (* 8.27 in) (* 11.9 in))) paper-alist))
%\bookpart {
\paper {
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
}

tocAct =
#(define-music-function (text) (markup?)
   (add-toc-item! 'tocActMarkup text))

\bookpart {
  \paper {
    annotate-spacing = ##f
    top-margin = 15\mm
    top-markup-spacing.padding = 20
    ragged-right = ##f
    ragged-bottom = ##t
    ragged-last-bottom = ##t
    bottom-margin = 10\mm
    indent = #0
    line-width = 120\mm
    #(include-special-characters)
    %print-all-headers = ##t
    page-number-type = #'roman-upper
    print-page-number = ##t
    first-page-number = #1
    print-first-page-number = ##t
    % system-system-spacing.minimum-distance = #60 %50
    %system-system-spacing.extra-distance = #10
    %system-system-spacing.basic-distance = #50 %30
    oddFooterMarkup = \markup \fill-line {
      \abs-fontsize #7 { \FootLeft }
    }
    tocItemMarkup = \tocItemWithDotsMarkup
    tocActMarkup = \markup \fontsize #1 \column {
      \hspace #1
      \line { \italic \fromproperty #'toc:text \null }
      \hspace #1
    }
    tocTitleMarkup = \markup \column {
      \fontsize #4 \sans \bold \fill-line { \null "Liederverzeichnis" \null }
      \hspace #1
    }
    % {%%%%%%%%% wird nicht verwendet, trotzdem eingefügt um Fehlermeldungen zu vermeiden
    indexTitleMarkup = \markup \column {
      \fontsize #5 \sans \bold \fill-line { \null "Alle Lieder alphabetisch sortiert" \null }
      \hspace #1
    }
    indexItemMarkup = \markup \fill-line {
      \fill-with-pattern #1 #RIGHT .
      \fromproperty #'index:text
      \fromproperty #'index:page
    }
%%%%%%%%%%%%%%%%%%%%%%%%%%%}
  }
  \markuplist \table-of-contents
  \pageBreak
  \markuplist \index
}
\midi {
  \context {
    \Staff
    \remove "Staff_performer"
  }
  \context {
    \Voice
    \consists "Staff_performer"
  }
  \context {
    \ChordNames
    \remove "Staff_performer"
  }
  \tempo 4 = 100
}

\layout {
  \context {
    \Voice
    beamExceptions = #'()
    autoBeaming = ##f
    \override BreathingSign.text =
    \markup { \musicglyph #"scripts.lvarcomma" }
    \consists "Staff_performer"
    %\override NoteColumn.horizontal-shift = #0
    \override NoteColumn.ignore-collision = ##t
  }
  \context {
    \Voice
    \name FirstVoice
    \alias Voice
    autoBeaming = ##f
    \override Stem.direction = #UP
    \override Slur.direction = #UP
    \override Tie.direction = #UP
    %\override NoteColumn.horizontal-shift = #0
  }
  \context {
    \Voice
    \name SecondVoice
    \alias Voice
    \remove "Slur_engraver"
    \remove "Tuplet_engraver"
    \remove "Rest_engraver"
    \remove "Multi_measure_rest_engraver"
    % alignBelowContext = #"firstvoice"
    autoBeaming = ##f
    \override NoteHead.font-size = #smallerNoteHead
    \override Stem.direction = #DOWN
    \override Tie.direction = #DOWN
    \override PhrasingSlur.direction = #DOWN
    %\override NoteColumn.horizontal-shift = #0
  }
  \context {
    \Voice
    \name ThirdVoice
    \alias Voice
    \remove "Slur_engraver"
    \remove "Tuplet_engraver"
    \remove "Rest_engraver"
    \remove "Multi_measure_rest_engraver"
    \remove "Stem_engraver"
    \remove "Beam_engraver"
    % alignBelowContext = #"firstvoice"
    autoBeaming = ##f
    \override NoteHead.font-size = #smallerNoteHead
    \override Tie.direction = #DOWN
    %\override NoteColumn.horizontal-shift = #0
  }
  \context {
    \Voice
    \name KanonVoice
    \alias Voice
    %autoBeaming = ##f
    \override TextScript.direction = #UP
    \override BreathingSign.text =
    \markup { \musicglyph #"scripts.lvarcomma" }
    %\consists "Staff_performer"
  }
  \context {
    \Staff
    %explicitClefVisibility = #end-of-line-invisible
    %explicitKeySignatureVisibility = #end-of-line-invisible
    %\consists Mark_engraver
    \override StaffSymbol.thickness = #0.5 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
    \accepts FirstVoice
    \accepts SecondVoice
    \accepts ThirdVoice
    \accepts KanonVoice
    \consists "Bar_number_engraver"
    \override BarNumber.break-visibility = #end-of-line-invisible
    \override BarNumber.outside-staff-priority =#'()
    \override BarNumber.padding = #1
    \override BarNumber.self-alignment-X = #CENTER
    beamExceptions = #'()
    \override BreathingSign.text =
    \markup { \musicglyph #"scripts.lvarcomma" }
  }
  \context {
    \Staff
    \name KanonStaff
    \alias Staff
    \override TextScript.outside-staff-priority=##f
    \override TextScript.staff-padding = #1
    \override TextScript.X-offset = #-0.5
    \override TextScript.font-size = #1
    \override TextScript.font-encoding = #'fetaText
    \override TextScript.direction = #UP
    \remove "Bar_number_engraver"
    \accepts KanonVoice
  }
  \context {
    \StaffGroup
    \remove System_start_delimiter_engraver
    \accepts AltLyrics
    \accepts KanonStaff
  }
  \context {
    \Lyrics
    \override LyricText.font-size =#1
  }
  \context {
    \Lyrics
    \name AltLyrics
    \alias Lyrics
    \override StanzaNumber.font-series = #'bold
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

}

\paper {
  annotate-spacing = ##f

  top-margin = 15\mm
  ragged-right = ##f
  ragged-bottom = ##t
  ragged-last-bottom = ##t
  bottom-margin = 10\mm
  indent = #0
  line-width = 150\mm
  print-all-headers = ##t
  #(include-special-characters)
  %print-all-headers = ##t
  page-number-type = #'arabic
  print-page-number = ##t
  first-page-number = #1
  print-first-page-number = ##t
  %% Abstand von Liedtext zu nachfolgender Überschrift
  markup-markup-spacing  = #'((basic-distance . 12)
                              (minimum-distance . 5)
                              (padding . 5)
                              (stretchability . 40))
  score-markup-spacing  = #'((basic-distance . 12)
                             (minimum-distance . 5)
                             (padding . 5)
                             (stretchability . 40))
}

\include "zusammen.ly"

%\include "__\lobtfroh.ly"
