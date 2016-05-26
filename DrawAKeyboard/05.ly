\version "2.19.36"
\language "deutsch"

#(define (naturalize-pitch p)
   (let ((o (ly:pitch-octave p))
         (a (* 4 (ly:pitch-alteration p)))
         ;; alteration, a, in quarter tone steps,
         ;; for historical reasons
         (n (ly:pitch-notename p)))
     (cond ((and (> a 1) (or (eq? n 6) (eq? n 2)))
            (set! a (- a 2))
            (set! n (+ n 1)))
       ((and (< a -1) (or (eq? n 0) (eq? n 3)))
        (set! a (+ a 2))
        (set! n (- n 1))))
     (cond ((> a 2) (set! a (- a 4)) (set! n (+ n 1)))
       ((< a -2) (set! a (+ a 4)) (set! n (- n 1))))
     (if (< n 0) (begin (set! o (- o 1)) (set! n (+ n 7))))
     (if (> n 6) (begin (set! o (+ o 1)) (set! n (- n 7))))
     (ly:make-pitch o n (/ a 4))))

#(define white-key-width 23.5) %% wie breit ist eine weiße Taste
#(define white-key-height 150) %% wie hoch bzw. lang ist eine weiße Taste
#(define black-key-width 15)
#(define black-key-height 95) %% wie hoch (bzw. lang) ist eine schwarze Taste
#(define black-key-y-start (- white-key-height black-key-height))
#(define kreis-dm (/ (* 1.5 black-key-width) 3))
%% Startpunkt für die links verschobenen Tasten cis/des fis/ges
%% n=0 oder n=3
#(define black-key-x1-start 13)
%% Startpunkt für die rechts verschobenen Tasten cis/des fis/ges
%% n=4
#(define black-key-x2-start 16)
%% Startpunkt für die mittigen schwarzen Tasten gis/as
%% n=1 oder n=5
#(define black-key-x3-start 19)
%#(display black-key-height)
%#(newline)
#(define (start-point-key p)
   ;; wir berechnen den Startpunkt der Taste
   ;; abhängig vom Pitch
   (let* ((o (ly:pitch-octave p))
          (a (ly:pitch-alteration p))
          ;; wir subtrahieren die Erhöhung vom Notennamen und addieren 1/2
          ;; das hat den Sinn, dass ich immer auf die gleiche Note komme
          ;; des z.B. n=1, a=-1/2 (des) ==> n=0
          (n  (ly:pitch-notename p))
          (n1 (+ n a -0.5))
          (x-shift (* o 7 white-key-width)))
     (cond
      ;; alteration eq 0
      ;; kein Vorzeichen ==> weiße Taste
      ((eq? a 0)
       (cons (+ (* n white-key-width) x-shift) 0))
      ;; links angeordnete Tasten
      ;; cis/des und fis/ges
      ;; n=0 oder n=3
      ((or (= n1 0) (= n1 3))
       (cons (+ (* n1 white-key-width) black-key-x1-start x-shift)
         black-key-y-start))
      ;; rechts angeordnete Tasten
      ;; dis/es und ais/b
      ;, n=1 oder n=5
      ((or (= n1 1) (= n1 5))
       ;(write (format "\n ((or (eq? n1 1) (eq? n1 5)): ~a" n1))
       (cons (+ (* n1 white-key-width) black-key-x3-start x-shift)
         black-key-y-start))
      ;; jetzt bleibt nur noch gis/as übrig
      ;; die einzige mittig angeordnete schwarze Taste
      (else
       (cons (+ (* n1 white-key-width) black-key-x2-start x-shift)
         black-key-y-start)))))


#(define-public (make-transparent-stencil stencil)
   "Make a transparent stencil."
   (let ((x-ext (ly:stencil-extent stencil X))
         (y-ext (ly:stencil-extent stencil Y)))
     (ly:make-stencil
      (list 'transparent-stencil
        (ly:stencil-expr stencil))
      x-ext y-ext)))

#(define* (make-key outlined? transparent? p #:optional (thickness 1.5))
   (let* ((q (naturalize-pitch p))
          (a (ly:pitch-alteration q))
          (n (ly:pitch-notename q))
          (key-point (start-point-key q))
          (black-key-stil
           (lambda (thick)
             (make-filled-box-stencil
              (interval-widen
               (cons (car key-point) (+ (car key-point) black-key-width))
               thick)
              (interval-widen
               (cons
                black-key-y-start
                (+ black-key-height black-key-y-start 0.5))
               thick))))
          (white-key-stil
           (lambda (thick corr)
             (make-filled-box-stencil
              (interval-widen
               (cons (car key-point) (+ (car key-point) white-key-width))
               thick)
              (interval-widen
               (cons (- corr) (+ white-key-height corr))
               thick)))))
     (cond
;;;; alteration  0
      ;; for default white keys
      ;; and scale white keys
      ((and (= a 0) outlined?)
       (box-stencil
        (make-transparent-stencil
         (white-key-stil (- thickness) 0))
        thickness 0))
      ;; for chord-white-keys
      ((and (= a 0) (not outlined?))
       (white-key-stil -0.25 -0.25) )

;;;; alteration not 0
      ;; not outlined and not transparent
      ((and (not (= a 0)) (not outlined?) (not transparent?))
       (black-key-stil (- 1)))

      ;; colored outlined and transparent
      ((and (not (= a 0)) outlined? transparent?)
       (box-stencil
        (make-transparent-stencil (black-key-stil -2))
        thickness 0))
      (else
       ;; outlined and colored
       (ly:stencil-add
        (black-key-stil (- 1))
        (stencil-with-color
         (box-stencil
          (make-transparent-stencil (black-key-stil (- 1)))
          thickness 0)
         '(0.1 0.1 0.1)))))))


#(define* (make-key-list filled val l1 #:optional (thickness 1.5))
   (apply
    ly:stencil-add
    (map (lambda (e) (make-key filled val e thickness)) l1)))

#(define white-keys
   (ly:stencil-in-color
    (make-key-list
     #t
     #f ;; val
     (event-chord-pitches
      #{
        <c, d, e, f, g, a, h, c d e f g a h c' d' e' f' g' a' h' c''>
      #})
     0.5)
    0.1 0.1 0.1))

#(define (white-key? p)
   (let
    ((a (ly:pitch-alteration (naturalize-pitch p))))
    (if (= a 0)
        #t
        #f)))

#(define black-keys
   (stencil-with-color
    (make-key-list
     #t
     #f
     (event-chord-pitches
      #{
        <cis, dis, fis, gis, ais, cis dis fis gis ais cis' dis' fis' gis' ais'>
      #})
     0.5)
    '(0.9 0.9 0.9)))

#(define (sort-white-black-key-pitches pitch-list)
   (call-with-values
    (lambda ()
      (partition
       (lambda (p) (= 0 (ly:pitch-alteration p)))
       pitch-list))
    (lambda (a b) (list a b))))

#(define (make-dot p)
   (if (white-key? p)
       (ly:stencil-in-color
        (ly:stencil-translate
         (make-circle-stencil  kreis-dm 0 #t)
         (cons
          (+ (car (start-point-key p)) (/ white-key-width 2 ))
          (+ (cdr (start-point-key p)) (/ (- white-key-height black-key-height) 1.5))
          )
         )
        0.5 0.5 0.5)
       (ly:stencil-in-color
        (ly:stencil-translate
         (make-circle-stencil (/ kreis-dm 1.5) 0 #t)
         (cons
          (+ (car (start-point-key p)) (/ black-key-width 2 ))
          (+ (cdr (start-point-key p)) (/ (* 1 black-key-height) 8))
          )
         )
        0.5 0.5 0.5)
       )
   )

#(define (make-dot-list l1)
   (if (null? l1)
       empty-stencil
       (ly:stencil-add
        (make-dot (naturalize-pitch (car l1)))
        (make-dot-list (cdr l1)))))

#(define-markup-command
  (make-keys layout props scale-factor the-scale the-chord)
  (number? ly:music? ly:music?)
  (let* ((scale
          (map
           (lambda (m) (ly:music-property m 'pitch))
           (extract-named-music the-scale 'NoteEvent)))
         (sorted-scale-pitches
          (sort-white-black-key-pitches scale))
         (chord
          (map
           (lambda (m) (ly:music-property m 'pitch))
           (extract-named-music the-chord 'NoteEvent)))
         (sorted-chord-pitches
          (sort-white-black-key-pitches (map naturalize-pitch chord))))

    (ly:stencil-scale
     (ly:stencil-add
;;;; white-keys-stuff
      ;; default white keys
      white-keys
      ;; chord-pitches at white keys
      ;;(ly:stencil-in-color
      ;;  (make-key-list #f #t (car sorted-chord-pitches))
      ;;  1 0 0)
      ;; scale-pitches at white keys
      (ly:stencil-in-color
       (make-key-list #f #f (car sorted-scale-pitches))
       0.98 0.98 1)

;;;; black-keys-stuff
      ;; default black keys
      black-keys
      ;; chord-pitches at black keys
      ;;(ly:stencil-in-color
      ;;  (make-key-list #f #f (cadr sorted-chord-pitches))
      ;;  1 0 0)
      (make-dot-list chord) ;(car sorted-chord-pitches) )
      ;; scale-pitches at black keys
      (ly:stencil-in-color
       (make-key-list #f #t (cadr sorted-scale-pitches))
       0.98 0.98 1))
     scale-factor
     scale-factor)))

scale = { c d e fis g a h  }
newscale= { \transpose c c, \scale \scale \transpose c c' \scale c'' }
chrd = < cis eis gis a as  >
%chrd = <g, c d>

tst = \markup \make-keys  #0.1 #newscale #chrd

\relative c'' { <>^\tst \chrd }

\pageBreak

Tonleiter = { g a h c d e fis g }
meinAkkord = \chordmode { g,:sus4 }
meinTest = \markup \make-keys #0.1 #Tonleiter #meinAkkord

\relative c' { <>^\meinTest \meinAkkord }

