\version "2.18.0"
\language "deutsch"

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Drawing a standard Stradella Accordion Bass
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% defining circle diameter and distances
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#(define dm-circle 3.3) %% the radius of the buttons
#(define col-dist (+ (* 2 dm-circle) 0.1)) %% distance between 2 button columns, default: 2*radius plus a little
#(define row-dist 1) %% the vertical distance of the button rows, check out smaller values
#(define h-shift dm-circle) %% defines much a button row is shifted horizontally relativ to the next lower row

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% pitch+music functions and definitions
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#(define (pitch-equals? p1 p2)
   ;(write-me "pitch-equals? ----------------------------> " (list p1 p2))
   (and
    (= (ly:pitch-alteration p1) (ly:pitch-alteration p2))
    (= (ly:pitch-notename p1) (ly:pitch-notename p2))))

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

#(define Terz-circle ;; define terzbasses
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

#(define (get-Index p)
   (list-index (lambda(x)(pitch-equals? x p)) Q-circle))

#(define (get-Name p)
   (note-name->german-string p))

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

#(define (ChordName->markup p n)
   (let* ((m (- n 2))
          (bname (string-downcase (get-Name p)))
          (cname (string-capitalize bname))
          (i (get-Index p))
          (terz (get-Name (list-ref Terz-circle i)))
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
       (make-simple-markup simple)
       (make-smaller-markup
        (make-raise-markup 0.6 (make-simple-markup hoch)))))))

rowDist=#(define-scheme-function (dist)
           (number?)
           (set! row-dist dist))

colDist=#(define-scheme-function (dist)
           (number?)
           (set! col-dist dist))

slope=#(define-scheme-function (dist)
         (number?)
         (set! h-shift dist))

#(define-markup-command (draw-acc-bass layout props)()
   #:properties ((font-size 0) (thickness 2.5) (offset 3.5))
   (let* ((my-circle (make-circle-stencil dm-circle 0.1 #f))
          ; (cir-dist (+ (* 2 dm-circle) xdist)) ;; dist: how much distance between two cirles
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
                (let* ((m
                        (interpret-markup layout props
                          (ChordName->markup (list-ref Q-circle x) z)))
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
                     (- 0 (/ hoch 2)) Y) ;; chordname plus underline if terzbass
                    my-circle) ;; circled chordname
                   (* x col-dist) X)))
              (iota 20 0)))
           (cons (* z h-shift) (* z col-dist (* row-dist -1)))))
        (iota 6)))))


\bookpart {
  \rowDist #1
  \colDist #(+ dm-circle dm-circle 0.2)
  \slope #dm-circle
  \markup {
    \column  {
      \vspace #1 "Draw an Accordion Stradella Bass with standard distances"
      \vspace #2 \translate #'(0 . 0 ) \scale #'(0.75 . 0.75) \draw-acc-bass
    }
  }
}

\bookpart {
  \rowDist #0.8
  \colDist #(+ dm-circle dm-circle -1)
  \slope  #(* -0.5 dm-circle)
  \markup {
    \column  {
      \vspace #1 "Draw an Accordion Stradella Bass with some funny distances"
      \vspace #2 \translate #'(10 . 0 ) \scale #'(0.9 . 0.9) \draw-acc-bass
    }
  }
}
