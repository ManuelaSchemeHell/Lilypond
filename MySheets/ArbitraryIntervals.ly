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

%% create all n-th chords from scale
%% actually we staple every other pitch from the-scale
%% until we reach n

Dur={ c d e f g a h }

%% create chords with arbitraty intervals from the scale
%% input: scale
%% list: the distances of the notes, 3=terz, 4=quart ...

#(define (stacked-intervals the-scale list-or-number-or-pair)
   ;; the-scale: music from which the pitchlist is constructed
   ;; usually a scale, but could be any music
   ;; duplicate pitches are removed and sorting according to pitch height is done
   ;; list-or-number-or-pair: tells the programm which intervals to produce
   ;; list: a list of chords, 3=third, 4=forth etc. '(2 4) creates a quart-sext chord
   ;; pair: '(a . b)  a: how many notes the chord contains, b: the interval, 3=third, 4=forth
   ;; number: terzes are stapled, 3=triad, 4=tetrads, 5=pentachord etc
   ;; actually the program does not much counting
   ;; a list of intervals is created by picking notes in the order they appear
   ;; in the scale leaving gaps defined by the list
   (let* ((scpi (music-pitches the-scale))
          (pili (sort
                 (delete-duplicates scpi) ly:pitch<?))
          (m (length pili))
          (elist (cond
                  ((list? list-or-number-or-pair)
                   ;; we need to add an element to the list
                   ;; otherwise the last element of the list would not appear
                   ;; in the result
                   (append list-or-number-or-pair '(1)))
                  ((pair? list-or-number-or-pair)
                   ;; car: number of notes
                   ;; cdr: distance, 3=third, 4=forth etc.
                   (make-list  (car list-or-number-or-pair) (cdr list-or-number-or-pair)))
                  ((number? list-or-number-or-pair)
                   ;; standard definition: chord consists of thirds
                   (make-list list-or-number-or-pair 3))))
          (n (length elist)))
     (map
      (lambda (w)
        (let ((u 0))
          (map
           (lambda (x)
             (let* ((y (modulo (+ u w) m))
                    (q (quotient (+ u w) m))
                    (z (list-ref pili y))
                    (a (ly:pitch-alteration z))
                    (o (ly:pitch-octave z))
                    (n (ly:pitch-notename z))
                    (p (ly:make-pitch (+ o q) n a)))
               (set! u (+ u (list-ref elist x) -1))
               p))
           (iota n))))
      (iota m))))

CreateArbitraryIntervals=
#(define-music-function (the-scale pair-list-number scale-text)(ly:music? scheme? string?)
   (let* ((mymusic
           (make-sequential-music
            (map (lambda(x) (pitches->chord x))
              (stacked-intervals the-scale pair-list-number))))
          (new-scale (pitches->music
                      (sort
                       (delete-duplicates
                        (music-pitches the-scale)) ly:pitch<?))))
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

CreateIntervals=
#(define-music-function (the-scale pair-list-number)(ly:music? scheme?)
   ;; creates the pure music without chordnames and other staff
   (make-sequential-music
    (map (lambda(x) (pitches->chord x))
      (stacked-intervals the-scale pair-list-number))))

SpanishGipsy=\relative c' { c cis e f g gis ais }
\CreateArbitraryIntervals \relative c' \Dur #5 "Diatonic Pentachords in C-major"
%\CreateArbitraryIntervals \relative c' \Dur #4 "Vierklänge C-major"
\markup { \null \vspace #3 }
EightToneSpanish=\relative c' { c1 cis dis e f fis gis ais }
\CreateArbitraryIntervals \SpanishGipsy #'(3 . 4) "Staple three notes with a gap of two tones in Spanish Gipsy Scale"

\markup { \null \vspace #3 }
{
  \new Staff \key es \major
  \mark \markup "stack four fifths in C-minor"
  \CreateIntervals \relative c' { c d es f g as h } #'(5 . 5)
}
