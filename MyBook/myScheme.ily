\version "2.19.32"

mpdolce =
#(make-dynamic-script
  #{ \markup {
    \hspace #0
    \translate #'(5 . 0)
    \line {
      \dynamic "mp"
      \text \italic "dolce"
    }
     }
  #})

pdolce =
#(make-dynamic-script
  #{ \markup {
    \hspace #0
    \translate #'(5 . 0)
    \line {
      \dynamic "p"
      \text \italic "dolce"
    }
     }
  #})

FSus = #(make-span-event 'SustainEvent STOP)
NSus = #(make-span-event 'SustainEvent START)

%% http://lsr.dsi.unimi.it/LSR/Item?id=654
%% http://lsr.di.unimi.it//LSR/Item?id=654
%% see also http://lilypond.org/doc/v2.18/Documentation/notation/short-repeats

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LSR workaround:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% version 2013/05/11
%% for lilypond 2.18 or higher
%% last changes : - \changePitch : a single s as the last event of newnotes parameter
%%                   will give you the ending rests of the pattern (if there), and two s
%%                   also the beginning ones. If pattern ends with a note, a single
%%                   ending s will have no effects.
%%                - Is now \language independant (no more #{ c #})
%%                - new algorithm for make-notes-list, change-pitch
%%                  and has-notes? (shorter and safer)
%%
%%%%%%%%%%%%%%%%%%%%%%%%% some utility functions %%%%%%%%%%%%%%%%%%%%%

#(define (name-of music)
   (ly:music-property music 'name))

#(define (has-notes? music)
   "Return true if there is at least one note in `music, false otherwise."
   (or (eq? (name-of music) 'NoteEvent)
       (let ((e (ly:music-property music 'element)))
         (and (ly:music? e)
              (has-notes? e)))
       (let loop ((es (ly:music-property music 'elements)))
         (and (pair? es)
              (or (has-notes? (car es))
                  (loop (cdr es)))))))

%% An EventChord is sometimes used as a wrapper in Lilypond, so we have to check
%% if a chord is a standard chord with notes. We could have used has-notes? but
%% this version is perhaps more efficient.
%% Optional events name like 'RestEvent can be included.
#(define (note-or-chord? music . otherEvent)
   "Is music a note or a chord with notes ?"
   (let ((name (name-of music)))
     (or (memq name (cons 'NoteEvent otherEvent))
         (and (eq? name 'EventChord)  ; have this chord at least one note ?
              (let loop ((es (ly:music-property music 'elements)))
                (and (pair? es)
                     (or (eq? (name-of (car es)) 'NoteEvent)
                         (loop (cdr es)))))))))

#(define (expand-q-chords music); for q chords : see chord-repetition-init.ly
   (expand-repeat-chords! (list 'rhythmic-event) music))

#(define (clean-music mus)
   "Try to reduce the number of sequential music"
   (let ((name (ly:music-property mus 'name)))
     (cond
      ((eq? name 'SequentialMusic)
       (ly:music-set-property! mus 'elements (fold-right
                                              (lambda (evt prev-list)
                                                (if (eq? (name-of evt) 'SequentialMusic)
                                                    (append (ly:music-property (clean-music evt) 'elements) prev-list)
                                                    (cons (clean-music evt) prev-list)))
                                              '()
                                              (ly:music-property mus 'elements))))
      ((eq? name 'SimultaneousMusic)
       (ly:music-set-property! mus 'elements
         (map clean-music (ly:music-property mus 'elements))))
      ((memq name (list 'RelativeOctaveMusic 'UnrelativableMusic))
       (ly:music-set-property! mus 'element (clean-music
                                             (ly:music-property mus 'element)))))
     mus))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% changePitch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#(define cPInsertInPattern (gensym))
#(define cPSamePitch (gensym))
#(define cPSamePitchEnd (gensym))
#(define cPPatternEnd (gensym))

#(define (make-notes-list music)
   "Make a list with each element will be of one of these types :
  1- a note, a chord, a rest
  2- an integer, indicating the number of notes to skip in pattern ( The user will
     indicate that, by a corresponding number of skips (s or \\skip) in `newnotes 
     parameter of \\changePitch )
  3- a list of musics, to be inserted between 2 notes of pattern, and added with
     the \\insert function, inside `newnotes"
   (let ((res '())     ; the list to fill
          (prev #f))
     (define (fill-notes-list evt)
       (let ((tags (ly:music-property evt 'tags))
             (name (name-of evt)))
         (cond
          ((memq cPInsertInPattern tags)             ; a music added by \insert
            (ly:music-set-property! evt 'tags
              (delq cPInsertInPattern tags))     ; remove the tag
            (if (integer? prev)(set! res (cons prev res)))
            (set! prev (if (pair? prev)(cons evt prev)(list evt))))  ; a list
          ((memq name (list 'SkipEvent 'SkipMusic))
           (if (pair? prev)(set! res (cons prev res))) ; keep the reverse order
           (set! prev (if (integer? prev) (1+ prev) 1)))
          ; ((memq name (list 'EventChord 'NoteEvent 'RestEvent))
          ((note-or-chord? evt 'RestEvent) ; a note, a chord, or a rest
            (if (or (pair? prev)(integer? prev))(set! res (cons prev res)))
            (set! prev evt)
            (set! res (cons evt res)))
          (else
           (let ((elt (ly:music-property evt 'element))
                 (elts (ly:music-property evt 'elements)))
             (if (ly:music? elt) (fill-notes-list elt))
             (if (pair? elts)(for-each fill-notes-list elts)))))))
     (fill-notes-list music)
     (if (or (pair? prev)(integer? prev))(set! res (cons prev res)))
     (reverse res)))

%%%%%%%%%%%%  used inside the inner function change-one-note
#(define (copy-duration from to)  ; from and to as EventChord or NoteEvent
   (let ((max-dur #f)); in theory, 2 notes in a chord can have a different duration
     (music-map (lambda (x)            ; get main duration from `from
                  (let ((dur (ly:music-property x 'duration)))
                    (if (and (ly:duration? dur)
                             (or (not max-dur)
                                 (ly:duration<? max-dur dur))); take the greater
                        (set! max-dur dur))
                    x))
       from)
     (music-map (lambda (x)            ; set duration to duration of `to
                  (if (ly:duration? (ly:music-property x 'duration))
                      (ly:music-set-property! x 'duration max-dur))
                  x)
       to)))

#(define (copy-arti from to) ; from and to as EventChord or NoteEvent
   (let* ((es-from (ly:music-property from 'elements))
          (es-to (ly:music-property to 'elements))
          (arti-from (if (null? es-from)
                         (ly:music-property from 'articulations)
                         (filter
                          (lambda(x)
                            (not (ly:duration? (ly:music-property x 'duration))))
                          es-from))))
     (if (null? es-to)                       ; NoteEvent
         (ly:music-set-property! to 'articulations
           (append (ly:music-property to 'articulations) arti-from))
         (ly:music-set-property! to 'elements  ; EventChord
           (append es-to arti-from)))
     ; copy also 'tags and 'to-relative-callback
     (ly:music-set-property! to 'tags
       (append (ly:music-property from 'tags)(ly:music-property to 'tags)))
     (if (null? es-to)
         (ly:music-set-property! to 'to-relative-callback
           (ly:music-property from 'to-relative-callback))
         (begin
          (ly:music-set-property! to 'to-relative-callback
            ly:music-sequence::event-chord-relative-callback)
          (ly:music-set-property! (car es-to) 'to-relative-callback
            (ly:music-property from 'to-relative-callback))))
     ))

%% del-arti is called for all notes but the first of a \samePitch section.
#(define (del-arti note-or-chord)
   (ly:music-set-property! note-or-chord 'articulations '())
   (ly:music-set-property! note-or-chord 'elements
     (filter (lambda(x)
               (and (ly:duration? (ly:music-property x 'duration))
                    (ly:music-set-property! x 'articulations '())))
             (ly:music-property note-or-chord 'elements))) ; can be empty
   (music-map  ;; del all caution accidentals
     (lambda(x)(if (eq? (name-of x) 'NoteEvent) (begin
                                                 (ly:music-set-property! x 'force-accidental #f)
                                                 (ly:music-set-property! x 'cautionary #f)))
       x)
     note-or-chord))

#(define (change-pitch pattern newnotes)
   "The scheme function of \\changePitch, `pattern and `newnotes as music."
   (let ((seq-list '())           ; list of transformed patterns
          (skip-notnote-event? #f) ; #t if a \skip or an \insert is found in newnotes
          (same-pitch-section? #f) ; #t if we are in the 2nd pattern note of a\samePitch section
          ;(dummy-note #{ c4 #})    ; \language dependant -:(
          (dummy-note (make-music 'NoteEvent ; to avoid pbs with pattern without any notes
                        'duration (ly:make-duration 2 0 1) ;
                        'pitch (ly:make-pitch -1 0 0))) ;
          (pattern2 #{ $pattern \tag #cPPatternEnd s4 #}) ; to detect the end of pattern
          (last-notes-list #f))    ; buffer
     (set! seq-list (cdr  ; skip dummy notes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; loop ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                      (let loop ((notes-list (cons dummy-note (make-notes-list newnotes))); see make-notes-list
                                  (pat-list (cons dummy-note (circular-list pattern2)))
                                  (res '())) ; the list to fill
                        (if (or (null? notes-list)(null? pat-list)) ; pat-list may be a regular list in the loop
                            (reverse res)               ;;;;;; return the list in the right order
                            (let ((x (car notes-list))  ;;;;;; go deeper, taking 1st elt of each lists
                                   (evt (ly:music-deep-copy (car pat-list))))
                              (cond
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                               ((pair? x)                   ; x is a list of musics, added with \insert in newnotes
                                 (set! skip-notnote-event? #t)      ; for events between 2 pattern notes
                                 (set! last-notes-list notes-list)  ; for section "else" of this cond statement
                                 (loop (cdr notes-list) pat-list (append x res))) ; append x to res
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                               ((note-or-chord? evt)         ; evt in pattern is a note or a chord (with notes)
                                 (set! last-notes-list notes-list)  ; for section "else" later
                                 (cond
                                  ((ly:music? x)  ;;;;;; the elt of notes-list is a note or a chord
                                    (if same-pitch-section? ; x is used several times. Copy arti of x only to the
                                        (set! x (del-arti (ly:music-deep-copy x)))) ; 1st note of \samePitch section
                                    (copy-duration evt x)  ; evt = from, x = to
                                    (copy-arti evt x)
                                    (let ((tags (ly:music-property x 'tags)))
                                      (cond               ; are we in a \samePitch section ?
                                        ((memq cPSamePitch tags)    ; yes, first,remove the tag
                                          (ly:music-set-property! x 'tags (delq cPSamePitch tags))
                                          (set! same-pitch-section? #t)) ; then set the flag
                                        ((memq cPSamePitchEnd tags) ; last note of \samePitch
                                          (ly:music-set-property! x 'tags (delq cPSamePitchEnd tags))
                                          (set! same-pitch-section? #f))))      ; unset the flag
                                    (set! skip-notnote-event? #f); stop deletion of not-notes event.
                                    (if same-pitch-section?
                                        (loop notes-list (cdr pat-list)(cons x res))
                                        (loop (cdr notes-list)(cdr pat-list)(cons x res)))) ; next new note
                                  ((integer? x)   ;;;;;; user want to skip over the current evt note. We also
                                    (set! skip-notnote-event? x) ; don't add any events bis next pattern note
                                    ;; (format #t "x : ~a\n" x)  ; for testing
                                    (cond ((= x 1)                                      ; only one s
                                            (loop (cdr notes-list)(cdr pat-list) res)) ; next notes-list elt
                                      (else                                         ; several successive s
                                        (set-car! notes-list (1- x))               ; for the next loop
                                        (loop notes-list (cdr pat-list) res))))))  ; the next evt only
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                               ((or (ly:music-property evt 'duration #f)  ; current evt in pattern is not a note
                                    (not (has-notes? evt)))
                                (cond ((memq cPPatternEnd (ly:music-property evt 'tags)) ; last evt of pattern
                                        (let ((x (car notes-list)))
                                          (if (and (integer? x)
                                                   (or (null? (cdr notes-list))        ; last elt ?
                                                       (and (null? (cddr notes-list))  ; 2nd to last and last is
                                                            (pair? (car (cdr notes-list)))))) ; a \insert section
                                              (cond
                                               ((= x 1)
                                                (set! skip-notnote-event? x)
                                                (loop (cdr notes-list) (cdr pat-list) res))
                                               (else
                                                (set-car! notes-list (1- x))
                                                (loop notes-list (cdr pat-list) res))))
                                          (loop notes-list (cdr pat-list) res))) ;; ignores evt
                                  (skip-notnote-event? (loop notes-list (cdr pat-list) res))
                                  (else (loop notes-list (cdr pat-list)(cons evt res)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                               (else
                                (let ((e (ly:music-property evt 'element))
                                      (es (ly:music-property evt 'elements))
                                      (empty? #f)) ; don't add to res if #t
                                  (if (ly:music? e)
                                      (let ((new-e (loop notes-list (list e) '())))
                                        (ly:music-set-property! evt 'element
                                          (case (length new-e)
                                            ((0) (set! empty? #t)
                                              new-e)
                                            ((1)(car new-e))
                                            (else (make-sequential-music new-e))))))
                                  (if (pair? es)
                                      (let ((new-es (loop notes-list es '())))
                                        (ly:music-set-property! evt 'elements new-es)
                                        (set! empty? (and empty? (null! new-es))))) ; #t if both empty

                                  (let ((next-new-notes (if (or same-pitch-section?
                                                                (and (integer? skip-notnote-event?)
                                                                     (> skip-notnote-event? 1)))
                                                            last-notes-list
                                                            (cdr last-notes-list))))
                                    (if empty? (loop next-new-notes (cdr pat-list) res)
                                        (loop next-new-notes (cdr pat-list) (cons evt res))))))))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end loop ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     (let ((relativize (lambda(m)
                         (let* ((clean-newnotes (clean-music newnotes))
                                (name (name-of clean-newnotes)))
                           (if (memq name (list 'RelativeOctaveMusic 'UnrelativableMusic))
                               (make-music name 'element m)
                               m)))))
       (case (length seq-list)
         ((0) (make-music 'Music 'void #t))
         ((1) (relativize (car seq-list)))
         (else (relativize (clean-music (make-sequential-music seq-list))))))))

changePitch = #(define-music-function (pattern newnotes)
                 (ly:music? ly:music?)
                 "Change each notes in `pattern by the notes (or rests) given in `newnotes.
If count of events doesn't match, pattern is duplicated repeatedly or truncate."
                 (let* ((expand-q (lambda (music) (expand-repeat-chords!
                                                   (cons 'rhythmic-event (ly:parser-lookup '$chord-repeat-events))
                                                   music)))
                        (pattern (expand-q pattern))
                        (newnotes (expand-q newnotes)))
                   (change-pitch pattern newnotes)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% enhancement functions, working with \changePitch pattern newnotes

samePitch = #(define-music-function (music) (ly:music?)
               "Inside the `pattern parameter of the \\changePitch function, all notes grouped 
by this function will have the same pitch, according to the current note of
`newnotes parameter of \\changePitch."
               (let((not-first? #f)
                    (last-note #f))
                 (map-some-music
                  (lambda (x)
                    (cond
                     ((note-or-chord? x)
                      (if not-first?     ; set all pitches to the pitch of the first note
                          (ly:music-set-property! x 'to-relative-callback
                            (lambda (x p)                    ; set pitch to the prev value
                              (ly:prob-set-property! x 'pitch p)
                              p))
                          (set! not-first? x)) ; do nothing for first note
                      (ly:music-set-property! x 'tags (cons
                                                       cPSamePitch  ; add tag cPSamePitch to x
                                                       (ly:music-property x 'tags)))
                      (set! last-note x)   ; save the note x
                      x)
                     (else #f)))
                  music)
                 (if last-note              ; the last saved EventChord
                     (ly:music-set-property! last-note 'tags (cons
                                                              cPSamePitchEnd    ; add cPSamePitchEnd tag, delete cPSamePitch tag
                                                              (delq cPSamePitch (ly:music-property last-note 'tags)))))
                 music))

%% this function should be no more needed, as copy-arti should avoid pbs
%% in relative mode and \samePitch
absolute = #(define-music-function (music) (ly:music?)
              "Make `music unrelativable. To use inside a \\samePitch function in relative
mode."
              (make-music 'UnrelativableMusic 'element music))

insert = #(define-music-function (music) (ly:music?)
            "Using this function inside the `newnotes parameter of the \\changePitch
function, allow you to insert and remplace by `music, all music between one note
and his following, in the `pattern parameter of \\changePitch, ."
            #{ \tag #cPInsertInPattern $music #})

%%%%%%%
#(define (n-copy n music)
   (cond
    ((> n 1)(make-sequential-music
             (map (lambda (x)(ly:music-deep-copy music))
               (make-list n))))
    ((= n 1) music)
    (else (make-music 'Music 'void #t))))

nCopy = #(define-music-function (n music)(integer? ly:music?)
           (n-copy n music))

%% same effect as { \repeat unfold n s } but \nSkip works inside the `newnotes
%% parameter of \changePitch.
nSkip = #(define-music-function (n)(integer?)
           "Return \\skip \\skip \\skip ... n times."
           #{ \nCopy #n s #})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% shortcuts
% default values for patI and patII, if the user do not define
% them, before using \cPI and \cPII
% patI ={ c8. c16 }      % not \language independant
patI = #(make-music 'SequentialMusic 'elements (list
                                                (make-music 'NoteEvent 'duration (ly:make-duration 3 1 1)
                                                  'pitch (ly:make-pitch -1 0 0))
                                                (make-music 'NoteEvent 'duration (ly:make-duration 4 0 1)
                                                  'pitch (ly:make-pitch -1 0 0))))
% patII = { c4. c8 }
patII = #(make-music 'SequentialMusic 'elements (list
                                                 (make-music 'NoteEvent 'duration (ly:make-duration 2 1 1)
                                                   'pitch (ly:make-pitch -1 0 0))
                                                 (make-music 'NoteEvent 'duration (ly:make-duration 3 0 1)
                                                   'pitch (ly:make-pitch -1 0 0))))


cPI = #(define-music-function (newnotes) (ly:music?)
         #{ \changePitch \patI $newnotes #})

cPII = #(define-music-function (newnotes) (ly:music?)
          #{ \changePitch \patII $newnotes #})

#(define cP changePitch)
%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The example %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

testMusic = { c d e f g f e d <c e> <d f> <e g> <d f> }
fillerChord = { <c e>2 }

\relative c' {
  \override  Score.RehearsalMark.self-alignment-X = #LEFT

  \mark "pattern = { c8.-> c16-. }"

  \changePitch { c8.-> c16-. } {
    \testMusic
  }
  \fillerChord
  \break

  \mark "pattern = { c8 c16( c) }"

  \changePitch { c8 c16( c) } {
    \testMusic
  }
  \fillerChord
  \fillerChord
  \break

  \time 6/8
  \mark "pattern = { c4( c8) c8.( c16) c8-. }"
  \changePitch { c4( c8) c8.( c16) c8-. } {
    \testMusic
  }
  <c e>4.
}
<%}

%% see http://lsr.di.unimi.it/LSR/Item?id=861
%% see also http://lilypond.org/doc/v2.18/Documentation/internals/notehead

% Offsets are entered as a series of numbers.
%   The value of 0 causes no offset-calculation to occur and places the note at the default side of the stem:
%     The left side for a stem pointing up and
%     the right side for a stem pointing down.
%     (Per default, additional NoteHeads may have been placed on the opposite side of the stem to avoid collisions.)
%   Use 1 to shift a note head to the right.
%   Use -1 to shift a note head to the left.
%
% The amount of the offset is automatically determined based on
%   the width of the notehead and the width of the stem.
%   (When there is a stem, a note head is offset by the width of the notehead
%   minus half the width of the stem.  This will correctly align the note head
%   with any others above or below it on the same side of the stem.)
%
% You can use larger or smaller values (like 1.1 or -0.9)
%   to adjust the amount of the offset.
%
% In some cases offsetting a note head will cause the stem to no longer
%   attach to it properly.  (The main (or only?) case where this is needed
%   is when a note head that is at the end of a stem has been offset to the
%   non-default side of the stem.)  To fix this, you can override the 'stem-attachment
%   property.  The adjustStem function below makes this easier.  It takes a pair of
%   numbers.  The first number adjusts the stem attachment on the X-axis (left or right)
%   and the second number adjusts it on the Y-axis (up or down).  The first number
%   indicates a multiple of the width of the stem that is added to the stem attachment
%   position on the X-axis.  The second number is multiplied by the default position
%   on the Y-axis to arrive at the new position on the Y-axis.  See examples below.
%
% In a case where the parent note head of a Script is offset, the
%   setOtherScriptParent function below can be used to select a different
%   parent note head, in order to keep the Script in its original position.  See
%   example below.

#(define ((shift offsets) grob)
   "Defines how NoteHeads should be moved according to the given list of offsets."
   (let* (
           ;; NoteHeads
           ;; Get the NoteHeads of the NoteColumn
           (note-heads (ly:grob-array->list (ly:grob-object grob 'note-heads)))
           ;; Get their durations
           (nh-duration-log
            (map
             (lambda (note-head-grobs)
               (ly:grob-property note-head-grobs 'duration-log))
             note-heads))
           ;; Get the stencils of the NoteHeads
           (nh-stencils
            (map
             (lambda (note-head-grobs)
               (ly:grob-property note-head-grobs 'stencil))
             note-heads))
           ;; Get their length in X-axis-direction
           (stencils-x-lengths
            (map
             (lambda (x)
               (let* ((stencil (ly:grob-property x 'stencil))
                      (stencil-X-exts (ly:stencil-extent stencil X))
                      (stencil-lengths (interval-length stencil-X-exts)))
                 stencil-lengths))
             note-heads))
           ;; Stem
           (stem (ly:grob-object grob 'stem))
           (stem-thick (ly:grob-property stem 'thickness 1.3))
           (stem-stil (ly:grob-property stem 'stencil))
           (stem-x-width (if (ly:stencil? stem-stil)
                             (interval-length (ly:stencil-extent stem-stil X))
                             ;; if no stem-stencil use 'thickness-property
                             (/ stem-thick 10)))
           (stem-dir (ly:grob-property stem 'direction))
           ;; Calculate a value to compensate the stem-extension
           (stem-x-corr
            (map
             (lambda (q)
               ;; TODO better coding if (<= log 0)
               (cond ((and (= q 0) (= stem-dir 1))
                      (* -1 (+ 2  (* -4 stem-x-width))))
                 ((and (< q 0) (= stem-dir 1))
                  (* -1 (+ 2  (* -1 stem-x-width))))
                 ((< q 0)
                  (* 2 stem-x-width))
                 (else (/ stem-x-width 2))))
             nh-duration-log)))
     ;; Final Calculation for moving the NoteHeads
     (for-each
      (lambda (nh nh-x-length off x-corr)
        (if (= off 0)
            #f
            (ly:grob-translate-axis! nh (* off (- nh-x-length x-corr)) X)))
      note-heads stencils-x-lengths offsets stem-x-corr)))

displaceHeads =
#(define-music-function (parser location offsets) (list?)
   "
 Moves the NoteHeads, using (shift offsets)
"
   #{
     \once \override NoteColumn.before-line-breaking = #(shift offsets)
   #})

adjustStem =
#(define-music-function (parser location val)(pair?)
   "
 Adjust 'stem-attachment via 
 adding multiples of the stem-width to the x-default (car val)
 and multiplying the y-default with (cdr val).
"
   #{
     \once \override NoteHead.before-line-breaking =
     #(lambda (grob)
        (let* ((stem-at (ly:grob-property grob 'stem-attachment))
               (stem (ly:grob-object grob 'stem))
               (stem-x-width (interval-length (ly:grob-property stem 'X-extent))))
          (ly:grob-set-property!
           grob
           'stem-attachment
           (cons (+ (car stem-at) (* stem-x-width (car val))) (* (cdr val) (cdr stem-at)))
           )))
   #})

%% http://lsr.dsi.unimi.it/LSR/Item?id=507

%% LSR This snippet was contributed by Gilles Thibault, on an idea by Eluze.
%% updated by Gilles Thibault on Feb. 2014
%% This function transforms a simple voice (pitches and durations) into a "ghost voice"
%% consisting of spacers and durations only (e.g. c2 d e ==> s2 s s).
%% This is very useful for writing simultaneous voice parts where one contains pitches,
%% another dynamics, a third fingering instructions ...
%% This can easily be used to print a score with or without fingerings or other attributes!
%% The ghost music can be written to the log with \displayLilyMusic \ghostMusic
%% followed by the music to be transformed.

#(define (MM->Script-text evt)
   (if (eq? 'MultiMeasureTextEvent (ly:music-property evt 'name))
       (let ((res (make-music 'TextScriptEvent)))
         ;; (display (ly:music-mutable-properties evt)) ; if you are curious ...
         (for-each (lambda(props)
                     (ly:music-set-property! res (car props) (cdr props)))
           (ly:music-mutable-properties evt))
         res)
       evt))

ghostMusic =
#(define-music-function (parser location music) (ly:music? )
   (map-some-music
    (lambda(x)
      (let
       ((dur (ly:music-property x 'duration #f)))
       (and
        (or dur (eq? 'EventChord (ly:music-property x 'name)))
        (let
         ((skip (make-music 'SkipEvent 'duration
                  (or dur (make-duration-of-length (ly:music-length x)))))
          (artis (let ((elts (ly:music-property x 'elements #f)))
                   (if elts
                       (filter
                        (lambda(y)   ;; EventChord
                          (not (eq? 'NoteEvent (ly:music-property y 'name))))
                        elts)
                       (map MM->Script-text (ly:music-property x 'articulations '()))))))
         (ly:music-set-property! skip 'articulations artis)
         skip))))
    music))

%notes = { a2-"hello" b4 r-"1"  R1^"2" b2 a-"bye" <c e g c' e' g'>1-"oho ;-)" }

%\ghostMusic \notes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A function to modify the shape of slurs by offsetting the positions property
% from default control-point values. Setting either y1 or y2 to zero will leave
% that attachment-point unchanged. Syntax: \offsetPositions #'(y1 . y2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
offsetPositions =
  #(define-music-function (parser location offsets) (pair?)
    #{
       \once \override Slur.positions = #(lambda (grob)
	 `(,(+ (car offsets) (cdar (ly:slur::calc-control-points grob))) .
	   ,(+ (cdr offsets) (cdr (cadddr (ly:slur::calc-control-points grob))))))
    #})
