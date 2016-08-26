\version "2.19.37"
\language "deutsch"
\include "G:/Lilypond/_MyScheme/MusicFunctions.scm"
%\include "G:/Lilypond/_MyScheme/ChordList.ly"
%\include "G:/Lilypond/__MySheets/BassakkordeListe/allAccordionBasschords.ly"

#(define dm-circle 2)
#(define dist (/ dm-circle 12))
#(define h-dist (/ dm-circle 1))

#(define-markup-command (stradella-underline layout props arg)
   ( markup?)
   #:properties ((font-size 0) (thickness 2.5) (offset 3.5))
   (let*
    ((thick (* (magstep font-size) (ly:output-def-lookup layout 'line-thickness)))
     (underline-thick (* thickness thick))
     (markup (interpret-markup layout props arg))
     (x1 (car (ly:stencil-extent markup X)))
     (x2 (cdr (ly:stencil-extent markup X)))
     (y (* thick (- offset)))
     (line (make-line-stencil underline-thick x1 y x2 y)))
    (ly:stencil-add markup line)))

#(define bass-board
   (let* ((my-circle (make-circle-stencil dm-circle 0.1 #f))
          (cir-dist (+ (* 2 dm-circle) dist))
          (my-row
           (apply ly:stencil-add
             empty-stencil
             (map (lambda (x) (ly:stencil-translate-axis my-circle (* x cir-dist) X))
               (iota 20 0))))
          (my-board
           (apply ly:stencil-add
             empty-stencil
             (map (lambda (x)
                    (ly:stencil-translate my-row
                      (cons (* x h-dist) (* x cir-dist -1) )
                      ))
               (iota 6 0))
             ))
          )
     ;; proc body
     (write-me "ist stencil my-circle " (ly:stencil? my-circle))
     my-board
     ))

#(define (music-elts x)
   (if (not (ly:music? x))
       '()
       (ly:music-property x 'elements)))

#(define (music-name x)
   (if (not (ly:music? x))
       #f
       (ly:music-property x 'name)))

#(define (low-pitch music)
   ;; returns the lowest pitch from music
   (car (sort (all-pitches-from-music music) ly:pitch<?)))

#(define (high-pitch music)
   ;; returns the highest pitch from music
   (car (reverse (sort (all-pitches-from-music music) ly:pitch<?))))

#(define (pitch-between? p p1 p2)
   (and (not (ly:pitch<? p p1)) (not (ly:pitch<? p2 p))))

#(define (pitch-equals? p1 p2)
   ;(write-me "pitch-equals? ----------------------------> " (list p1 p2))
   (and
    (= (ly:pitch-alteration p1) (ly:pitch-alteration p2))
    (= (ly:pitch-notename p1) (ly:pitch-notename p2))))

#(define (naturalize-pitch p)
   ;; reduces alteration greater than a half tone step
   ;; #(display (naturalize-pitch #{ fes #}))
   ;; #<Pitch e >
   (let ((o (ly:pitch-octave p))
         (a (* 4 (ly:pitch-alteration p)))
         ;; alteration, a, in quarter tone steps,
         ;; for historical reasons
         (n (ly:pitch-notename p)))
     (cond
      ((and (> a 1)
            (or (eq? n 6)
                (eq? n 2)))
       (set! a (- a 2))
       (set! n (+ n 1)))
      ((and (< a -1)
            (or (eq? n 0) (eq? n 3)))
       (set! a (+ a 2))
       (set! n (- n 1))))
     (cond
      ((> a 2) (set! a (- a 4)) (set! n (+ n 1)))
      ((< a -2) (set! a (+ a 4)) (set! n (- n 1))))
     (ly:make-pitch o n (/ a 4))))

#(define (all-pitches-from-music music)
   "Return a list of all pitches from @var{music}."
   ;; Opencoded for efficiency.
   (reverse!
    (let loop ((music music) (pitches '()))
      (let ((p  (ly:music-property music 'pitch)))
        (if (ly:pitch? p)
            (cons (naturalize-pitch p) pitches)
            (let ((elt (ly:music-property music 'element)))
              (fold loop
                (if (ly:music? elt)
                    (loop elt pitches)
                    pitches)
                (ly:music-property music 'elements))))))))

#(define (standardize-pitch p)
   ;; make pitches with SHARPs or no alteration
   ;; standardize-pitch c ==> c
   ;; standardize-pitch cis ==> cis
   ;; standardize-pitch des ==> cis
   (let* ((p1 (naturalize-pitch p))
          (a (ly:pitch-alteration p1))
          (n (ly:pitch-notename p1))
          (o (ly:pitch-octave p1))
          (a1 (- a 0.5))
          (n1 (inexact->exact (+ n a1))))
     ;procedure body
     (if (= a 0)
         p1
         (ly:make-pitch o n1 SHARP))))

#(define (reduce-pitch p)
   ;; reduce pitch to octave 0
   (let* ((p1 (naturalize-pitch p))
          (a (ly:pitch-alteration))
          (n (ly:pitch-notename)))
     (ly:make-pitch 0 n a)))

#(define (list-all-chords-from-music music)
   ;; each element of the list is ly:music
   (reverse!
    (let loop ((music music) (pitches '()))
      (let ((p  (music-name music)))
        (if (eq? p 'EventChord)
            (cons  music pitches)
            (let ((elt (ly:music-property music 'element)))
              (fold loop
                (if (ly:music? elt)
                    (loop elt pitches)
                    pitches)
                (music-elts music))))))))

%% create complete pitchlist for a specific octave
#(define (pitch-list o)
   ;(display o)(newline)
   (list
    (ly:make-pitch o 0 0) ; c
    (ly:make-pitch o 0 SHARP) ; cis
    ;(ly:make-pitch o 1 FLAT) ; des
    (ly:make-pitch o 1 0) ; d
    (ly:make-pitch o 1 SHARP) ; dis
    ;(ly:make-pitch o 2 FLAT) ; es
    (ly:make-pitch o 2 0) ; e
    (ly:make-pitch o 3 0) ; f
    (ly:make-pitch o 3 SHARP) ; fis
    ;(ly:make-pitch o 4 FLAT) ; ges
    (ly:make-pitch o 4 0) ; g
    (ly:make-pitch o 4 SHARP) ; gis
    ;(ly:make-pitch o 5 FLAT) ; as
    (ly:make-pitch o 5 0) ; a
    (ly:make-pitch o 5 SHARP) ; ais
    ;(ly:make-pitch o 6 FLAT) ; b
    (ly:make-pitch o 6 0) ; h
    ))

#(define Q-circle ;; define circle of fifths as pitchlist
   (list
    (ly:make-pitch 0 6 DOUBLE-FLAT) ;; heses
    (ly:make-pitch 0 3 FLAT)        ;; fes
    (ly:make-pitch 0 0 FLAT)        ;; ces
    (ly:make-pitch 0 4 FLAT)        ;; ges
    (ly:make-pitch 0 1 FLAT)        ;; des
    (ly:make-pitch 0 5 FLAT)        ;; as
    (ly:make-pitch 0 2 FLAT)        ;; es
    (ly:make-pitch 0 6 FLAT)        ;; b
    (ly:make-pitch 0 3 0)           ;; f
    (ly:make-pitch 0 0 0)           ;; c
    (ly:make-pitch 0 4 0)           ;; g
    (ly:make-pitch 0 1 0)           ;; d
    (ly:make-pitch 0 5 0)           ;; a
    (ly:make-pitch 0 2 0)           ;; e
    (ly:make-pitch 0 6 0)           ;; h
    (ly:make-pitch 0 3 SHARP)       ;; fis
    (ly:make-pitch 0 0 SHARP)       ;; cis
    (ly:make-pitch 0 4 SHARP)       ;; gis
    (ly:make-pitch 0 1 SHARP)       ;; dis
    (ly:make-pitch 0 5 SHARP)       ;; ais
    ))

#(define Q-Names ;; define Chord-Names as strings
   (list "Heses" "Fes" "Ces" "Ges" "Des" "As" "Es" "B" "F"
     "C" "G" "D" "A" "E" "H" "Fis" "Cis" "Gis" "Dis" "Ais"
     ))

%#(write-me "Chordnames " Q-Names)
#(define DurChord (list (ly:make-pitch 0 0 0) (ly:make-pitch 0 2 0) (ly:make-pitch 0 4 0)))
#(define MollChord (list (ly:make-pitch 0 0 0) (ly:make-pitch 0 2 FLAT) (ly:make-pitch 0 4 0)))
#(define SeptChord (list (ly:make-pitch 0 0 0) (ly:make-pitch 0 2 0) (ly:make-pitch 0 6 FLAT)))
#(define DimChord (list (ly:make-pitch 0 0 0) (ly:make-pitch 0 2 FLAT) (ly:make-pitch 0 6 DOUBLE-FLAT)))

#(define (transp-Chord p ch)
   ;; transpose chord to pitch p
   ;; ch is a list of pitches
   (let ((p1 (naturalize-pitch p)))
     (map (lambda(x) (ly:pitch-transpose x p1)) ch)))

%#(write-me "transpose Dur " (transp-Chord (list-ref Q-circle 19) DurChord))

#(define Accordion-Bass-List
   ; #(write-me "list-ref Q-circle " (list-ref Q-circle 19))
   (map (lambda (x)
          (cons
           (list-ref Q-circle x)
           (list
            (list-ref Q-Names x)
            x
            (transp-Chord (list-ref Q-circle x) DurChord)
            (transp-Chord (list-ref Q-circle x) MollChord)
            (transp-Chord (list-ref Q-circle x) SeptChord)
            (transp-Chord (list-ref Q-circle x) DimChord)
            )))
     (iota 20)))

%#(write-me "Accordion-Bass-List " Accordion-Bass-List)



#(define (get-Index p)
   (list-ref (assoc-get p Accordion-Bass-List) 1))

#(define (get-Name p)
   (list-ref (assoc-get p Accordion-Bass-List) 0))

#(define (get-Chord p n)
   ;; n=0: Dur Akkord
   ;; n=1: Moll Akkord
   ;; n=2: Septakkord
   ;; n=3: verminderter Akkord
   (list-ref (assoc-get p Accordion-Bass-List) (+ n 2)))

#(define (DMSV n)
   ;; n=0: "Dur-"
   ;; n=1: Moll
   ;; n=2: Sept
   ;; n=3: Dim
   (cond
    ( (= n 0) "-Dur")
    ((= n 1) "-Moll")
    ((= n 2) "-Sept")
    ((= n 3) "-Dim.")
    ))

#(write-me "dur moll oder " (DMSV 2))

#(define (combine-chords p1 p2 a1 a2)
   ;; create a new pitchlist from two chords
   ;; at position p1 and p2
   ;; a1 and a2 characterize if Dur, Moll etc.
   ;; remove double pitches
   (cons
    (delete-duplicates (append
                        (get-Chord p1 a1)
                        (get-Chord p2 a2)
                        ))
    (list p1 p2
      (get-Index p1) (get-Index p2)
      (string-append (get-Name p1) (DMSV a1)) (string-append (get-Name p2) (DMSV a2)))))

#(write-me "combine-chords "
   (append-map
    (lambda(v)
      (append-map
       (lambda(u)
         (append-map
          (lambda(y)
            (map
             (lambda(x)
               (combine-chords
                (list-ref Q-circle x)
                (list-ref Q-circle y)
                u v
                ))
             (iota 1)))
          (iota 1)))
       (iota 3)))
    (iota 3)))


%#(write-me "get-Name " (get-Name (list-ref Q-circle 10)))
%#(write-me "get-Chord " (get-Chord (list-ref Q-circle 10) 0))
%{
#(define combine-all-chords
   (append-map (lambda (y)
                 (map (lambda (x)
                        (cons
                         (combine-chords x y 0 0)
                         (list
                          (get-Index x) (get-Index y)
                          (get-Name x) (get-Name x))))
                   (iota 2)))
     (iota 2)))

%#(write-me "combine-all-chords " combine-all-chords)
%{

   #(define (get-color p)
     (assoc-get (standardize-pitch p) color-pitches))

   #(write-me "ist stencil" (ly:stencil? bass-board))

   #(define mypitch (ly:make-pitch 0 3 0))
   #(define mypitch1 (ly:make-pitch 0 3 FLAT))

   #(write-me "pitch-semitones " (ly:pitch-semitones mypitch ))
   #(write-me "pitch-steps " (ly:pitch-steps mypitch ))
   #(write-me "pitch-tones " (ly:pitch-tones mypitch ))
   #(write-me "pitch-steps1 " (ly:pitch-steps mypitch1 ))
   #(write-me "pitch-tones1 " (ly:pitch-tones mypitch1 ))
   #(write-me "pitch-semitones1 " (ly:pitch-semitones mypitch1 ))
   #(write-me "pitch-transpose " (ly:pitch-transpose mypitch mypitch1))
   #(write-me "pitch-tones transposed " (ly:pitch-tones (ly:pitch-transpose mypitch mypitch1)))


   #(write-me "DurChord " DurChord)
   #(write-me "MollChord " MollChord)
   #(write-me "SeptChord " SeptChord)
   #(write-me "DimChord " DimChord)
%}
#(define-markup-command
  (draw-bass layout props scale-factor )
  (number?)
  (ly:stencil-scale
   bass-board
   scale-factor scale-factor))

#'()

\markup \combine \draw-bass #1
\combine \translate #(cons (- 0 (/ dm-circle 1.2)) (- 0 (/ dm-circle 3))) \stradella-underline "Cis"
\combine \translate #(cons dm-circle dm-circle) \stradella-underline "Gis"
\null
