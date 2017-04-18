%% http://lists.gnu.org/archive/html/lilypond-user/2012-02/msg00105.html
%% http://lilypond.1069038.n5.nabble.com/polychords-a-working-solution-td20169.html


#(define-markup-command (transposed-chord-root-name layout props a b) (number? number?)
  #:properties ((cause #f))
  "Print the root of the chord transposed."
  (interpret-markup layout props
    (markup (note-name->markup
             (ly:pitch-transpose (ly:event-property cause 'pitch) (ly:make-pitch 0 a b))
                                #f))))

#(define-markup-command (chord-root-name layout props) ()
  #:properties ((cause #f))
  "Print the root of the chord transposed."
  (interpret-markup layout props
    (markup (note-name->markup (ly:event-property cause 'pitch) #f)
    )))

#(define-public (silent-chord-root-namer pitch lowercase?)
   (markup "")
)

#(define-markup-command (polychord-column layout props args)
 (markup-list?)
  ;#:properties ((direction)
  ;(baseline-skip))
	
 (let* ((args-length-ls (sort (map (lambda (x)
       		(interval-length
       		   (ly:stencil-extent
       		      (interpret-markup layout props x)
       		    X)))
       		args)
       	          >))
       ; baseline-skip is hard-coded!
       ; if you change this don't forget to change 0.65
       ; in: #:translate (cons 0 (* 0.65 baseline-skip))
       (baseline-skip 1.4)
       (ln-mrkp (markup #:translate (cons 0 (* 0.65 baseline-skip))
       	         #:draw-line (cons (car args-length-ls) 0)))
       (new-args (list (car args) ln-mrkp (cadr args))))
       ; direction is hard-coded!
 (stack-lines 1 ;(if (number? direction) direction -1)
              0.0
              baseline-skip
              (interpret-markup-list layout props new-args))))

polychordExceptionMusic = {
  <c e g des' f' aes'>1-\markup { \polychord-column
                       { \chord-root-name \transposed-chord-root-name #1 #-1/2 } }
  <c e g d' fis' a'>1-\markup { \polychord-column
                       { \chord-root-name \transposed-chord-root-name #1 #0 } }
}

%#(top-repl)

polychordExceptions = #( append
  ( sequential-music-to-chord-exceptions polychordExceptionMusic #t)
 ignatzekExceptions)

cmJazz = {
  \set chordNameExceptions = #ignatzekExceptions
  \set chordRootNamer = #note-name->markup
}

cmPoly = {
  \set chordNameExceptions = #polychordExceptions
  \set chordRootNamer = #silent-chord-root-namer
}

theMusic = \chordmode {
    \cmPoly
       c1:5.9-.11.13-
       c1:5.9.11+.13
       des1:5.9.11+.13
       fis1:5.9.11+.13
       \cmJazz
       c1:5.9-.11.13-
}

\layout {
  ragged-right = ##t
}

<< \context ChordNames \theMusic
   \context Voice \theMusic
>>
