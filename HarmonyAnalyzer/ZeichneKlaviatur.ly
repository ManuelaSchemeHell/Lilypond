\version "2.19.32"
\language "deutsch"

%% http://lsr.di.unimi.it/LSR/Item?id=791
%% see also http://lilypond.org/doc/v2.18/Documentation/snippets/keyboards
#(define (stufe p)
   (if (not (ly:pitch? p))
       #()
       (ly:pitch-notename p ))
   (write (format "\nNote: ~a" (ly:pitch-notename p ) )
     ))

#(display (stufe #{ c #} ))

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

#(define (make-dot p)
   (if (not (ly:pitch? p))
       empty-stencil
       (if ( = 0 (ly:pitch-alteration p))
           (ly:stencil-in-color
            (ly:stencil-translate
             (make-circle-stencil ( * 1 0.7) 0 #t)
             (cons (+ (* (ly:pitch-notename p ) 2.35) 1.175
                     (* (ly:pitch-octave p) 7 2.35))
                      2.7) )
            0.5 0.5 0.5 )
           (ly:stencil-in-color
            (ly:stencil-translate
             (make-circle-stencil ( * 1 0.6) 0 #t)
             (cons 5 8 ) )
            0.5 0.8 0.5 )
           )
       )
   )

kreise=
#(define-music-function (music) (ly:music? )
   (write (format "\nkreise: ~a"
            (list? (all-pitches-from-music music ))))
   (write (format "\nis pitch: ~a"
            (ly:pitch? (car  (all-pitches-from-music music )))))
   (write (format "\n is stencil: ~a"
            (ly:stencil?
             (make-dot (car (all-pitches-from-music music ))))))
   ;(make-dot (car (all-pitches-from-music music)))
   #{ $music #}
   )

#(define (make-dot-list l1)
   ; (write ( format "\n(make-dot-list car l1 ~a" (car l1) ))
   (if (null? l1)
       empty-stencil
       (ly:stencil-add
        (make-dot (car l1) 3)
        (make-dot-list (cdr l1)))))

\relative c' {
  \kreise { c }
}

#(define-markup-command (keys layout props zahl arg1) (number? list?)
   (ly:stencil-scale
    (ly:stencil-add

     ; obere Linie
     (make-line-stencil 0.1 0 0 (* 2.35 17) 0)
     ;; untere Linie
     (make-line-stencil 0.1 0 15 (* 2.35 17) 15)
     ; Ziwschenlinie
     (make-line-stencil 0.1 0 0 0 15) ;; linker Rand
     (make-line-stencil 0.1 2.35 0 2.35 15)
     (make-line-stencil 0.1 (* 2 2.35) 0  (* 2 2.35) 15)
     (make-line-stencil 0.1 (* 3 2.35) 0  (* 3 2.35) 15)
     (make-line-stencil 0.1 (* 4 2.35) 0  (* 4 2.35) 15)
     (make-line-stencil 0.1 (* 5 2.35) 0  (* 5 2.35) 15)
     (make-line-stencil 0.1 (* 6 2.35) 0  (* 6 2.35) 15)
     (make-line-stencil 0.1 (* 7 2.35) 0  (* 7 2.35) 15)
     (make-line-stencil 0.1 (* 8 2.35) 0  (* 8 2.35) 15)
     (make-line-stencil 0.1 (* 9 2.35) 0  (* 9 2.35) 15)
     (make-line-stencil 0.1 (* 10 2.35) 0  (* 10 2.35) 15)
     (make-line-stencil 0.1 (* 11 2.35) 0  (* 11 2.35) 15)
     (make-line-stencil 0.1 (* 12 2.35) 0  (* 12 2.35) 15)
     (make-line-stencil 0.1 (* 13 2.35) 0  (* 13 2.35) 15)
     (make-line-stencil 0.1 (* 14 2.35) 0  (* 14 2.35) 15)
     (make-line-stencil 0.1 (* 15 2.35) 0  (* 15 2.35) 15)
     (make-filled-box-stencil '(1.25 . 2.85) '(5.5 . 15)) ;; cis
     (make-filled-box-stencil '(4.15 . 5.75) '(5.5 . 15)) ;; dis
     (make-filled-box-stencil '(8.25 . 9.85) '(5.5 . 15)) ;; fis
     (make-filled-box-stencil '(10.95 . 12.55) '(5.5 . 15)) ;; gis
     (make-filled-box-stencil '(13.65 . 15.25) '(5.5 . 15)) ;; ais
     (make-filled-box-stencil '(20.6 . 22.2) '(5.5 . 15)) ;; cis
     (make-filled-box-stencil '(24.7 . 26.3) '(5.5 . 15)) ;; dis
     (make-filled-box-stencil '(17.65 . 19.25) '(5.5 . 15)) ;; fis
     (make-filled-box-stencil '(27.4 . 29) '(5.5 . 15)) ;; gis
     (make-filled-box-stencil '(30.1 . 31.7) '(5.5 . 15)) ;; ais
     (ly:stencil-in-color
      (ly:stencil-translate
       (make-circle-stencil ( * 1 0.7) 0 #t)
       '(1.175 . 2.7)       )
      0.5 0.5 0.5
      )
     (ly:stencil-in-color
      (ly:stencil-translate
       (make-circle-stencil ( * 1 0.6) 0 #t)
       '(2 . 8)       )
      0.8 0.5 0.5      )
     (ly:stencil-in-color
      (ly:stencil-translate
       (make-circle-stencil ( * 1 0.6) 0 #t)
       '(5 . 8)       )
      0.5 0.8 0.5      )
     (ly:stencil-in-color
      (ly:stencil-translate
       (make-circle-stencil ( * 1 0.7) 0 #t)
       '(3.525 . 2.7)       )
      0.5 0.5 0.5      )
     (ly:stencil-in-color
      (ly:stencil-translate
       (make-circle-stencil ( * 1 0.7) 0 #t)
       '(5.875 . 2.7)       )
      0.5 0.5 0.5
      ))
    1 1
    ))

#(define-markup-command (keyboard layout props zahl arg1) (number? list?)
   (ly:stencil-add
    ;; untere Begrenzungslinie
    ;; erstes Argument: Liniendicke
    ;; 2. Argument: x-offset des Beginns
    ;; 3. Argument: Anzahl der Tasten
    ;, muss gleich dem halben Wert von make-keys sein?
    (make-line-stencil 0.1 1 0 (+ (* 7 zahl) 1) 0)
    ;; obere Begrenzuungslinie
    ;(make-line-stencil 0.1 1 (* 6 zahl) (* 12 zahl) (* 6 zahl) )
    (make-line-stencil 0.1 1 (* 3 zahl) (+ (* 7 zahl) 1) (* 3 zahl))
    ;; weiße Tasten zeichnen
    ;; die Liste ergibt die Breite der einzelnen Tasten
    ;;
    (make-keys '(2  4  6 8 10 12 14 16 18 20 22 24 26 28 30 ) 2
      0 (* 4 zahl) #f)
    ;; schwarze Tasten zeichnen
    ;; vorletzte Zahl: wie hoch die schwarze Taste beginnt
    ;, letzte Zahl: Höhe der Taste
    ;; sollte in Summe die Gesamthöhe derweißten Tasten ergeben
    ;; =die letzte Zahl in make-keys
    ;; erste Zahl ist die Breite der Taste
    ;(make-keys-black '(2.7 5.4  8.7 11 13.3 16.7 19.4 22.7 25 27.3 )
    ;  1.5 (* zahl 2) (* zahl 1.5) #t)

    ))

cnine=\markup \keys #3 #'(c des es f gis a )

\relative c' {
  <c d es>4^\cnine r r2 r1
}
