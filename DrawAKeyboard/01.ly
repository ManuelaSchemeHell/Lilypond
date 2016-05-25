\version "2.19.37"
\language "deutsch"

#(define (music-name x)
   (if (not (ly:music? x))
       #f
       (ly:music-property x 'name)))

#(define (naturalize-pitch p)
   (let ((o (ly:pitch-octave p))
         (a (* 4 (ly:pitch-alteration p)))
         ;; alteration, a, in quarter tone steps,
         ;; for historical reasons
         (n (ly:pitch-notename p)))
     (display p)(newline)
     (cond
      ((and (> a 1) (or (eq? n 6) (eq? n 2)))
       (set! a (- a 2))
       (set! n (+ n 1)))
      ((and (< a -1) (or (eq? n 0) (eq? n 3)))
       (set! a (+ a 2))
       (set! n (- n 1))))
     (cond
      ((> a 2) (set! a (- a 4)) (set! n (+ n 1)))
      ((< a -2) (set! a (+ a 4)) (set! n (- n 1))))
     (if (< n 0) (begin (set! o (- o 1)) (set! n (+ n 7))))
     (if (> n 6) (begin (set! o (+ o 1)) (set! n (- n 7))))
     (write (format "\nOktave: ~a " o) )
     (write (format "\nNote: ~a " n) )
     (write (format "\nAlteration: ~a\n " (/ a 4)) )
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
                (display elt)
                (newline)
                (ly:music-property music 'elements))))))))

#(define white-key-width 23.5) %% wie breit ist eine weiße Taste
#(define white-key-height 150) %% wie hoch bzw. lang ist eine weiße Taste
#(define black-key-width 15)
#(define black-key-height 95) %% wie hoch (bzw. lang) ist eine schwarze Taste
#(define black-key-y-start (- white-key-height black-key-height))
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
   (let*
    ((o (ly:pitch-octave p))
     (a (ly:pitch-alteration p))
     ;; wir subtrahieren die Erhöhung vom Notennamen und addieren 1/2
     ;; das hat den Sinn, dass ich immer auf die gleiche Note komme
     ;; des z.B. n=1, a=-1/2 (des) ==> n=0
     (n  (ly:pitch-notename p))
     (n1 (+ n a -0.5))
     )
    (write (format "\nnotename: ~a" n))
    (write (format "\nnotename1: ~a" n1))
    (write (format "\nalteration: ~a" a))
    (cond
     ;; alteration eq 0
     ;; kein Vorzeichen ==> weiße Taste
     ((eq? a 0)
      (cons (* n white-key-width) 0 ))
     ;; links angeordnete Tasten
     ;; cis/des und fis/ges
     ;; n=0 oder n=3
     ((or (eq? n1 0) (eq? n1 3))
      (cons (+ (* n1 white-key-width) black-key-x1-start ) black-key-y-start ))
     ;; rechts angeordnete Tasten
     ;; dis/es und ais/b
     ;, n=1 oder n=5
     ((or (eq? n1 0) (eq? n1 3))
      (cons (+ (* n1 white-key-width) black-key-x2-start ) black-key-y-start ))
     ;; jetzt bleibt nur noch gis/as übrig
     ;; die einzige mittig angeordnete schwarze Taste
     (else
      (cons (+ (* n1 white-key-width) black-key-x2-start ) black-key-y-start )))))

%#(display (start-point-key #{ fis' #} ))
%{
#(define-markup-command (make-key layout props zahl keylist ) ( number? list?)
   (ly:stencil-scale
    (ly:stencil-add
     (map
      (lambda (p)
        (make-filled-box-stencil
         (start-point-key (naturalize-pitch p)) (cons black-key-y-start white-key-height))
        )
      keylist )
     zahl zahl)
    ))
%}

#(define (make-key  p)
   (let
    ((a (ly:pitch-alteration p))
     (n (ly:pitch-notename p))
     )
    (cond
     ;; alteration eq 0
     ;; kein Vorzeichen ==> weiße Taste
     ((eq? a 0)
      (ly:stencil-in-color
       (make-filled-box-stencil
        (start-point-key (naturalize-pitch p)) (cons (* n white-key-width) white-key-height))
       0.8 0.5 0.5 )
      )
     (else
      (make-filled-box-stencil
       (start-point-key (naturalize-pitch p)) (cons black-key-y-start white-key-height))
      )
     )))

#(define (make-key-list l1)
   (if (null? l1)
       empty-stencil
       (ly:stencil-add
        (make-key (car l1))
        (make-key-list (cdr l1)))))

#(define-markup-command (make-keys layout props zahl arg1) (number? list?)
   (ly:stencil-scale
    (ly:stencil-add
     (ly:stencil-in-color
      (make-key-list (event-chord-pitches #{ < c cis d dis e f fis g gis a b h c' > #}) )
      0.9 0.9 0.9)
     (ly:stencil-in-color(make-key-list arg1 )0.8 0.6 0.8)) zahl zahl
    ))

meinTest=\markup \make-keys  #0.5  #(event-chord-pitches #{ < b cis' > #})

\relative c' {
  c^\meinTest
}
%%
#(display (event-chord-pitches #{ < b cis' > #}))
%#(display (all-pitches-from-music  #{ \relative c' { a e } #} ))
