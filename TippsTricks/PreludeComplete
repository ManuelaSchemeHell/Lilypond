
% http://nicolas.sceaux.free.fr/prelude/prelude.html

\header{
    title = "Preludium"
    opus = "BWV 846"
    composer = "Johann Sebastian Bach (1685-1750)"
}
\paper {
  indent = 5\mm
  betweensystemspace = 12\mm
}
#(set-global-staff-size 13)

#(define-macro (-> . expr)
   (define (gen-music-prop-expr music prop . rest)
     (let ((result-expr (if (number? prop)
                            `(list-ref ,music ,prop)
                            `(ly:music-property ,music ',prop))))
       (if (null? rest)
           result-expr
           (apply gen-music-prop-expr result-expr rest))))
   (apply gen-music-prop-expr expr))

#(define (prelude-pattern five-note-sequence)
  "Build half a prelude measure, from `five-note-sequence', which
should ne a five note SequentialMusic object.
The result is a SimultaneousMusic, containing three SequencialMusic 
objects."
  (let ((pitch1 (-> five-note-sequence elements 0 elements 0 pitch))
        (pitch2 (-> five-note-sequence elements 1 elements 0 pitch))
        (pitch3 (-> five-note-sequence elements 2 elements 0 pitch))
        (pitch4 (-> five-note-sequence elements 3 elements 0 pitch))
        (pitch5 (-> five-note-sequence elements 4 elements 0 pitch)))
    (make-music 'SimultaneousMusic
               'elements (list 
                          (make-music 'SequentialMusic
                            'elements (list 
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'RestEvent
                                                      'duration (ly:make-duration 3 0 1 1))))
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'NoteEvent
                                                      'duration (ly:make-duration 4 0 1 1)
                                                      'pitch pitch3) ;;; <-- pitch3
                                                    (make-music 'BeamEvent
                                                      'span-direction -1)))
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'NoteEvent
                                                      'duration (ly:make-duration 4 0 1 1)
                                                      'pitch pitch4) ;;; <-- pitch4
                                                    (make-music 'BeamEvent
                                                      'span-direction 1)))
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'NoteEvent
                                                      'duration (ly:make-duration 4 0 1 1)
                                                      'pitch pitch5) ;;; <-- pitch5
                                                    (make-music 'BeamEvent
                                                      'span-direction -1)))
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'NoteEvent
                                                      'duration (ly:make-duration 4 0 1 1)
                                                      'pitch pitch3))) ;;; <-- pitch3
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'NoteEvent
                                                      'duration (ly:make-duration 4 0 1 1)
                                                      'pitch pitch4))) ;;; <-- pitch4
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'NoteEvent
                                                      'duration (ly:make-duration 4 0 1 1)
                                                      'pitch pitch5) ;;; <-- pitch5
                                                    (make-music 'BeamEvent
                                                      'span-direction 1)))))
                          (make-music 'SequentialMusic
                            'elements (list 
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'RestEvent
                                                      'duration (ly:make-duration 4 0 1 1))))
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'NoteEvent
                                                      'duration (ly:make-duration 3 1 1 1)
                                                      'pitch pitch2) ;;; <-- pitch2
                                                    (make-music 'TieEvent)))
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'NoteEvent
                                                      'duration (ly:make-duration 2 0 1 1)
                                                      'pitch pitch2))))) ;;; <-- pitch2
                          (make-music 'SequentialMusic
                            'elements (list 
                                       (make-music 'EventChord
                                         'elements (list 
                                                    (make-music 'NoteEvent
                                                      'duration (ly:make-duration 1 0 1 1)
                                                      'pitch pitch1))))))))) %;;; <-- pitch1

#(define (split-music-sequence music-seq n)
  "Return a list of music sequences, which elements are taken from
 `music-seq', grouped by n elements."
  (define (split seq acc)
    (let ((rest (list-tail seq n)))
      (if (pair? rest)
          (split rest (cons (list-head seq n) acc))
          (reverse! (cons seq acc)))))
  (let ((elements (-> music-seq elements)))
    (if (null? elements)
        (list)
        (map-in-order (lambda (seq) (make-music 'SequentialMusic 'elements seq))
                      (split elements (list))))))

prelude = #(def-music-function (parser location music) (ly:music?)
             (let ((notes-up (list))
                   (notes-middle (list))
                   (notes-down (list)))
               (for-each (lambda (five-note-seq)
                           (let ((half-measure (prelude-pattern five-note-seq)))
                             (set! notes-up (cons (-> half-measure elements 0)
                                                  (cons (-> half-measure elements 0) notes-up)))
                             (set! notes-middle (cons (-> half-measure elements 1)
                                                      (cons (-> half-measure elements 1) notes-middle)))
                             (set! notes-down (cons (-> half-measure elements 2)
                                                    (cons (-> half-measure elements 2) notes-down)))))
                         (split-music-sequence music 5))
             #{
               \context PianoStaff <<
                 \context Staff = "up" <<
                   \context Voice = "high" {
                     \clef treble
                     $(make-music 'SequentialMusic 'elements (reverse notes-up))
                   }
                   \context Voice = "middle" {
                     \clef treble
                     $(make-music 'SequentialMusic 'elements (reverse notes-middle))
                   }
                 >>
                 \context Staff = "down" <<
                   \context Voice = "low" {
                     \clef bass
                     $(make-music 'SequentialMusic 'elements (reverse notes-down))
                   }
                 >>
               >> #}))

\score { 
  << 
    {
      %% The notes : regular mottos + ending
      \prelude {
        c'   e'  g' c'' e''
        c'   d'  a' d'' f''
        b    d'  g' d'' f''
        c'   e'  g' c'' e''
        c'   e'  a' e'' a''
        c'   d'  fis' a' d''
        b    d'  g' d'' g''
        b    c'  e' g' c''
        a    c'  e' g' c''
        d    a   d' fis' c''
        g    b   d' g' b'   
        g    bes e' g' cis''
        f    a   d' a' d''  
        f    aes d' f' b'   
        e    g   c' g' c''  
        e    f   a c' f'  
        d    f   a c' f'  
        g,   d   g b f' 
        c    e   g c' e'  
        c    g   bes c' e'
        f,   f   a c' e'  
        fis, c   a c' ees'
        aes, f   b c' d'  
        g,   f   g b d' 
        g,   e   g c' e'  
        g,   d   g c' f'  
        g,   d   g b f' 
        g,   ees a c' fis'
        g,   e!  g c' g'  
        g,   d   g c' f'  
        g,   d   g b f' 
        c,   c   g bes e'
      }
      <<
        \context Staff = "up" {
          r8 f16 a c' f' c' a c' a f a f d f d
          r8 g'16 b' d'' f'' d'' b' d'' b' g' b' d' f' e' d'
          <e' g' c''>1 \bar "|."
        }
        \context Staff = "down" {
          << { r16 c8. ~ c4 ~ c2 r16 b,8. ~ b,4 ~ b,2 c1 }
             \\ { c,2 c, c, c, c,1 } >>
        }
      >>
    }
    %% manual staff switches
    \context Voice = "high" {
      \voiceOne s1*9 \oneVoice
    }
    \context Voice = "middle" {
      \voiceTwo s1*9 \change Staff = "down" \voiceOne
    }
    \context Voice = "low" {
      \oneVoice s1*9 \voiceTwo
    }
  >>
  \midi { \tempo 4 = 80 }
  \layout { }
}
