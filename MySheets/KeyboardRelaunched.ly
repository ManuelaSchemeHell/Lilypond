\version "2.18.0"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LSR workaround:
#(set! paper-alist (cons '("snippet" . (cons (* 190 mm) (* 155 mm))) paper-alist))
\paper {
  #(set-paper-size "snippet")
  tagline = ##f
  indent = 0
}
\markup\vspace #1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\language "deutsch"

%% I have evolved my keyboard snippet http://lsr.di.unimi.it/LSR/Item?id=1042
%% with more Scheme functions
%% Usage as markup: \markup \draw-keyboard-with-music #scalefactor #music
%% scalefactor is appr. the staff height
%% example usage as music function: \KeyboardwithMusic #scalefactor #music
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% definitions for the measures of the keyboard keys
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COLOR definitions for the music
%% just chose the colors you prefer
%% some examples as comment
%% check out the x11-colorlist http://lsr.di.unimi.it/LSR/Item?id=394
%% notation manual list of colors (German: p. 623)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#(define w-key-color (x11-color 'PeachPuff)) % LavenderBlush LightBlue linen WhiteSmoke cornsilk honeydew azure1 PeachPuff
#(define b-key-color (x11-color 'blue4))  % SaddleBrown blue4 DarkOliveGreen4 maroon DarkGrey DarkBlue

%% define complete scale plus c als pitchlist
#(define twelve-tones (list
                       (ly:make-pitch 0 0 0) ;c
                       (ly:make-pitch 0 0 SHARP) ; cis
                       (ly:make-pitch 0 1 0) ; d
                       (ly:make-pitch 0 1 SHARP) ; dis
                       (ly:make-pitch 0 2 0) ; e
                       (ly:make-pitch 0 3 0) ; f
                       (ly:make-pitch 0 3 SHARP) ; fis
                       (ly:make-pitch 0 4 0) ; g
                       (ly:make-pitch 0 4 SHARP) ; gis
                       (ly:make-pitch 0 5 0) ; a
                       (ly:make-pitch 0 5 SHARP) ; ais
                       (ly:make-pitch 0 6 0) ; h
                       (ly:make-pitch 1 0 0)
                       ))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Scheme programs needed for analyzing music
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
      (sort (all-pitches-from-music music) ly:pitch<?))))

#(define (white-key? p)
   (let
    ((a (ly:pitch-alteration (naturalize-pitch p))))
    (if (= a 0)
        #t
        #f)))

%% removes all pitches without alteration, leaves only black keys
#(define (bl-filter p-list)
   ;  (remove (lambda (p) (= 0 (ly:pitch-alteration p))) p-list))
   (remove white-key? p-list))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Scheme programs for drawing stencils
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%calculation the starting point of a key
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

%% defining key as stencil depending on pitch
#(define (draw-key p)
   ;; draws either a white key or a black key
   ;; the distance from origin depends on the pitch
   (let*
    ((wh-key
      (make-connected-path-stencil
       ;; creates a square which is transformed
       ;; according to width and height of a white key
       '((0 0) (1 0) (1 1) (0 1))
       0.1 ;; thickness
       white-key-width
       white-key-height
       #t  ;; close path
       #f  ;; do not fill path
       ))
     (bl-key
      (make-connected-path-stencil
       '((0 0) (1 0) (1 1) (0 1) )
       0.1
       black-key-width
       black-key-height
       #t  ;; close path
       #t  ;; fill path
       ))
     (start-p (start-point-key p)))
    (if (white-key? p)
        (ly:stencil-translate wh-key start-p)
        (ly:stencil-translate bl-key start-p)
        )))

%% define key as stencil with colors
#(define (draw-colored-key p)
   (let*
    ((wh-key
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
         )
        (first w-key-color)
        (second w-key-color)
        (third w-key-color))
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
        ) (first b-key-color) (second b-key-color) (third b-key-color)))
     (start-p (start-point-key p)))
    (if (white-key? p)
        (ly:stencil-translate  wh-key start-p)
        (ly:stencil-translate  bl-key start-p)
        )))

#(define (draw-keyboard music)
   (let*
    ((l-p (low-pitch music))  ;; lowest pitch of music
      (u-p (high-pitch music))  ;; highest pitch of music
      (l-oct (ly:pitch-octave l-p)) ;; octave of lowest pitch
      (u-oct (+ 1 (ly:pitch-octave u-p)))
      (oct-diff (inexact->exact (- u-oct l-oct))) ;; difference of octaves
      (c-up (ly:make-pitch oct-diff 0 0)) ;; make the highest pitch to draw; we start at 0 anyway
      (p-list (normalize-music music))  ;; make a list of normalized pitches (starting with octave 0)
      (bl-list (bl-filter p-list)) ;; only black keys of music
      ;; stencils; for clarity; could all be merged in one statement
      (octave (apply ly:stencil-add  ;; complete octave
                empty-stencil
                (map (lambda (p) (draw-key p))
                  twelve-tones)))
      (all-octaves (apply ly:stencil-add ;; complete keyboard in the range of the music
                     empty-stencil
                     (map (lambda (i)
                            (ly:stencil-translate-axis octave (* i 7 white-key-width) X))
                       (iota oct-diff ))))
      (cl-octave (apply ly:stencil-add  ;; complete octave
                   empty-stencil
                   (map (lambda (p) (draw-colored-key p))
                     p-list)))
      (bl-octave (apply ly:stencil-add  ;; black keys of one octave
                   empty-stencil
                   (map (lambda (p) (draw-key p))
                     (bl-filter twelve-tones))))
      (all-bl-octaves (apply ly:stencil-add ;; all black keys in the range of music; we must draw it again
                        empty-stencil
                        (map (lambda (i)
                               (ly:stencil-translate-axis bl-octave (* i 7 white-key-width) X))
                          (iota oct-diff))))
      (cl-bl-octave (apply ly:stencil-add
                      empty-stencil
                      (map (lambda (p) (draw-colored-key p))
                        (bl-filter p-list)))))
    ;; procedure body
    (ly:stencil-add
     all-octaves     ;; complete keyboard
     cl-octave       ;; white keys of music
     all-bl-octaves  ;; draw again black keys
     cl-bl-octave)   ;; black keys of music
    ))

%% defining markup command with scale-faktor and music
%% scale-faktor: approx. times height of stave
#(define-markup-command
  (draw-keyboard-with-music layout props scale-factor music)
  (number? ly:music?)
  (ly:stencil-scale
   (draw-keyboard music)
   (* scale-factor 0.035) (* scale-factor 0.035)))

KeyboardwithMusic=
#(define-music-function
  (parser location scale-factor music)
  (number? ly:music?)
  #{
    <<
      \new Staff  \with
      {
        \remove Bar_engraver
        \remove Bar_number_engraver
      }
      $TestMusik
      \new NoteNames { \textLengthOn $TestMusik }
      \new Staff \with
      {
        \remove Time_signature_engraver
        \remove Clef_engraver
        \remove Staff_symbol_engraver
        \remove Bar_engraver
        \override Staff.BarLine.stencil = ##f
        \remove Bar_number_engraver
      }
      { s1-\markup \draw-keyboard-with-music #scale-factor #TestMusik }
    >>
  #}
  )

TestMusik= \relative c'' { c d cis < fes g >  ces, dis }

\markup { "Draw a keyboard as markup with notes from music" }
\markup { \null \vspace #1 }
\TestMusik
\markup \draw-keyboard-with-music #4 #TestMusik
\markup { \null \vspace #1 }

\markup { "Draw a keyboard as music function" }
\KeyboardwithMusic #3 #TestMusik
