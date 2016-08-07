\version "2.18.0"
\language "deutsch"

%% often people think that the black keys are centered to the white keys
%% even in piano teaching books keyboards are drawn this way
%% this is not the case, black keys are positioned surprisingly excentric
%% http://lsr.di.unimi.it/LSR/Item?id=791 inspired me
%% to draw a keyboard with following features:
%% - scalable
%% - correct positioning of the black keys
%% - entering of a chord which notes are represented by dots

%% created by Manuela
%% feel free to modify and distribute

%% all values are measured by myself on my piano

#(define white-key-width 23.5) %% the width of a white piano key
#(define white-key-height 150) %% the height of a white piano key
#(define black-key-width 15)   %% the width of a black piano key
#(define black-key-height 95)  %% the height of a black piano key
#(define black-key-y-start (- white-key-height black-key-height)) %% the y-coordinate of black keys

%% left coordinate of black keys cis/des fis/ges
%% n=0 oder n=3 (index number of global default scale)

#(define black-key-cis-start 13)
%% left coordinate of centered black keys gis/as
%% n=4 (index number of global default scale)
#(define black-key-gis-start 16)
%% left coordinate of right black keys dis/es ais/b
%% n=1 oder n=5 (index number of global default scale)

#(define black-key-dis-start 19)
#(define octav-distance (* 7 white-key-width))
%% define circle diameter for the dots
%% just try what looks fine
#(define kreis-dm (* black-key-width 0.5)) %% circle diameter

%% scheme routines needed
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

#(define (low-pitch music)
   ;; returns the lowest pitch from music
   (car (sort (all-pitches-from-music music) ly:pitch<?)))

#(define (high-pitch music)
   ;; returns the highest pitch from music
   (car (reverse (sort (all-pitches-from-music music) ly:pitch<?))))

#(define (normalize-music music)
   ;; we subtract the octave from the lowest pitch
   ;; produces a sorted pitchlist from music
   ;; #(display (normalize-music #{ { c d e'' f g } #}))
   ;; (#<Pitch c' > #<Pitch d' > #<Pitch f' > #<Pitch g' > #<Pitch e''' >)
   (let* ((l-key (low-pitch music))
          (l-oct (ly:pitch-octave l-key)))
     ;; funktion body
     (map
      (lambda (p)
        ;(newline) (display "p: ")(display p)
        (let* ((p1 (naturalize-pitch p))
               (o1 (ly:pitch-octave p1))
               (a1 (ly:pitch-alteration p1))
               (o2 (inexact->exact (- o1 l-oct)))
               (n1 (ly:pitch-notename p1)))
          (ly:make-pitch o2 n1 a1)))
      (sort (all-pitches-from-music music) ly:pitch<?))
     ))

%% routine to move and scale a markup
#(define-markup-command (move-and-scale layout props mymark faktor x-offset)
   (markup? number? number?)
   (ly:stencil-translate-axis
    (ly:stencil-scale
     (interpret-markup layout props mymark)
     faktor faktor)
    x-offset X))

%% single white key
wh-taste =
#(make-connected-path-stencil
  ;; creates a square which is transformed
  ;; according to width and height of a white key
  '((0 0) (1 0) (1 1) (0 1))
  0.1 ;; thickness
  white-key-width
  white-key-height
  #t  ;; close path
  #f  ;; do not fill path
  )

w-tasten=
#(apply
  ly:stencil-add
  empty-stencil ; wh-taste
  (map
   (lambda (i) (ly:stencil-translate-axis wh-taste (* i white-key-width) X))
   (iota 7 )))

%% combining two octaves
dos-w-octavas=
#(ly:stencil-add
  w-tasten
  (ly:stencil-translate-axis w-tasten octav-distance X))

%% defining single black key
bl-taste=
#(make-connected-path-stencil
  '((0 0) (1 0) (1 1) (0 1) )
  0.1
  black-key-width
  black-key-height
  #t  ;; close path
  #t  ;; fill path
  )

%% combining 5 black keys for one octave
b-tasten =
#(ly:stencil-add
  (ly:stencil-translate
   bl-taste
   (cons black-key-cis-start black-key-y-start))
  (ly:stencil-translate
   bl-taste
   (cons (+ black-key-dis-start white-key-width ) black-key-y-start))
  (ly:stencil-translate
   bl-taste
   (cons (+ black-key-cis-start (* white-key-width 3) ) black-key-y-start))
  (ly:stencil-translate
   bl-taste
   (cons (+ black-key-gis-start (* white-key-width 4) ) black-key-y-start))
  (ly:stencil-translate
   bl-taste
   (cons (+ black-key-dis-start (* white-key-width 5) ) black-key-y-start)))

%% combining white and black keys to one octave

#(define (draw-music-complete music)
   (let* ((low-key (low-pitch music))
          (high-key (high-pitch music))
          (o-diff (- (ly:pitch-octave high-key) (ly:pitch-octave low-key)))
          (octave (ly:stencil-add w-tasten b-tasten)))
     ;; body of function
     ;; creates as many keyboardoctaves as music contains octaves
     ;(display o-diff)
     (apply
      ly:stencil-add
      empty-stencil
      (map
       (lambda (i) (ly:stencil-translate-axis octave (* i octav-distance) X))
       (iota o-diff )))
     ))

#(define (draw-stencil-keys-complete music mystencil)
   (let* ((low-key (low-pitch music))
          (high-key (high-pitch music))
          (o-diff (+ 1 (- (ly:pitch-octave high-key) (ly:pitch-octave low-key))))
          (octave (ly:stencil-add w-tasten b-tasten)))
     ;; body of function
     ;; creates as many keyboardoctaves as music contains octaves
     ;(display o-diff)
     (apply
      ly:stencil-add
      empty-stencil
      (map
       (lambda (i) (ly:stencil-translate-axis mystencil (* i octav-distance) X))
       (iota o-diff )))))

%% combining to octaves black keys
dos-b-octavas=
#(ly:stencil-add
  b-tasten
  (ly:stencil-translate-axis b-tasten octav-distance X))

complete-keyboard-two-octaves=
#(ly:stencil-add
  dos-w-octavas
  dos-b-octavas)

#(define (white-key? p)
   (let
    ((a (ly:pitch-alteration (naturalize-pitch p))))
    (if (= a 0)
        #t
        #f)))

#(define (start-point-key p)
   ;; calculation the starting point of a key
   ;; depending on the pitch p
   ;; result (x . y)
   (let*
    ((m (naturalize-pitch p))
     (o (ly:pitch-octave m))
     (a (ly:pitch-alteration m))
     ;; we must naturalize pitch otherwise wrong result for eis e.g.
     ;; we subtract the alteration from the notename and add a half
     ;; so we end up at the same note despite flat oder sharp
     ;; cis is drawn the same as des e.g.
     (n  (ly:pitch-notename m))
     (n1 (+ n a -0.5))
     (x-shift (* o 7 white-key-width))
     )
    (cond
     ((eq? a 0)
      ;; alteration eq 0
      ;; no alteration ==> white key
      (cons (+ (* n white-key-width) x-shift) 0 ))
     ((or (= n1 0) (= n1 3))
      ;; "left" black keys cis/des and fis/ges
      ;; notename=0 or 3 and alteration
      ;; n=0 oder n=3
      (cons (+ (* n1 white-key-width) black-key-cis-start x-shift ) black-key-y-start ))
     ((or (= n1 1) (= n1 5))
      ;; "right" black keys dis/es and ais/b
      ;; notename=0 or 3 and alteration
      ;, n=1 oder n=5
      (cons (+ (* n1 white-key-width) black-key-dis-start x-shift ) black-key-y-start ))
     (else
      ;; only one left, the centered black key gis/as
      (cons (+ (* n1 white-key-width) black-key-gis-start x-shift) black-key-y-start )))))

#(define (make-taste p)
   (let* ((wh-key
           (ly:stencil-add
            (ly:stencil-in-color
             (make-connected-path-stencil
              ;; creates a square which is transformed
              ;; according to width and height of a white key
              '((0 0) (1 0) (1 1) (0 1))
              0.1 ;; thickness
              white-key-width
              white-key-height
              #t  ;; close path
              #t  ;; do not fill path
              ) 0.7 0.95 1)
            (make-connected-path-stencil
             ;; creates a square which is transformed
             ;; according to width and height of a white key
             '((0 0) (1 0) (1 1) (0 1))
             0.1 ;; thickness
             white-key-width
             white-key-height
             #t  ;; close path
             #f  ;; do not fill path
             )))
          (bl-key
           (ly:stencil-in-color
            (make-connected-path-stencil
             '((0 0) (1 0) (1 1) (0 1) )
             0.1
             black-key-width
             black-key-height
             #t  ;; close path
             #t  ;; fill path
             ) 0.2 0.4 0.6))
          (start-p (start-point-key p)))
     (if (white-key? p)
         (ly:stencil-translate  wh-key start-p)
         (ly:stencil-translate  bl-key start-p)
         )))
#(set! paper-alist (cons '("mein Format" . (cons (* 35 in) (* 5 in))) paper-alist))
\paper {
  #(set-paper-size "mein Format")
}

TestMusik= \transpose c dis'' { c, dis d dis' e' g'' f''' }
#(define (male-tasten music)
   ;; draw all keys
   ;; black would not be necessary but I don't bother to filter them
   (apply
    ly:stencil-add
    empty-stencil
    (map
     (lambda (p) (make-taste p) )
     (normalize-music music))))

#(define (male-bl-tasten music)
   ;; draw only black keys
   (apply
    ly:stencil-add
    empty-stencil
    (map
     (lambda (p) (make-taste p) )
     (remove (lambda (p) (= 0 (ly:pitch-alteration p))) (normalize-music music))
     )))

#(display (remove (lambda (p) (= 0 (ly:pitch-alteration p)))
            ( normalize-music TestMusik)))

%\markup \move-and-scale \stencil #(male-tasten TestMusik) #0.3 #0

#(define (overlap-keys music)
   (ly:stencil-add
    (draw-stencil-keys-complete music w-tasten)
    (male-tasten music)
    (draw-stencil-keys-complete music b-tasten)
    (male-bl-tasten music)))
\markup \move-and-scale \stencil #(overlap-keys TestMusik) #0.4 #0

#(define (make-dot p)
   (let* ((start-p (start-point-key p)))
     (if (white-key? p)
         (ly:stencil-in-color
          (ly:stencil-translate
           (make-circle-stencil kreis-dm 0 #t)
           (cons
            (+ (car start-p) (/ white-key-width 2 ))
            (+ (cdr start-p) (/ (- white-key-height black-key-height) 1.5))))
          0.2 0.5 0.5) ;; color petrol
         (ly:stencil-in-color
          (ly:stencil-translate
           (make-circle-stencil kreis-dm 0 #t)
           (cons
            (+ (car start-p) (/ black-key-width 2 ))
            (+ (cdr start-p) (/ black-key-height 5))))
          0.4 0.7 0.7) ;; color slightly lighter petrol than above
         )))

%% creating a single stencil of multiple dots for a list of pitches
#(define (make-dot-list l1)
   (if (every ly:pitch? l1)
       (apply ly:stencil-add (map make-dot l1))
       empty-stencil))

#(define-markup-command
  (make-dots layout props the-chord)
  (ly:music?)
  (let*
   ((chord
     (map
      (lambda (m) (ly:music-property m 'pitch))
      (extract-named-music the-chord 'NoteEvent))))
   (make-dot-list chord)))

%% with newer versions use:
%#(define-markup-command
%  (make-dots layout props the-chord)
%  (ly:music?)
%  (make-dot-list (music-pitches the-chord)))

#(define-markup-command
  (complete layout props the-chord)
  (ly:music?)
  (ly:stencil-scale
   (ly:stencil-add
    dos-w-octavas
    dos-b-octavas
    (make-dot-list (music-pitches the-chord))
    ) 0.035 0.035)
  )

ChordwithKeyboard=
#(define-music-function
  (the-chord)
  (ly:music?)
  #{ <>^\markup \complete #the-chord
     $the-chord
  #}
  )

twoOctaves=
\markup {
  \combine \stencil \dos-w-octavas
  \combine \stencil \dos-b-octavas
  \null
}

%\markup "Draw a correct Keyboard with 2 octaves"
%\markup \move-and-scale \twoOctaves #0.3 #0
%\markup \move-and-scale \twoOctaves #0.3 #0
\markup \move-and-scale \stencil #(draw-music-complete TestMusik) #0.3 #0

%\markup { \null \vspace #4 "Draw a correct Keyboard with 2 octaves (approx. one staff high) and a chord" }

\score {
  <<
    \new Staff \ChordwithKeyboard \chordmode { b:sus4 }
    \new ChordNames \chordmode { b:sus4 }
  >>
}
