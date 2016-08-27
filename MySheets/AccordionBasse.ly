\version "2.19.37"
\language "deutsch"
\include "G:/Lilypond/_MyScheme/MusicFunctions.scm"
%\include "G:/Lilypond/_MyScheme/ChordList.ly"
\include "G:/Lilypond/__MySheets/BassakkordeListe/allAccordionBasschords.ly"

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% drawing + markup functions
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#(define dm-circle 3.3)
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
     ; (write-me "ist stencil my-circle " (ly:stencil? my-circle))
     my-board
     ))

#(define-markup-command
  (draw-bass layout props scale-factor )
  (number?)
  (ly:stencil-scale
   bass-board
   scale-factor scale-factor))

#(define-markup-command (circle-round layout props arg radius)
   (markup? number?)
   #:properties ((thickness 1)
                 (font-size 0)
                 (circle-padding 0.2))
   (let* ((th (* (ly:output-def-lookup layout 'line-thickness)
                thickness))
          (pad (* (magstep font-size) circle-padding))
          (m (interpret-markup layout props arg))
          (myx  (ly:stencil-extent m X))
          (breite (- (cdr myx) (car myx)))
          (myy  (ly:stencil-extent m Y))
          (hoch (- (cdr myy) (car myy)))
          )
     (write-me "x-xtent ---->  " (ly:stencil-extent m X))
     (write-me "breite: ---->   " breite)
     (write-me "hoch: ------>   " hoch)
     (ly:stencil-add
      (make-circle-stencil radius 0 #f)
      (ly:stencil-translate-axis
       (ly:stencil-translate-axis m (- 0 (/ breite 2)) X)
       (- 0 (/ hoch 2)) Y))))

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% pitch+music functions
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
          (a (ly:pitch-alteration p))
          (n (ly:pitch-notename p)))
     (ly:make-pitch 0 n a)))
%{
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

%{
#(define (accidental->markup alteration)
   "Return accidental markup for ALTERATION."
   (if (= alteration 0)
       (make-line-markup (list empty-markup))
       (make-line-markup
        (list
         (alteration->text-accidental-markup alteration)
         (make-hspace-markup 0.1)))))

#(define (alteration->text-accidental-markup alteration)
   (make-smaller-markup
    (make-raise-markup
     (if (= alteration FLAT)
         0.3
         0.6)
     (make-musicglyph-markup
      (assoc-get alteration standard-alteration-glyph-name-alist "")))))
%% }

#(define (note-namex->string pitch)
   (make-concat-markup
    (list
     (make-simple-markup
      (vector-ref #("C" "D" "E" "F" "G" "A" "B") (ly:pitch-notename pitch)))
     (accidental->markup (ly:pitch-alteration pitch)))))
%}

#(define (note-name->string pitch)
   (string-append
    (vector-ref #("C" "D" "E" "F" "G" "A" "B") (ly:pitch-notename pitch))
    ))

#(define (note-name->german-string pitch)
   (define (pitch-alteration-semitones pitch)
     (inexact->exact (round (* (ly:pitch-alteration pitch) 2))))
   (let* ((name (ly:pitch-notename pitch))
          (alt-semitones (pitch-alteration-semitones pitch))
          (n-a (if (equal? (cons name alt-semitones) '(6 . -1))
                   (cons 7 alt-semitones)
                   (if (equal? (cons name alt-semitones) '(6 . -2))
                       (cons 7 -2)
                       (cons name alt-semitones)
                       )
                   )))
     ;(write-me "name:          -------------> " name)
     ;(write-me "alt-semitones: -------------> " alt-semitones)
     ;(write-me "n-a: -------------> " n-a)
     (string-append
      (vector-ref #("C" "D" "E" "F" "G" "A" "H" "B") (car n-a))
      (let ((alteration (/ (cdr n-a) 2)))
        ;(write-me "alteration: -------------> " alteration)
        (cond
         ((and (= alteration FLAT) (= (car n-a) 7))
          "")
         ((and (= alteration DOUBLE-FLAT) (= (car n-a) 7)) ;; we write Heses as Bes because it is shorter
           "es")
         ((and (= alteration FLAT) (or (= (car n-a) 5) (= (car n-a) 2) ))
          "s")
         ((= alteration FLAT)
          "es")
         ((and (= alteration DOUBLE-FLAT) (or (= (car n-a) 5)(= (car n-a) 2)))
          "ses")
         ((= alteration DOUBLE-FLAT)
          "eses")
         ((= alteration SHARP)
          "is")
         ((= alteration DOUBLE-SHARP)
          "isis")
         (else ""))))))

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

#(define Terz-circle ;; define circle of fifths as pitchlist
   (list
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
    (ly:make-pitch 0 2 SHARP)       ;; eis
    (ly:make-pitch 0 6 SHARP)       ;; his
    (ly:make-pitch 0 4 0)           ;; g
    (ly:make-pitch 0 1 0)           ;; d
    ))
%{
   #(define Q-Names ;; define Chord-Names as strings
     (list "Bes" "Fes" "Ces" "Ges" "Des" "As" "Es" "B" "F"
       "C" "G" "D" "A" "E" "H" "Fis" "Cis" "Gis" "Dis" "Ais"
       ))
%}

%#(write-me "note-name->german-string pitch .............> "
%   (note-name->german-string (list-ref Q-circle 16)))

#(define Q-Names
   (map (lambda(x)(note-name->german-string (list-ref Q-circle x))) (iota 20)))
%#(display Q-Names)

#(define TerzBass ;; define Chord-Names as strings
   (map (lambda(x)(note-name->german-string (list-ref Terz-circle x))) (iota 20)))
#(display TerzBass)

#(define DurList (list-all-chords-from-music Dur))
#(define MollList (list-all-chords-from-music Moll))
#(define 7List (list-all-chords-from-music Sept))
#(define VList (list-all-chords-from-music Verm))
%#(write-me "DurListe: ------------> " DurList)
%#(write-me "ist musik? -----------> " (ly:music? (list-ref DurList 3)))
%#(write-me "pitches    -----------> " (all-pitches-from-music (list-ref DurList 3)))

#(define (reduce-chordlist ch-list)
   (map (lambda (x)
          (let* ((a (ly:pitch-alteration x))
                 (n (ly:pitch-notename x)))
            (ly:make-pitch 0 n a)))
     ch-list))

#(define Accordion-Bass-List
   ; #(write-me "list-ref Q-circle " (list-ref Q-circle 19))
   (map (lambda (x)
          (cons
           (list-ref Q-circle x)
           (list
            (list-ref Q-Names x)
            x
            (cons (list-ref DurList x) (all-pitches-from-music (list-ref DurList x)))
            (cons (list-ref MollList x) (all-pitches-from-music (list-ref MollList x)))
            (cons (list-ref 7List x) (all-pitches-from-music (list-ref 7List x)))
            (cons (list-ref VList x) (all-pitches-from-music (list-ref VList x)))
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

%#(write-me "get-Chord list? --------> " (list? (get-Chord (list-ref Q-circle 2) 2)))
%#(write-me "get-Chord ly:music? ----> " (ly:music? (get-Chord (list-ref Q-circle 2) 2)))
#(write-me "get-Name ---------------> " (get-Name (list-ref Q-circle 0)))
#(define (DMSV n)
   ;; n=0: "Dur-"
   ;; n=1: Moll
   ;; n=2: Sept
   ;; n=3: Dim
   (cond
    ( (= n 0) "")
    ((= n 1) "m")
    ((= n 2) "7")
    ((= n 3) "o")
    ))

#(define (get-ChordName p n)
   (let* ((m (- n 2))
          (bname (string-downcase (get-Name p)))
          (cname (string-capitalize bname))
          (i (get-Index p))
          (terz (list-ref TerzBass i))
          )
     (cond
      ((>= n 3)
       (string-append bname (DMSV m)))
      ((= n 2)
       bname)
      ((= n 1)
       cname)
      (else terz)
      )))

#(define (ChordName->markup p n)
   (let* ((m (- n 2))
          (bname (string-downcase (get-Name p)))
          (cname (string-capitalize bname))
          (i (get-Index p))
          (terz (list-ref TerzBass i))
          (simple
           (cond
            ((>= n 2)
             bname)
            ((= n 1)
             cname)
            (else terz)
            ))
          (hoch
           (cond
            ((>= n 3) (DMSV m))
            (else ""))))
     (make-concat-markup
      (list
       (make-simple-markup (format #f "~a" simple))
       (make-smaller-markup
        (make-raise-markup 0.6 (make-simple-markup (format #f "~a" hoch))))))))

#(define mytest ( ChordName->markup (list-ref Q-circle 2) 3))
#(write-me "is markup? test ----------> " (markup? mytest))
%\markup \mytest
#(define (combine-chords p1 p2 a1 a2)
   ;; create a new pitchlist from two chords
   ;; at position p1 and p2
   ;; a1 and a2 characterize if Dur, Moll etc.
   ;; remove double pitches
   (cons
    (sort
     (delete-duplicates
      (append
       (cdr (get-Chord p1 a1))
       (cdr (get-Chord p2 a2))
       )) ly:pitch<?)
    (list p1 p2 a1 a2)))

#(write-me "combine-chords ============> " (combine-chords (list-ref Q-circle 2)  (list-ref Q-circle 4) 1 2))

#(define combine-all-chords
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
                u v))
             (iota 3)))
          (iota 3)))
       (iota 4)))
    (iota 4)))

%\markup \circle-round \fontsize #-3 #(get-ChordName (list-ref Q-circle 5) 2) #2
%#(write-me "combine-all-chords ============> " combine-all-chords)

#(define bass-boardx
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

#(define-markup-command (draw-acc-bass layout props)()
   #:properties ((font-size 0) (thickness 2.5) (offset 3.5))
   (let* ((my-circle (make-circle-stencil dm-circle 0.1 #f))
          (cir-dist (+ (* 2 dm-circle) dist))
          (thick (* (magstep font-size) (ly:output-def-lookup layout 'line-thickness)))
          (underline-thick (* thickness thick))
          (y (* thick (- offset)))
          )
     ;procedure body
     (apply ly:stencil-add
       empty-stencil
       (map
        (lambda (z)
          (ly:stencil-translate
           (apply ly:stencil-add
             empty-stencil
             (map
              (lambda (x)
                (let* ((m (interpret-markup layout props (ChordName->markup (list-ref Q-circle x) z)))
                       (m1 (interpret-markup layout props (get-ChordName (list-ref Q-circle x) z)))
                       (myx  (ly:stencil-extent m X))
                       (xstart (car myx))
                       (xend (cdr myx))
                       (breite (- xend xstart))
                       (myy  (ly:stencil-extent m Y))
                       (hoch (- (cdr myy) (car myy))))
                  (ly:stencil-translate-axis
                   (ly:stencil-add
                    (ly:stencil-translate-axis
                     (ly:stencil-translate-axis
                      (ly:stencil-add
                       (if (= 0 z)
                           (make-line-stencil underline-thick xstart y xend y)
                           empty-stencil)
                       m)
                      (- 0 (/ breite 2)) X)
                     (- 0 (/ hoch 2)) Y)
                    my-circle) (* x cir-dist) X)))
              (iota 20 0)))
           (cons (* z h-dist) (* z cir-dist -1))))
        (iota 6)))))

%#(display (list? (car combined-chords)))

\markup \scale #'(0.9 . 0.9) \draw-acc-bass
%#(display (ly:music? (car combined-chords)))

%{
   myChord=
   #(define-music-function ()()
     (make-music 'EventChord 'elements
       (car combined-chords)))
%}
#'()


%#(display (ly:music? (make-music (caar combined-chords))))

%\myChord
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


#'()
