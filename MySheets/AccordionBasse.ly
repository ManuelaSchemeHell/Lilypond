\version "2.19.37"
\language "deutsch"

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% defining circle diameter and distances
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%#(define dm-circle 3.3)
%#(define amount 4000)
%#(define dist (/ dm-circle amount))
%#(define vdist 0.9) %% the vertical distance of the circles, check out smaller values
%#(define steep 1) %% how steep should the rows be; the greater the nearer to 90 degrees
%#(define h-dist (/ dm-circle steep))

#(define dm-circle 3.3) %% the radius of the buttons
#(define col-dist (+ (* 2 dm-circle) 0.1)) %% distance between 2 button columns, default: 2*radius plus a little
#(define row-dist 1) %% the vertical distance of the button rows, check out smaller values
#(define h-shift dm-circle) %% defines much a button row is shifted horizontally relativ to the next lower row
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

#(define (pitchlist-of-chordlist music)
   (map (lambda(x)(all-pitches-from-music x))
     (list-all-chords-from-music music)))

%% make pitchlist to a chord again
#(define (pitches->chord plist)
   (make-music 'EventChord 'elements
     (map (lambda (p)
            (make-music
             'NoteEvent 'duration (ly:make-duration 0)
             'pitch p))
       plist)))

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

Dur = {
  < a cis' e' > < e' gis h > < ces es ges > < ges b des > < des' f' as > < as c' es' > < es' g b > < b d' f' > < f' a c' > < c' e' g > < g h d' > < d' fis' a > < a cis' e' > < e' gis h > < h dis' fis > < fis ais cis' > < cis' eis' gis > < gis his dis' > < dis' fisis ais > < ais cisis' eis' >
}

Moll = {
  < a c' e' > < e' g h > < ces' eses' ges' > < ges heses des' > < des' fes' as > < as ces' es' > < es' ges b > < b des' f' > < f' as c' > < c' es' g > < g b d' > < d' f' a > < a c' e' > < e' g h > < h d' fis > < fis a cis' > < cis' e' gis > < gis h dis' > < dis' fis ais > < ais cis' eis >
}

Sept = {
  < a cis' g > < e' gis d' > < ces' es' heses > < ges b fes' > < des' f ces' > < as c' ges > < es' g des' > < b d' as > < f a es' > < c' e' b > < g h f > < d' fis c' > < a cis' g > < e' gis d' > < h dis' a > < fis ais e' > < cis' eis' h > < gis his fis > < dis' fisis cis' > < ais cisis' gis >
}

Verm = {
  < a c' fis > < e' g cis' > < ces' eses' as > < ges heses c' > < des' feses' b > < as ces' f' > < es' ges c' > < b des' g > < f' as d' > < c' es' a > < g b e' > < d' f' h > < a c' fis > < e' g cis' > < h d' gis > < fis a dis' > < cis' e' b > < gis h f' > < dis' fis c' > < ais cis' g >
}

#(write-me "pitchlist Dur ------------> " (pitchlist-of-chordlist Dur))
#(define (reduce-chordlist ch-list)
   (map (lambda (x)
          (let* ((a (ly:pitch-alteration x))
                 (n (ly:pitch-notename x)))
            (ly:make-pitch 0 n a)))
     ch-list))

#(define (get-Index p)
   (list-index (lambda(x)(pitch-equals? x p)) Q-circle))

#(define (get-Name p)
   (note-name->german-string p))

#(define (get-Chord p n)
   ;; n=0: Dur Akkord
   ;; n=1: Moll Akkord
   ;; n=2: Septakkord
   ;; n=3: verminderter Akkord
   ;; n=4: Grundbass
   ;; n=5: Terzbass
   (let* ((i (get-Index p)))
     (cond
      ((= 5 n) (list (list-ref Terz-circle i)))
      ((= 4 n) (list (list-ref Q-circle i)))
      ((= 3 n) (list-ref (pitchlist-of-chordlist Dur) i))
      ((= 2 n) (list-ref (pitchlist-of-chordlist Moll) i))
      ((= 1 n) (list-ref (pitchlist-of-chordlist Sept) i))
      ((= 0 n) (list-ref (pitchlist-of-chordlist Verm) i))
      )))

#(write-me "get-Chord list? 5--------> " (list? (get-Chord (list-ref Q-circle 2) 5)))
#(write-me "get-Chord list? 4----> " (list? (get-Chord (list-ref Q-circle 2) 4)))
#(write-me "get-Name ---------------> " (get-Name (list-ref Q-circle 0)))
#(define (DMSV n)
   ;; n=0: "Dur-"
   ;; n=1: Moll
   ;; n=2: Sept
   ;; n=3: Dim
   (cond
    ((= n 3) "")
    ((= n 2) "m")
    ((= n 1) "7")
    ((= n 0) "v")
    ))

#(define (ChordName->markup p n)
   (let* ((bname (string-downcase (get-Name p)))
          (cname (string-capitalize bname))
          (i (get-Index p))
          (terz (string-capitalize(get-Name (list-ref Terz-circle i))))
          (simple
           (cond
            ((>= n 5)
             terz)
            ((= n 4)
             cname)
            (else bname)
            ))
          (hoch
           (cond
            ((<= n 2) (DMSV n))
            (else ""))))
     (make-concat-markup
      (list
       (make-simple-markup simple)
       (make-smaller-markup
        (make-raise-markup 0.6 (make-simple-markup hoch)))))))

#(write-me "markup? -------------> " (markup? (ChordName->markup (list-ref Q-circle 3) 3)))
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
       (get-Chord p1 a1)
       (get-Chord p2 a2)
       )) ly:pitch<?)
    (list p1 p2 a1 a2)))

%#(write-me "combine-chords -------------> "
%   (combine-chords (list-ref Q-circle 3) (list-ref Q-circle 4) 1 2))

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
#(write-me "combined Chords -------------> " combine-all-chords)

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
          (let ((zz (- 5 z)))
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
                         (if (= 0 zz)
                             (make-line-stencil underline-thick xstart y xend y)
                             empty-stencil)
                         m)
                        (- 0 (/ breite 2)) X)
                       (- 0 (/ hoch 2)) Y) ;; chordname plus underline if terzbass
                      my-circle) ;; circled chordname
                     (* x col-dist) X)))
                (iota 20 0)))
             (cons (* zz h-shift) (* zz col-dist (* row-dist -1))))))
        (iota 6)))))

%#(display (list? (car combined-chords)))

\markup \scale #'(0.8 . 0.8) \draw-acc-bass

%#(write-me " pitches->chord----> " (ly:music? (pitches->chord Terz-circle)))
%\displayMusic #(pitches->chord Terz-circle)
