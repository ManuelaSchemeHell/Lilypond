AAA = { d''8 c'' b' g' a' b' c''4  }
\language "deutsch"
%myChords = \chordmode { d4.:m g:7 c4 }
bassnotes =\chordmode  { c4. d2. e8 <c> <d> <e> <fis gis> }
chordnotes = \chordmode { 
\set chordNameLowercaseMinor = ##t

d4:m g8:m7 c2:dim <c es g heses>4 c:m9 }

#(define (noteEvent? music)
(eq? (ly:music-property music 'name) 'NoteEvent))

#(define (no-duration? music)
(not (ly:duration? (ly:music-property music 'duration))))

#(define (expand-q-chords music); for q chords : see chord-repetition-init.ly
(expand-repeat-chords! (list 'rhythmic-event) music))

%%%%%%%%%%%%%%%%%%%%%%%%%%  extractNote  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#(define tagNotExtractNote (gensym))
#(use-modules (ice-9 receive)) %% for the use of receive

#(define (chord->note chord n . args)
"Return either the note n of chord chord, keeping articulations or if other
numbers are specified in args, a chord with the matching notes."
(receive (notes others)
 (partition noteEvent? (ly:music-property chord 'elements))
 (if (null? notes)
   chord
   (let* ((len (length notes))
          (res (filter-map
            (lambda(i)
              (and (integer? i)
                   (<= i len)
                   (> i 0)
                   (list-ref notes (1- i)))) ; list-ref is zero-based
            (cons n args)))
           (one-note (cond 
             ((null? res) (list-ref notes (1- len)))
             ((null? (cdr res))(car res))
             (else #f))))
      (if one-note
        (begin
          (ly:music-set-property! one-note 'articulations 
            (append (ly:music-property one-note 'articulations) others))
          one-note)
        (make-event-chord (append res others)))))))
         
#(define (extract-note music n . args)
"Extract the note n of each chords in music, keeping articulations.
If other numbers are given in args, the function returns a chord build with all
matching notes. If no note matches, returns the last note of the chord."
 (map-some-music 
   (lambda (evt)
      (cond 
        ((eq? 'EventChord (ly:music-property evt 'name))
           (let ((tags (ly:music-property evt 'tags)))
              (if (memq tagNotExtractNote tags)
                 (ly:music-set-property! evt 'tags ; only remove the tag
                     (delq tagNotExtractNote tags))
                 (set! evt (apply chord->note evt n args)))
              evt))
        (else (and (ly:music-property evt 'duration #f) evt))))
   (expand-q-chords music)))

extractNote = #(define-music-function (parser location n music )
                                                            (number? ly:music?)
 (extract-note music n))
chExceptionMusic = {
  <c es g heses>1-\markup { "m" }
  <c es g b d'>1-\markup { "m" }
  <c>1-\markup { \null \hspace #-2 \fontsize #2 "_" }
  <c d>1-\markup { \null \hspace #-3 \fontsize #1.2 "__" }
}
chExceptions = #( append
  ( sequential-music-to-chord-exceptions chExceptionMusic #t)
  ignatzekExceptions)  
summe= { 
\partcombine 
\extractNote #1 \bassnotes \extractNote #1 \chordnotes }

\score {
  <<
  \new Staff  \chordmode { c2:m9 <c' es' g' b' d''> }
  \new ChordNames \bassnotes
  \new ChordNames \chordnotes
%\new Staff \new Voice \summe

 \new RhythmicStaff 
 \with { printPartCombineTexts = ##f } 
 { 
\override NoteHead.font-size = #-2
\override NoteHead.style = #'slash


\mergeDifferentlyHeadedOn
\mergeDifferentlyDottedOn
\summe 
%\AAA
}
    
  >>
  \layout {
    \context {
      \RhythmicStaff
      \remove "Time_signature_engraver"
      \remove "Clef_engraver"
      %\override BarLine.transparent = ##t
      %\override StaffSymbol.line-count = #0
    }
	\context {
\ChordNames
chordNameExceptions = #chExceptions 
chordChanges = ##f
  }
  \context {
\Staff
printPartCombineTexts = ##f
}
\context {
\Voice
\override Rest.staff-position = #0
}

  }
  
}
