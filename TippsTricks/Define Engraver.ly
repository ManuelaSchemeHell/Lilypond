http://www.lilypondforum.de/index.php?topic=1948.msg10655#msg10655
http://www.lilypondforum.de/index.php?topic=2205.0
http://lsr.di.unimi.it/LSR/Item?u=1&id=856

\version "2.19.17"

%% Nicer output while debugging:
%#(use-modules (ice-9 pretty-print))
\version "2.19.36"

\layout {
  \context {
    \Voice
    \consists
      #(let ((notes '()))
         (make-engraver
           (listeners
            ((note-event engraver event)
              (set! notes (cons event notes))))
           ((finalize engraver)
               (write-me "\nHow-many-notes? " (length notes))
               (set! notes '()))))
  }
}

\score {
  \new Staff \repeat unfold 13 c''1
}

\score {
  \new Staff \repeat unfold 17 des''1
}

%% LIMITATION: can't distuingish between minor- and aeolian-scale

scales = 
#(list major minor ionian locrian aeolian mixolydian lydian phrygian dorian)

scales-names =
#'(major minor ionian locrian aeolian mixolydian lydian phrygian dorian)

german-scale-names =
#'(Dur Moll Ionisch Lokrisch Äolisch Mixolydisch Lydisch Phrygisch Dorisch)

french-scale-names =
#'(majeur mineur ionien locrien éolien mixolydien lydien phrygien dorien)

#(define (define-grob-property symbol type? description)
  (if (not (equal? (object-property symbol 'backend-doc) #f))
      (ly:error (_ "symbol ~S redefined") symbol))

  (set-object-property! symbol 'backend-type? type?)
  (set-object-property! symbol 'backend-doc description)
  symbol)

#(for-each
  (lambda (x)
    (apply define-grob-property x))
    `((annotate-key
      ,boolean?
      "Print a markup annotation with the actual used key
in german, french, english")))

#(define (alteration->text-accidental-markup alteration)
  (make-smaller-markup
   (make-raise-markup
    (if (= alteration FLAT)
        0.3
        0.6)
    (make-musicglyph-markup
     (assoc-get alteration standard-alteration-glyph-name-alist "")))))

#(define (accidental->markup alteration)
  "Return accidental markup for ALTERATION."
  (if (= alteration 0)
      (make-line-markup (list empty-markup))
      (make-line-markup
        (list
          (alteration->text-accidental-markup alteration)
          (make-hspace-markup 0.1)))))

#(define-public (note-name->string pitch)
  "Return pitch markup for @var{pitch}."
  (make-concat-markup
   (list
    (make-simple-markup
      (vector-ref #("C" "D" "E" "F" "G" "A" "B") (ly:pitch-notename pitch)))
    (accidental->markup (ly:pitch-alteration pitch)))))
       
#(define (note-name->german-string pitch)
  "Return string for @var{pitch}, using German note names."
  (define (pitch-alteration-semitones pitch)
   (inexact->exact (round (* (ly:pitch-alteration pitch) 2))))

  (let* ((name (ly:pitch-notename pitch))
         (alt-semitones  (pitch-alteration-semitones pitch))
         (n-a (if (equal? (cons name alt-semitones) '(6 . -1))
                  (cons 7 alt-semitones)
                  (cons name alt-semitones))))
   (string-append
       (vector-ref #("C" "D" "E" "F" "G" "A" "H" "B") (car n-a))
     (let ((alteration (/ (cdr n-a) 2)))
       (cond
          ((and (= alteration FLAT) (= (car n-a) 7)) 
            "")
          ((and (= alteration FLAT) (or (= (car n-a) 5) (= (car n-a) 2) ))
            "s")
          ((= alteration FLAT) "es")
          ((and (= alteration DOUBLE-FLAT) (or (= (car n-a) 5)(= (car n-a) 2)))
            "ses")
          ((= alteration DOUBLE-FLAT)
            "eses")
          ((= alteration SHARP)
            "is")
          ((= alteration DOUBLE-SHARP)
            "isis")
          (else ""))))))
           
#(define (note-name->french-string pitch)
  "Return string for @var{pitch}, using French note names."

  (let* ((name (ly:pitch-notename pitch))
         (alteration (ly:pitch-alteration pitch)))
    (string-append
        (vector-ref #("Do" "Ré" "Mi" "Fa" "Sol" "La" "Si") name)
        (cond
           ((= alteration FLAT) "-bémol")
           ((= alteration DOUBLE-FLAT) "-double bémol")
           ((= alteration SHARP) "-diése")
           ((= alteration DOUBLE-SHARP) "-double diése")
           (else "")))))
                 
annotate-key-engraver =
#(lambda (context)
 (let ((tonic '())
       (scale-name '())
       (german-scale-name '())
       (french-scale-name '())
       (annotate-key-tweak? #f))
         
  `((listeners
      (rhythmic-event
        .
        ,(lambda (engraver event)
          (if (null? tonic)
              (ly:warning (_ "\tno \\key set, skipping"))
              (let* ((new-text-script-grob
                       (ly:engraver-make-grob engraver 'TextScript event))
                     (german-root-name (note-name->german-string (car tonic)))
                     (french-root-name (note-name->french-string (car tonic)))
                     (english-root-name (note-name->string (car tonic)))
                     (annotate-key?
                       (ly:grob-property new-text-script-grob 'annotate-key)))
                       
                (if (and annotate-key? (not (null? annotate-key?)))
                    (ly:grob-set-property! new-text-script-grob 'text                     
                      (format-key-info-markup
                        german-root-name german-scale-name
                        french-root-name french-scale-name
                        english-root-name scale-name))
                    (ly:grob-suicide! new-text-script-grob))))))
               
      (key-change-event
        .
        ,(lambda (engraver event)
          (let* ((context (ly:translator-context engraver))
                 (pitch-alist (ly:event-property event 'pitch-alist))
                 (tonic-pitch (ly:context-property context 'tonic))
                 (c0-pitch-list
                   (ly:transpose-key-alist pitch-alist
                        (ly:pitch-diff (ly:make-pitch 0 0 0) tonic-pitch)))
                 (pos-scales-from-right (length (member c0-pitch-list scales)))
                 (scale
                   (car (take-right scales-names pos-scales-from-right)))
                 (german-scale
                   (car (take-right german-scale-names pos-scales-from-right)))
                 (french-scale
                   (car (take-right french-scale-names pos-scales-from-right))))
            ;; clear the following variables before proceeding
            (set! tonic '())
            (set! scale-name '())
            (set! german-scale-name '())
            (set! french-scale-name '())
           
            ;; newly assign them
            (set! tonic (cons tonic-pitch tonic))
            (set! scale-name scale)
            (set! german-scale-name german-scale)
            (set! french-scale-name french-scale))))
       
      (text-script-event
        .
        ,(lambda (engraver event)
          (if (null? tonic)
              (ly:warning (_ "\tno \\key set, skipping"))
              (let* ((tweaks (ly:event-property event 'tweaks))
                     (new-text-script-grob
                       (ly:engraver-make-grob engraver 'TextScript event))
                     (direction
                       (ly:event-property event 'direction 1))
                     (german-root-name (note-name->german-string (car tonic)))
                     (french-root-name (note-name->french-string (car tonic)))
                     (english-root-name (note-name->string (car tonic))))

                (if (member '(annotate-key . #t) tweaks)
                    (set! annotate-key-tweak? #t))
             
                (if annotate-key-tweak?
                    (begin
                      (ly:grob-set-property! new-text-script-grob 'direction
                        direction)
                      (ly:grob-set-property! new-text-script-grob 'text                   
                        (format-key-info-markup
                          german-root-name german-scale-name
                          french-root-name french-scale-name
                          english-root-name scale-name)))
                    (ly:grob-suicide! new-text-script-grob))
                   
                (set! annotate-key-tweak? #f)))))))))
               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXAMPLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#(define format-key-info-markup
   (lambda (root-1 scale-1 root-2 scale-2 root-3 scale-3)
     (markup
       #:bold
       (let ((german-strg
               (format #f "~a-~a_"
                 root-1
                 (symbol->string scale-1))))
         (if (eq? scale-1 'Moll)
             (string-downcase german-strg)
             german-strg))
       #:italic
       (format #f "~a ~a_"
         root-2
         (symbol->string scale-2))
       #:italic
       #:concat (
           root-3
           " "
           (symbol->string scale-3)))))

%% Short-cut for \once \override ...
annotateKey =
\once \override TextScript.annotate-key = ##t

%% Short-cut for \tweak ...
annotateKeyTweak =
#(define-event-function (parser location)()
#{
  -\tweak #'annotate-key ##t -""
#})

music =
  <<
    \new Voice
      \relative c' {
        \key d \major
        d1
        \key d \minor
        d
        \key e \minor
        e
        e
      }
  \new Voice
    \with {
      \override TextScript.direction = #UP
      \consists #annotate-key-engraver
    }
      {
        \key d \major
        \annotateKey
        s1
        \key d \minor
        s_\annotateKeyTweak
        \key e \minor
        s2
        \annotateKey
        s
        s1
      }	
  >>
