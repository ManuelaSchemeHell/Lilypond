\version "2.19.37"
\language "deutsch"

%% usefule Scheme functions
%% ok if where functions useless I would not write them down ;-)

#(define (music-elts x)
   (if (not (ly:music? x))
       #()
       (ly:music-property x 'elements)))

#(define (music-name x)
   (if (not (ly:music? x))
       #f
       (ly:music-property x 'name)))

#(define (pitch-equals? p1 p2)
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
%#(display (naturalize-pitch #{ des #}))

#(define (standardise-pitch p)
   ;; we are only interested in the key on a keyboard that represents that pitch
   ;; cis=des and so on
   ;; #(display (standardize-pitch #{ des #}))
   ;; #<Pitch cis >
   (let*
    ((m (naturalize-pitch p))
     (o (ly:pitch-octave m))
     (a (ly:pitch-alteration m))
     (n  (ly:pitch-notename m))
     (n1 (inexact->exact(+ n a -0.5))) ;; ly:make-pitch accepts only integer
     )
    (if (< a 0)
        (ly:make-pitch o n1 (+ 1 a ))
        (ly:make-pitch o n a )
        )))

#(define (all-pitches-from-music music)
   "Return a list of all pitches from @var{music}."
   ;; the result is a list of pitches from ly:music music
   ;; #(display  (all-pitches-from-music #{ { c,, d'' e'''' f,,, < c f > } #}))
   ;; output: (#<Pitch c,, > #<Pitch d'' > #<Pitch e'''' > #<Pitch f,,, > #<Pitch c > #<Pitch f >)
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

#(define remove-octavation
   ;; we set all octave information to 0
   ;; #(display ( remove-octavation (all-pitches-from-music #{ { c,, d'' e'''' f,,, < c f > } #})))
   ;; (#<Pitch c' > #<Pitch d' > #<Pitch e' > #<Pitch f' > #<Pitch c' > #<Pitch f' >)
   (lambda (plis)
     (cond
      ((null? plis) '())
      (else (cons (ly:make-pitch 0
                    (ly:pitch-notename (car plis))
                    (ly:pitch-alteration (car plis)))
              (remove-octavation (cdr plis)))
        ))))

#(define remove-double-pitches
   ;; input is a list of sorted pitches
   ;; output is a list of the same pitches without doubles
   ;; #(display (remove-double-pitches (all-pitches-from-music #{ { c, d' e' f, < c f, > c, } #})) does not remove all double pitches because the list is not sorted
   ;; this works correctly:
   ;;#(display
   ;;  (remove-double-pitches
   ;;   (sort
   ;;    (all-pitches-from-music #{ { c, c, d' e' f, < c f, > c, } #}) ly:pitch<?)))
   ;; (#<Pitch c, > #<Pitch f, > #<Pitch c > #<Pitch d' > #<Pitch e' >)
   (lambda (plis)
     (cond
      ((null? (cdr plis)) plis)
      (else
       (cond
        ((pitch-equals? (car plis) (cadr plis))
         (remove-double-pitches (cdr plis)))
        (else
         (cons (car plis) (remove-double-pitches (cdr plis))
           )))))))

#(define (make-pitchlist-from-musiclist muslist)
   ;; input: list of ly:music
   ;; output: list of pitchlists
   ;;  #(display (make-pitchlist-from-musiclist ( list #{ { c,, d'' e, f' < c f > } #}
   ;;         #{ { c' d' e' f' < c' f' > } #} )))
   ;; output: ((#<Pitch c,, > #<Pitch d'' > #<Pitch e, > #<Pitch f' > #<Pitch c > #<Pitch f >)
   ;;          (#<Pitch c' > #<Pitch d' > #<Pitch e' > #<Pitch f' > #<Pitch c' > #<Pitch f' >))
   (map
    (lambda (x) (all-pitches-from-music x))
    muslist))

#(define (chords-in-all-scales Pitch Musik)
   (append-map
    (lambda (p)
      (map
       (lambda (music)
         #{ { \transpose c $p $music } #})
       Musik
       )
      )
    (event-chord-pitches Pitch)
    )
   )

#(define is-in?
   ;; input: two sorted pitch lists
   ;; we check if all elements of the first list are in the second list
   ;; we ignore the octave
   (lambda ( l1 l2 )
     ( cond
       ;; when l1 is empty we are done, the result is #t
       ((null? l1) #t
         )
       ;; when l2 is empty we are done too but the result is #f
       ((null? l2) #f
         )
       ;; is the first element of l1 eq the first element of l2
       ;; if yes we continue with the rest of l1
       ((pitch-equals? (car l1) (car l2))
        (is-in? (cdr l1) l2)
        ;'equalPitch
        )
       ;; the first elements of l1 and l2 are not equal pitches
       ;; we give it a try to the next element of l2
       ;; this works because both lists are sorted
       (else (is-in? l1 (cdr l2))
         )
       )
     )
   )
