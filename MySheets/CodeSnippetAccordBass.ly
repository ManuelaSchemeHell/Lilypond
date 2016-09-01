\version "2.18.0"

\language "deutsch"

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Drawing a standard Stradella Accordion Bass
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#(define cycle-of-fifths ;; define circle of fifths as pitchlist
   (event-chord-pitches
    #{ heses' fes' ces' ges' des' as' es' b' f' c' g' d' a' e' h' fis' cis' gis' dis' ais' #}))

#(define Terz-circle ;; define counter bass notes as pitchlist
   (event-chord-pitches
    #{ des' as' es' b' f' c' g' d' a' e' h' fis' cis' gis' dis' ais' eis' his' g' d' #}))

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% pitch+music functions and definitions
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#(define (pitch-equals? p1 p2)
   (and
    (= (ly:pitch-alteration p1) (ly:pitch-alteration p2))
    (= (ly:pitch-notename p1) (ly:pitch-notename p2))))

#(define (note-name->string pitch)
   (let* ((a (ly:pitch-alteration pitch))
          (n (ly:pitch-notename pitch)))
     (make-concat-markup
      (list
       (make-simple-markup
        (vector-ref #("C" "D" "E" "F" "G" "A" "B") n))
       (if (= a 0)
           (make-line-markup (list empty-markup))
           (make-line-markup
            (list
             (alteration->text-accidental-markup a)
             (make-hspace-markup 0.1))))))))

#(define (chord-superscript n)
   ;; get the superscript for row n
   ;; counter bass notes and root notes have no superscript
   (cond
    ((= n 2) "M")
    ((= n 3) "m")
    ((= n 4) "7")
    ((= n 5) "o")
    (else "")))

#(define (ChordName->markup p n)
   ;; make the name from a chord with pitch p in row n
   ;; you get an error when the pitch is not in the circle of fifths
   (let* ((i (get-Index p))
          (terz (note-name->string (list-ref Terz-circle i)))
          (bas (note-name->string (list-ref cycle-of-fifths i)))
          ;; root name of the button
          (simple
           (if (= n 0) terz bas)))
     (make-concat-markup
      (list
       simple
       (make-smaller-markup
        (make-raise-markup 0.6 (make-simple-markup (chord-superscript n))))))))

#(define (get-Index p)
   ;; get the index of a pitch p in the circle of fifths
   ;; this number is needed to create the labels of the bass buttons
   (list-index (lambda(x)(pitch-equals? x p)) cycle-of-fifths))

#(define-markup-command (accordion-bass layout props i-col i-row)
   (index? index? )
   ;; draw a standard stradella accordion bass with 120 buttons
   ;; mark the button in column i-col and i-row in a different color
   ;; column 0: B doubleflat, col 9: C, col 19: A#
   ;; the rows: 1=diminished chord, 2=7th chord,
   ;;           3=minor chord, 4=major chord, 5=root note, 6=counter bass note

   #:properties ((font-size 0) (thickness 2.5) (offset 3.5)(circle-padding 0.2))
   (let* ((Bbb (interpret-markup layout props
                 ;; this should be the largest circle diameter needed for button labels
                 ;; checking out the horizontal extent of B DOUBLEFLAT sup M
                 (make-concat-markup
                  (list
                   (make-simple-markup "B")
                   (make-musicglyph-markup
                    "accidentals.flatflat")
                   (make-smaller-markup
                    (make-raise-markup 0.6 (make-simple-markup "M")))))))
          (Bbb-xt ( ly:stencil-extent Bbb X))
          (Bbb-x (- (cdr Bbb-xt) (car Bbb-xt)))
          ;; calculating padding from circle-padding
          (pad (* (magstep font-size) circle-padding 2))
          ;; adding pad to extent of widest button label
          (dm-circle (+ (/ Bbb-x 2) pad)) ;; don'tm mess radius with diameter!
          (col-dist (+ (* 2 dm-circle) pad)) ;; distance between two buttons in a row
          (row-dist 0.95) ;; you can vary the distance between the button rows
          (h-shift (+ dm-circle pad)) ;; horizontal shifting of the botton rows
          (thick (* (magstep font-size) (ly:output-def-lookup layout 'line-thickness)))
          (underline-thick (* thickness thick))
          (my-circle (make-circle-stencil dm-circle thick #f))
          ;; needed for underline
          (y (* thick (- offset)))
          (a1 (- 6 i-row)))
     (apply ly:stencil-add
       empty-stencil
       (map
        (lambda (z)
          (ly:stencil-translate
           (apply ly:stencil-add
             empty-stencil
             (map
              (lambda (x)
                (let* ((m (interpret-markup layout props
                            (ChordName->markup (list-ref cycle-of-fifths x) z)))
                       (myx  (ly:stencil-extent m X))
                       (xstart (car myx))
                       (xend (cdr myx))
                       (breite (- xend xstart))
                       (myy  (ly:stencil-extent m Y))
                       (hoch (- (cdr myy) (car myy))))
                  (ly:stencil-translate-axis
                   (ly:stencil-add
                    ;; mark C-Button
                    (if (and (= 1 z)(= 9 x))
                        (ly:stencil-add
                         (ly:stencil-in-color (make-circle-stencil dm-circle 0 #t)
                           1 1 1)
                         (make-circle-stencil (- dm-circle (* 5 thick)) (* 5 thick) #f))
                        empty-stencil)
                    ;; mark Ab- and E-Buttons
                    (if (and (= 1 z)(or (= 5 x)(= 13 x)))
                        (ly:stencil-add
                         (ly:stencil-in-color (make-circle-stencil dm-circle 0 #t)
                           1 1 1)
                         (make-circle-stencil (- dm-circle (* 5 thick)) (* 2.5 thick) #f))
                        empty-stencil)
                    ;; mark Button in col i-col and row i-row
                    ;; (some calculation is done because we draw row 6 first
                    ;;and work our way upwards)
                    (if (and (= a1 z)(= i-col x))
                        (ly:stencil-in-color (make-circle-stencil dm-circle 0 #t)
                          0.9 1 0.9) ;; a light green color
                        empty-stencil)
                    ;; this is our chord name as button label
                    ;; underlined if counter bass note
                    (ly:stencil-translate-axis
                     (ly:stencil-translate-axis
                      (ly:stencil-add
                       (if (= 0 z)
                           (make-line-stencil underline-thick xstart y xend y)
                           empty-stencil)
                       m)
                      (- 0 (/ breite 2)) X)
                     (- 0 (/ hoch 2)) Y)
                    ;; this is the button
                    my-circle)
                   (* x col-dist) X)))
              ;; loop through all columns
              (iota 20 0)))
           ;; calculate horizontal and vertical shift relative to the leftmost button
           ;; in the row with the diminished chords
           (cons (* z h-shift) (* z col-dist (* row-dist -1)))))
        ;; loop through all rows
        (iota 6)))))

\markup \column {
  \line { \vspace #2 }
  \line { "Draw a standard Accordion bass system using Markup-funcions of Lilypond" }
  \line { "the Buttons A" \flat ", C and E are marked" }
  \line { "mark a button in a different color by entering its row and column number" }
  \line { \underline "first number:" "column (0=B" \hspace #-0.5 \super \fontsize #1 \doubleflat ", 19=A" \hspace #-0.5 \super \sharp ")" }
  \line { \underline "second number:" "row (1=diminished chord, 2=7th chord, " }
  \line { "3=minor chord, 4=major chord, 5=root note, 6=counter bass note)" }
  \line { "if the parameters are outside this range no button is colored" }
  \line { "change the scale factor to a number you like" }
  \line { "usage:" \bold " \markup \scale #'(0.75 . 0.75) \accordion-bass #4 #2" }
  \line { \vspace #1 }
}
\markup \scale #'(0.75 . 0.75) \accordion-bass #4 #1
