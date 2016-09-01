\version "2.19.37"
\language "deutsch"

%% create diatonic chords from a scale
%% enter the steps of the scale as lily music
%% and chose the number of notes the chords should have

FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))
\paper {
  #(set-paper-size "a4")
  annotate-spacing = ##f
  left-margin = #20
  top-margin = #25
  ragged-right = ##f
  ragged-bottom = ##t
  bottom-margin = #20
  indent = #0
  system-system-spacing.minimum-distance = #60 %50
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
    %chordNameExceptions = #chExceptions
    majorSevenSymbol = \markup { maj7 }
  }
}

#(define (music-elts x)
   (if (not (ly:music? x))
       '()
       (ly:music-property x 'elements)))

#(define (music-name x)
   (if (not (ly:music? x))
       #f
       (ly:music-property x 'name)))

#(define (all-pitches-from-music music)
   (reverse!
    (let loop ((music music) (pitches '()))
      (let ((p  (ly:music-property music 'pitch)))
        (if (ly:pitch? p)
            (cons p pitches)
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

%% convert pitchlist to plain music
#(define (pitches->music plist)
   (if (list? plist)
       (make-music 'SequentialMusic 'elements
         (map (lambda (p)
                (make-music
                 'NoteEvent 'duration (ly:make-duration 0)
                 'pitch p))
           plist))
       (make-music 'SequentialMusic 'elements
         (make-music
          'NoteEvent 'duration (ly:make-duration 0)
          'pitch plist))))

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

%% create all n-th chords from scale
%% actually we staple every other pitch from the-scale
%% until we reach n
#(define (create-chords-from-scale the-scale n)
   (let* ((scpi (all-pitches-from-music the-scale))
          (pili (sort
                 (delete-duplicates scpi) ly:pitch<?))
          (m (length pili)))
     ;(write-me "m --------------> "  m)
     ;(write-me "pili -----------> "  pili)
     (map
      (lambda(z)
        (map
         (lambda (x)
           (let* ((y (modulo (+ z (* x 2)) m))
                  (q (quotient (+ z (* x 2)) m))
                  (z (list-ref pili y))
                  (a (ly:pitch-alteration z))
                  (o (ly:pitch-octave z))
                  (n (ly:pitch-notename z))
                  (p (ly:make-pitch (+ o q) n a)))
             ;(write-me "x --------> " x)
             ;(write-me "y --------> " y)
             ;(write-me "q --------> " q)
             ;(write-me "p --------> " p)
             p))
         (iota n)))
      (iota m))))
Dur={ c d e f g a h }
%% create pseudochords from scale
%% input: scale
%% list: the distances of the notes

#(define (arbitrary-stacked-intervals the-scale dlist)
   (let* ((scpi (all-pitches-from-music the-scale))
          (pili (sort
                 (delete-duplicates scpi) ly:pitch<?))
          (m (length pili))
          (elist (append dlist '(1)))
          (n (length elist))
          )
     ;(write-me "m --------------> "  m)
     ;(write-me "pili -----------> "  pili)
     (map
      (lambda (z)
        (let ((u 0))
          (map
           (lambda (x)
             (let* ((v u)
                    (y (modulo (+ z v) m))
                    (q (quotient (+ z v) m))
                    (z (list-ref pili y))
                    (a (ly:pitch-alteration z))
                    (o (ly:pitch-octave z))
                    (n (ly:pitch-notename z))
                    (p (ly:make-pitch (+ o q) n a)))
                ;(write-me "x --------> " elist)
               ; (write-me "u --------> " u)
               ; (write-me "v --------> " v)
               ; (write-me "y --------> " y)
               ; (write-me "q --------> " q)
               ; (write-me "p --------> " p)
               (set! u (+ u (list-ref elist x)))
               p))
           (iota n))))
      (iota m))))

%#(display (in-list-from-scale Dur '(1 2 3)))

CreateDiatonicChords=
#(define-music-function (the-scale n scale-text)(ly:music? index? string?)
   (let* ((mymusic
           (make-sequential-music
            (map (lambda(x) (pitches->chord x))
              (create-chords-from-scale the-scale n))))
          (new-scale (pitches->music
                      (sort
                       (delete-duplicates
                        (all-pitches-from-music the-scale)) ly:pitch<?))))
     #{
       \new StaffGroup <<
         \new Staff {
           \mark \markup {  $scale-text }
           $new-scale
         }
         \new Staff $mymusic
         \new ChordNames $mymusic
       >>
     #}
     ))

CreateArbitraryChords=
#(define-music-function (the-scale ilist scale-text)(ly:music? list? string?)
   (let* ((mymusic
           (make-sequential-music
            (map (lambda(x) (pitches->chord x))
              (arbitrary-stacked-intervals the-scale ilist))))
          (new-scale (pitches->music
                      (sort
                       (delete-duplicates
                        (all-pitches-from-music the-scale)) ly:pitch<?))))
     #{
       \new StaffGroup <<
         \new Staff {
           \mark \markup {  $scale-text }
           $new-scale
         }
         \new Staff $mymusic
         \new ChordNames $mymusic
       >>
     #}
     ))

SpanishGipsy=\relative c' { c cis e f g gis ais }
\CreateArbitraryChords \relative c' \Dur #'(2 3) "Quart Sext Accords of D-major"

\markup { \null \vspace #3 }
EightToneSpanish=\relative c' { c cis dis e f fis gis ais }
\CreateDiatonicChords \SpanishGipsy #3 "Diatonic Triads of Spanish Gipsy Scale"

\markup { \null \vspace #3 }
\CreateDiatonicChords \relative c' { c d es f g as h } #5 "Diatonic Pentachords of C-minor"
