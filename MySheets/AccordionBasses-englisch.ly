\version "2.19.37"
\language "deutsch"
%\include "G:/Lilypond/_MyScheme/myExceptions.ily"
\include "G:/Lilypond/__MySheets/myExceptions.ily"
FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))
\paper {
  #(set-paper-size "a4")
  annotate-spacing = ##f
  left-margin = #20
  top-margin = #25
  ragged-right = ##t
  ragged-bottom = ##t
  bottom-margin = #20
  indent = #0
  system-system-spacing.minimum-distance = #40 %50
  %system-system-spacing.extra-distance = #10
  system-system-spacing.basic-distance = #50 %30
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
}
\layout {

  \context {
    \Staff
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    %\consists Mark_engraver
    \override StaffSymbol.thickness = #0.35 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
  }

  \context {
    \Score
    \remove Bar_number_engraver
    \override NonMusicalPaperColumn.line-break-permission = ##f
    \override NonMusicalPaperColumn.page-break-permission = ##t
    %\remove Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override RehearsalMark.outside-staff-priority=##f
    \override RehearsalMark.extra-offset = #'(-3 . 4)
    \override KeyCancellation.break-visibility = #'#(#f #t #t)
    \override TextScript.self-alignment-X = #LEFT
  }
  \context {
    \ChordNames
    chordNameLowercaseMinor = ##f
    %chordRootNamer = #germanChords
    %chordNoteNamer = #note-name->german-markup
    chordNameExceptions = #chExceptions
    majorSevenSymbol = \markup { maj7 }
  }
}
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
   (let* ((cl (list-all-chords-from-music music)))
     (if (equal? cl '())
         (all-pitches-from-music music)
         (map (lambda(x)(all-pitches-from-music x))
           (list-all-chords-from-music music)))))

#(define (ohne-quint pl)
   (let* ((len (length pl))
          (qui (if (< len 3) (- len 1) 2))
          (pi (list-ref pl qui)))
     (if (> len 2)
         (delete pi pl)
         pl)))

%% convert pitchlist to a music chord
#(define (pitches->chord plist)
   (make-music 'EventChord 'elements
     (if (list? plist)
         (map (lambda (p)
                (make-music
                 'NoteEvent 'duration (ly:make-duration 0)
                 'pitch p))
           plist)
         (make-music
          'NoteEvent 'duration (ly:make-duration 0)
          'pitch plist)
         )))

#(define (pitches->music plist)
   (if (list? plist)
       (make-music 'SequentialMusic 'elements
         (map (lambda (p)
                (make-music
                 'NoteEvent 'duration (ly:make-duration 3)
                 'pitch p))
           plist))
       (make-music 'SequentialMusic 'elements
         (make-music
          'NoteEvent 'duration (ly:make-duration 3)
          'pitch plist))))

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

%#(write-me "list-tail -----------> " (list-tail Q-circle 15))
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

%#(write-me "notenam -----------> " (note-name->string (list-ref Q-circle 1)))
%\markup #(note-name->string (list-ref Q-circle 3))
Terz = {
  <des> <as> <es> <b> <f> <c> <g> <d> <a> <e> <h> <fis> <cis> <gis> <dis> <ais> <eis> <his> <g> <d>
}

Grund={
  <heses> <fes> <ces> <ges> <des> <as> <es> <b> <f> <c> <g> <d> <a> <e> <h> <fis> <cis> <gis> <dis> <ais>
}

Dur = \relative c'' {
  < a cis e >1 < e gis h > < ces es ges > < ges' b des > < des f as > < as' c es > < es g b > < b' d f > < f a c > < c e g > < g' h d > < d fis a > < a' cis e > < e gis h > < h' dis fis > < fis ais cis > < cis eis gis > < gis' his dis > < dis fisis ais > < ais' cisis eis >
}

Moll =  \relative c'' {
  < a c e >1 < e g h > < ces eses ges > < ges' heses des > < des fes as > < as' ces es > < es ges b > < b' des f > < f as c > < c es g > < g' b d > < d f a > < a' c e > < e g h > < h' d fis > < fis a cis > < cis e gis > < gis' h dis > < dis fis ais > < ais' cis eis >
}

Sept =\relative c'' {
  < a cis g' >1 < e gis d' > < ces es heses' > < ges' b fes' > < des f ces' > < as' c ges' > < es g des' > < b' d as' > < f a es' > < c e b' > < g' h f' > < d fis c' > < a' cis g' > < e gis d' > < h' dis a' > < fis ais e' > < cis eis h' > < gis' his fis' > < dis fisis cis' > < ais' cisis gis' >
}

Verm =  \chordmode {
  a:dim7 e:dim7 h:dim7 ges:dim7 des:dim7 as:dim7 es:dim7
  b:dim7 f:dim7 c:dim7 g:dim7 d:dim7 a:dim7 e:dim7 h:dim7
  fis:dim7 cis:dim7 gis:dim7 dis:dim7 ais:dim7

}

xVerm =  \relative c'' {
  < a c ges' >1 < e g des' > < h d as' > < ges' heses feses' > < des fes ceses' > < as' ces geses' > < es ges deses' > < b' des asas' > < f as eses' > < c es heses' > < g' b fes' > < d f ces' > < a' c ges' > < e g des' > < h' d as' > < fis a es' > < cis e b' > < gis' h f' > < dis fis c' > < ais' cis g' >
}

%% originale Bässe mit tatsächlichen Tonhöhen
oDur = {
  < a cis e' > < e' gis h > < ces es ges > < ges b des > < des' f' as > < as c' es' > < es' g b > < b d' f' > < f' a c' > < c' e' g > < g h d' > < d' fis' a > < a cis' e' > < e' gis h > < h dis' fis > < fis ais cis' > < cis' eis' gis > < gis his dis' > < dis' fisis ais > < ais cisis' eis' >
}
%\xVerm
oMoll = {
  < a c' e' > < e' g h > < ces' eses' ges' > < ges heses des' > < des' fes' as > < as ces' es' > < es' ges b > < b des' f' > < f' as c' > < c' es' g > < g b d' > < d' f' a > < a c' e' > < e' g h > < h d' fis > < fis a cis' > < cis' e' gis > < gis h dis' > < dis' fis ais > < ais cis' eis >
}

oSept = {
  < a cis' g > < e' gis d' > < ces' es' heses > < ges b fes' > < des' f ces' > < as c' ges > < es' g des' > < b d' as > < f a es' > < c' e' b > < g h f > < d' fis c' > < a cis' g > < e' gis d' > < h dis' a > < fis ais e' > < cis' eis' h > < gis his fis > < dis' fisis cis' > < ais cisis' gis >
}

oVerm = {
  < a c' fis > < e' g cis' > < ces' eses' as > < ges heses c' > < des' feses' b > < as ces' f' > < es' ges c' > < b des' g > < f' as d' > < c' es' a > < g b e' > < d' f' h > < a c' fis > < e' g cis' > < h d' gis > < fis a dis' > < cis' e' b > < gis h f' > < dis' fis c' > < ais cis' g >
}

%\oDur
%\oMoll
%\oSept
%\oVerm

%#(write-me "pitchlist Dur ------------> " (pitchlist-of-chordlist Dur))
#(define (reduce-chordlist pitch-list)
   (map (lambda (x)
          (let* ((a (ly:pitch-alteration x))
                 (n (ly:pitch-notename x)))
            (ly:make-pitch 0 n a)))
     pitch-list))

#(define (get-Index p)
   (list-index (lambda(x)(pitch-equals? x p)) Q-circle))

#(define (get-Name p)
   (note-name->german-string p))

%#(write-me "length (list-all-chords-from-music Sept" (length (list-all-chords-from-music Sept)))
%#(write-me "length (list-all-chords-from-music Verm" (length (list-all-chords-from-music Verm)))
#(define (get-Music p n)
   (let* ((i (get-Index p)))
     (cond
      ((= 5 n) (list-ref (list-all-chords-from-music Terz) i))
      ((= 4 n) (list-ref (list-all-chords-from-music Grund) i))
      ((= 3 n) (list-ref (list-all-chords-from-music Dur) i))
      ((= 2 n) (list-ref (list-all-chords-from-music Moll) i))
      ((= 1 n) (list-ref (list-all-chords-from-music Sept) i))
      ((= 0 n) (list-ref (list-all-chords-from-music Verm) i))
      )))

#(define (get-Musico p n)
   (let* ((i (get-Index p)))
     (write-me "get-Musico n -------> " n)
     (write-me "get-Musico i -------> " i)
     (write-me "get-Musico p -------> " p)
     (cond
      ((= 5 n) (list-ref (list-all-chords-from-music Terz) i))
      ((= 4 n) (list-ref (list-all-chords-from-music Grund) i))
      ((= 3 n) (list-ref (list-all-chords-from-music Dur) i))
      ((= 2 n) (list-ref (list-all-chords-from-music Moll) i))
      ((= 1 n) (list-ref (list-all-chords-from-music Sept) i))
      ((= 0 n) (list-ref (list-all-chords-from-music xVerm) i))
      )))
%#(write-me "list-all-chords-from-music  ----------> " (list-ref (list-all-chords-from-music Terz) 2))

%\displayLilyMusic #(list-ref (list-all-chords-from-music Terz) 2)

#(define (get-Chord p n)
   ;; n=0: Dur Akkord
   ;; n=1: Moll Akkord
   ;; n=2: Septakkord
   ;; n=3: verminderter Akkord
   ;; n=4: Grundbass
   ;; n=5: Terzbass
   (let* ((i (get-Index p)))
     ;(write-me "get-Chord p n i---------->:" i)
     (cond
      ((= 5 n) (list (list-ref Terz-circle i)))
      ((= 4 n) (list (list-ref Q-circle i)))
      ((= 3 n) (list-ref (pitchlist-of-chordlist Dur) i))
      ((= 2 n) (list-ref (pitchlist-of-chordlist Moll) i))
      ((= 1 n) (list-ref (pitchlist-of-chordlist Sept) i))
      ((= 0 n) (list-ref (pitchlist-of-chordlist xVerm) i))
      (else #f)
      )))

#(define (DMSV n)
   ;; n=0: "Dur-"
   ;; n=1: Moll
   ;; n=2: Sept
   ;; n=3: Dim
   (cond
    ((= n 3) "M")
    ((= n 2) "m")
    ((= n 1) "7")
    ((= n 0) "o")
    ))

%#(write-me "mit quint ---------->  " (list-ref (pitchlist-of-chordlist Verm) 3))
%#(write-me "ohne-quint ---------->  " (ohne-quint (list-ref (pitchlist-of-chordlist Verm) 3)))

#(define (ChordName->markup p n)
   (let* ((bname (string-downcase (note-name->german-string p)))
          (cname (string-capitalize bname))
          (i (get-Index p))
          (terz (string-capitalize (note-name->german-string (list-ref Terz-circle i))))
          (simple
           (cond
            ((>= n 5)
             terz)
            ((= n 4)
             cname)
            (else bname)))
          (hoch
           (cond
            ((<= n 2) (DMSV n))
            (else ""))))
     (make-concat-markup
      (list
       (make-simple-markup simple)
       (make-smaller-markup
        (make-raise-markup 0.6 (make-simple-markup hoch)))))))

#(define (ChordName-e->markup p n)
   (let* ((i (get-Index p))
          (terz (note-name->string (list-ref Terz-circle i)))
          (bas (note-name->string (list-ref Q-circle i)))
          (simple
           (if (>= n 5) terz bas))
          (hoch
           (cond
            ((<= n 3) (DMSV n))
            (else ""))))
     ;(write-me "ChordName-e->markup p -----------> " p )
     ;(write-me "ChordName-e->markup n -----------> " n )
     ;(write-me "ChordName-e->markup terz -----------> " terz )
     ;(write-me "ChordName-e->markup simple -----------> " simple )
     (make-concat-markup
      (list
       simple
       (make-smaller-markup
        (make-raise-markup 0.6 (make-simple-markup hoch)))))))

%\markup #(ChordName-e->markup (ly:make-pitch 0 0 0) 3)

#(define (comb-chords p1 p2 a1 a2)
   ;; create a new pitchlist from two chords
   ;; pitches p1 and p2
   ;; a1 and a2 characterize if Dur, Moll etc.
   ;; remove double pitches
   (delete-duplicates
    (append
     (get-Chord p1 a1)
     (get-Chord p2 a2))))

#(define (p-diff-min pitchlist)
   ;; minimum of pitch differences
   (let* ((list1
           (sort
            (delete-duplicates
             (map (lambda(x)(ly:pitch-semitones x)) pitchlist)) <))
          (mylen (- (length list1) 1))
          (dlist
           (map
            (lambda(y)(abs (- (list-ref list1 y) (list-ref list1 (+ y 1)))))(iota mylen))))
     (write-me "pitchdiff pitchlist -------> " pitchlist)
     (write-me "pitchdiff dlist -----------> " dlist)
     (fold min 300 dlist)))

#(define-markup-command (draw-acc-bass-combine layout props p1 p2 a1 a2)
   (ly:pitch? ly:pitch? number? number?)
   #:properties ((font-size 0) (thickness 2.5) (offset 3.5)(circle-padding 0.2))
   (let* ((myA (interpret-markup layout props
                 (make-concat-markup
                  (list
                   (make-simple-markup "ges")
                   (make-smaller-markup
                    (make-raise-markup 0.6 (make-simple-markup "m")))))))
          (ces7-xt ( ly:stencil-extent myA X))
          (ces7-x (- (cdr ces7-xt) (car ces7-xt)))
          (pad (* (magstep font-size) circle-padding 2))
          (dm-circle (+ (/ ces7-x 2) pad)) ;; don'tm mess radius with diameter!
          (col-dist (+ (* 2 dm-circle) pad))
          (row-dist 0.9)
          (h-shift (+ dm-circle 0))
          (my-circle (make-circle-stencil dm-circle 0.1 #f))
          (thick (* (magstep font-size) (ly:output-def-lookup layout 'line-thickness)))
          (underline-thick (* thickness thick))
          (y (* thick (- offset)))
          (i1 (get-Index p1))
          (i2 (get-Index p2))
          )
     ;procedure body

     (write-me "dm-circle -----------> " dm-circle)
     ;(write-me "layout-----------> " (ly:output-def? layout) )
     ; (write-me "props-----------> "  props)
     ;(write-me "myA-----------> " myA )
     (write-me "font-size-----------> " font-size)
     ; (write-me "padding-----------> " font-size)
     (write-me "pad-----------> " pad)
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
                  (let* ((m (interpret-markup layout props
                              (ChordName-e->markup (list-ref Q-circle x) z)))
                         (myx  (ly:stencil-extent m X))
                         (xstart (car myx))
                         (xend (cdr myx))
                         (breite (- xend xstart))
                         (myy  (ly:stencil-extent m Y))
                         (hoch (- (cdr myy) (car myy))))
                    (ly:stencil-translate-axis
                     (ly:stencil-add
                      (if (and (= 4 z)(= 9 x))  ;; mark C-Button
                          (ly:stencil-add
                           (ly:stencil-in-color (make-circle-stencil dm-circle 0 #t)
                             0.95 0.95 0.95)
                           (make-circle-stencil (* dm-circle 0.95) 1 #f))
                          empty-stencil)
                      (if (and (= 4 z)(or (= 5 x)(= 13 x))) ;; mark As- and E-Buttons
                          (ly:stencil-add
                           (ly:stencil-in-color (make-circle-stencil dm-circle 0 #t)
                             0.95 0.95 0.95)
                           (make-circle-stencil (* dm-circle 0.95) 0.5 #f))
                          empty-stencil)
                      (if (and (= a1 z)(= i1 x))  ;; mark p1 Button
                          (ly:stencil-in-color (make-circle-stencil dm-circle 0 #t)
                            0.9 1 0.9)
                          empty-stencil)
                      (if (and (= a2 z)(= i2 x))  ;; mark p2 Button
                          (ly:stencil-in-color (make-circle-stencil dm-circle 0 #t)
                            1 0.9 1)
                          empty-stencil)
                      (if (and (= 12 (abs (- i2 x))) (= a2 z)) ; mark equivalent button
                          (ly:stencil-in-color (make-circle-stencil dm-circle 0 #t)
                            0.9 0.9 0.9)
                          empty-stencil)
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

%\markup \scale #'(0.75 . 0.75) \draw-acc-bass-combine #(list-ref Q-circle 2) #(list-ref Q-circle 3) #2 #1

DrawCombinedBass=
#(define-music-function (parser location p1 p2 a1 a2)
   (ly:pitch? ly:pitch? number? number?)
   (let* ((p1+p2 (comb-chords p1 p2 a1 a2))
          (cho1 (get-Music p1 a1))
          (cho2 (get-Music p2 a2))
          (cho3 (get-Musico p2 a2))
          (cho4 (get-Musico p1 a1))
          (nam1 (ChordName-e->markup p1 a1))
          (nam2 (ChordName-e->markup p2 a2))
          (mychord (pitches->chord p1+p2))
          (mymusic (pitches->music p1+p2)))
     ;(write-me "combined pitches p1+p2 -------------> " p1+p2)
     ;(write-me "combined chords p1-----------------> " (markup->string nam1))
     ;(write-me "combined chords p2-----------------> " nam2)

     #{
       {
         <<
           \context Staff = "MyChords" {
             \override Staff.TextScript.extra-offset=#'(10 . 7)
             \override Score.RehearsalMark.font-size = #3
             <>^\markup {
               \null \vspace #2 \fontsize #2 \with-color #blue {
                 \override #'(thickness . 3)
                 \underline \concat {
                   "Combining Chord "
                   \bold \fontsize #1 $nam1 " with "
                   \bold \fontsize #1 $nam2
                 }
               }
             }
             \clef treble {
               \mark \markup %\translate #'(0 . 10)
               \scale #'(0.5 . 0.5) \draw-acc-bass-combine #p1 #p2 #a1 #a2
               $mychord
               $cho4
               $cho3
             }
             \clef bass \transpose c c, {
               $mychord
               $cho4
               $cho3 \break
             }
             %$mymusic %\break
             \void \displayLilyMusic $mychord
             %\void \displayMusic $mychord
           }
           \context ChordNames \with { alignBelowContext = #"MyChords" }
           {
             \override ChordName.font-name = #"MS Mincho"
             \set chordNameExceptions = #chExceptions
             $mychord
             $cho1
             $cho2
             $mychord
             $cho1
             $cho2
           }
         >>
       }
     #}
     ))

myDur={ c d } %dis es e f fis ges g gis as a ais b h }

DrawCombinedIII=
#(define-music-function (parser location p1)
   (ly:pitch? )
   (make-sequential-music
    (append-map
     (lambda(n1)
       (append-map
        (lambda(n2)
          (map
           (lambda (p2)
             (let ((cocho (comb-chords p1 p2 n1 n2)))
               ;(write-me "are equal" (pitch-equals? p1 p2))
               (if (and (pitch-equals? p1 p2) (= n1 n2))
                   (empty-music)
                   (if (or (> (length cocho) 6) (< (p-diff-min cocho) 2))
                       (empty-music)
                       (DrawCombinedBass p1 p2 n1 n2)
                       ))))
           (all-pitches-from-music myDur)))
        (iota 4 3 -1)))
     (iota 4 3 -1))
    ))

\DrawCombinedIII c
