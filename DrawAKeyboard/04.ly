\version "2.19.37"
\language "deutsch"

\paper {
  #(set! paper-alist (cons '("mein Format" . (cons (* 35 in) (* 5 in))) paper-alist))
  #(set-paper-size "mein Format")
  left-margin = #20
}

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
     #!#
     (write (format "\nnaturalize-pitch pitch: ~a " p) )
     (write (format "\nOktave: ~a " o) )
     (write (format "\nNote: ~a " n) )
     (write (format "\nAlteration: ~a\n " (/ a 4)) )
#!#
     (ly:make-pitch o n (/ a 4))))

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
     (x-shift (* o 7 white-key-width))
     )
    ;(write (format "\nstart-point-key pitch: ~a" p))
    ;(write (format "\nnotename: ~a" n))
    (write (format "\nnotename1: ~a" n1))
    ;(write (format "\nalteration: ~a\n" a))
    (cond
     ;; alteration eq 0
     ;; kein Vorzeichen ==> weiße Taste
     ((eq? a 0)
      (cons (+ (* n white-key-width) x-shift) 0 ))
     ;; links angeordnete Tasten
     ;; cis/des und fis/ges
     ;; n=0 oder n=3
     ((or (= n1 0) (= n1 3))
      (write (format "\n((or (eq? n1 0) (eq? n1 3)): ~a" n1))
      (cons (+ (* n1 white-key-width) black-key-x1-start x-shift ) black-key-y-start ))
     ;; rechts angeordnete Tasten
     ;; dis/es und ais/b
     ;, n=1 oder n=5
     ((or (= n1 1) (= n1 5))
      (write (format "\n ((or (eq? n1 1) (eq? n1 5)): ~a" n1))
      (cons (+ (* n1 white-key-width) black-key-x3-start x-shift ) black-key-y-start ))
     ;; jetzt bleibt nur noch gis/as übrig
     ;; die einzige mittig angeordnete schwarze Taste
     (else
      (write (format "\n else: ~a" n1))
      (cons (+ (* n1 white-key-width) black-key-x2-start x-shift) black-key-y-start )))))

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
% New command to add a three sided box, with sides north, west and south
% Based on the box-stencil command defined in scm/stencil.scm
% Note that ";;" is used to comment a line in Scheme
#(define-public (NWS-box-stencil stencil thickness padding)
   "Add a box around STENCIL, producing a new stencil."
   (let* ((x-ext (interval-widen (ly:stencil-extent stencil X) padding))
          (y-ext (interval-widen (ly:stencil-extent stencil Y) padding))
          (y-rule (make-filled-box-stencil (cons 0 thickness) y-ext))
          (x-rule (make-filled-box-stencil
                   (interval-widen x-ext thickness) (cons 0 thickness))))
     ;; (set! stencil (ly:stencil-combine-at-edge stencil X 1 y-rule padding))
     (set! stencil (ly:stencil-combine-at-edge stencil X LEFT y-rule padding))
     (set! stencil (ly:stencil-combine-at-edge stencil Y UP x-rule 0.0))
     (set! stencil (ly:stencil-combine-at-edge stencil Y DOWN x-rule 0.0))
     stencil))

#(define (make-box-stencil stencil thickness padding)
   "Add a square box around @var{stencil}, producing a new stencil."
   (let* ((x-ext (ly:stencil-extent stencil X))
          (y-ext (ly:stencil-extent stencil Y))
          (x-length (interval-length x-ext))
          (y-length (interval-length y-ext))
          (new-x-ext (interval-widen x-ext padding))
          (new-y-ext (interval-widen y-ext padding))
          (y-rule (make-filled-box-stencil (cons 0 thickness) new-y-ext))
          (x-rule (make-filled-box-stencil
                   (interval-widen new-x-ext thickness) (cons 0 thickness))))
     (set! stencil (ly:stencil-combine-at-edge stencil X 1 y-rule padding))
     (set! stencil (ly:stencil-combine-at-edge stencil X -1 y-rule padding))
     (set! stencil (ly:stencil-combine-at-edge stencil Y 1 x-rule 0.0))
     (set! stencil (ly:stencil-combine-at-edge stencil Y -1 x-rule 0.0))
     ;; Uncomment to print x- and y-length
     ;; (newline)(write (interval-length (ly:stencil-extent stencil X)))
     ;; (newline)(write (interval-length (ly:stencil-extent stencil Y)))
     stencil))

#(define (make-key filled p)
   (let*
    ((a (ly:pitch-alteration p))
     (n (ly:pitch-notename p))
     (q  (naturalize-pitch p))
     (key-point (start-point-key q))
     )
    ; (write (format "\nmake-key pitch: ~a" p))
    ; (write (format "\nalteration: ~a" a))
    ; (write (format "\nstart point car: ~a" (car key-point)))
    ; (write (format "\nstart point cdr: ~a\n" (cdr key-point)))
    (cond
     ;; alteration eq 0
     ;; kein Vorzeichen ==> weiße Taste
     ((eq? a 0)
      ;; (write (format "\nwhite-key-width: ~a" white-key-width))
      ;; (write (format "\nwhite-key-height: ~a" white-key-height))
      ;(make-filled-box-stencil '(0 . 1) '(1 . 15))
      (if filled
          (make-box-stencil
           (ly:stencil-in-color
            (make-filled-box-stencil
             ;; erstes Pair: x-start x-end
             ;; zweites Pair: y-start y-end
             ;(cons (* n white-key-width) (* (+ n 1) white-key-width))
             (cons
              (car key-point)
              (+ (car key-point) white-key-width)
              )
             (cons 0 white-key-height)
             )
            1 1 1)
           0.5 0)
          (ly:stencil-in-color
           (make-filled-box-stencil
            ;; erstes Pair: x-start x-end
            ;; zweites Pair: y-start y-end
            ;(cons (* n white-key-width) (* (+ n 1) white-key-width))
            (cons
             (car key-point)
             (+ (car key-point) white-key-width)
             )
            (cons 0 white-key-height)
            )
           0.9 1 0.9)
          )
      )
     (else
      (make-filled-box-stencil
       (cons (car key-point) (+ (car key-point) black-key-width))
       (cons black-key-y-start (+ black-key-height black-key-y-start 0.5))
       )
      ))))

#(define (make-key-list filled l1)
   (if (null? l1)
       empty-stencil
       (ly:stencil-add
        (make-key filled (car l1))
        (make-key-list filled (cdr l1)))))

#(define-markup-command (make-keys layout props zahl arg1 arg2 arg3 arg4)
   (number? list? list? list? list?)
   ;; diese Funktion zeichnet eine in der Größe skalierbare Tonleiter
   ;; die unterste Schicht enthält alle Tasten in Hellgrau
   ;; die darüber liegende Schicht enthält die Tasten einer Tonleiter
   ;; in Hellblau (oder sonst einer wählbaren Farbe
   ;; die oberste Schicht enthält die Musiknoten in schwarz
   ;; arg1: weiße Tasten der Tonleiter
   ;; arg2: schwarze Tasten der Tonleiter
   ;; arg3: weiße Tasten der Noten
   ;; arg4: schwarze Tasten der Noten
   (ly:stencil-scale
    (ly:stencil-add
     ;; zunächst weißen Hintergrundtasten in Hellgrau
     (ly:stencil-in-color
      (make-key-list #t (event-chord-pitches
                         #{  < c, d, e, f, g, a, h, c d e f g a h c' d' e' f' g' a' h' c''
                             > #}
                         ) )
      0.9 0.9 0.9)
     ;; die weißen Tonleitertasten in Blau
     (ly:stencil-in-color (make-key-list #t arg1 )  0 0 1)
     ;; die weißen Musiktasten in schwarz
     (ly:stencil-in-color (make-key-list #f arg3 )  0 0 0)
     ;; die schwarzen Hintergrundtasten in Hellgrau
     (ly:stencil-in-color
      (make-key-list #f (event-chord-pitches
                         #{  < cis, es, fis, as, b,
                             cis dis fis as b cis' es' fis' as'  b'
                             > #}
                         ) )
      0.9 0.9 0.9)
     ;(ly:stencil-in-color (make-key-list arg2 )  0 0 1)
     (ly:stencil-in-color (make-key-list #f arg4 )  0 0 0)
     ) zahl zahl
    ))

meinTest=\markup \make-keys  #0.3  #(event-chord-pitches #{ < c d e a h c' > #})
#(event-chord-pitches #{ < fis > #})  #(event-chord-pitches #{ < g h d'  > #})
#(event-chord-pitches #{ < gis > #})
%meinTestI=\markup \make-keys  #0.3  #(all-pitches-from-music #{ < b cis' > #})

\relative c' {
  c^\meinTest
}
%%
%#(display (event-chord-pitches #{ < b cis' > #}))
%#(display (all-pitches-from-music  #{ \relative c' { a e } #} ))
