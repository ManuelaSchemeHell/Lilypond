\version "2.18"

% Brandt & Roemer chord symbols as developed by Carl Brandt and Clinton Roemer.
% Published as "Standardized Chord Symbol Notation (A Uniform System for the Music Profession)."

chordFlat = \markup \concat { \hspace #0.1 \raise #0.5 \fontsize #-1 \flat \hspace #0.2 }
chordSharp = \markup \concat { \hspace #0.1 \raise #0.5 \fontsize #-1 \sharp \hspace #0.2 }

#(define (chord-name->roemer-markup pitch lowercase?)

  (let* ((alt (ly:pitch-alteration pitch)))

  (make-line-markup
    (list
      (make-simple-markup (vector-ref #("C" "D" "E" "F" "G" "A" "B") (ly:pitch-notename pitch)))

      ;; If it's natural, do nothing
      (if (= alt 0)
        (make-line-markup (list empty-markup))

        (if (= alt FLAT)

          ;; Otherwise, handle adding the flat symbol
          (make-line-markup
            (list
             (make-hspace-markup 0.15)
              (make-tiny-markup (make-raise-markup 1.33
                (make-musicglyph-markup "accidentals.flat")))
              (make-hspace-markup 0.05)))

          ;; or handle adding the sharp symbol
          (make-line-markup
            (list
              (make-hspace-markup 0.2)
              (make-teeny-markup (make-raise-markup 1.5
                (make-musicglyph-markup "accidentals.sharp")))))))))))

chord_mu_sixnine = \markup \concat {
            \hspace #0.25
            \fontsize #-2 \raise #0.875 "6"
            \hspace #-0.15 \raise #0.25 \override #'(thickness . 1.75) \draw-line #'(0.625 . 1.75)
            \hspace #-0.125 \fontsize #-2 "9"
      }
chord_mu_addnine = \markup \concat { \hspace #0.25 \fontsize #-3 \raise #0.875 "(ADD 9)" }
chord_mu_nine = \markup \raise #0.875 \concat { \hspace #0.2 \fontsize #-2 "9" }
chord_mu_eleven = \markup \raise #0.875 \concat { \hspace #0.2 \fontsize #-2 "11" }
chord_mu_thirteen = \markup \raise #0.875 \concat { \hspace #0.2 \fontsize #-2 "13" }
chord_mu_minthirteen = \markup \concat {
            \hspace #0.1 \fontsize #-3 "MI"
            \hspace #0.1 \fontsize #-2 \raise #0.875 "13"
      }

roemerChords_markups = {
  %%%  CHAPTER 4: MAJOR CHORDS
    %%  MAJOR TRIADS
        <c e g>
    %%  MAJOR TRIADS WITH ADDED SIXTH
        <c e g a>-\markup \raise #0.875 \fontsize #-2 \concat { \hspace #0.2 "6" }
    %%  MAJOR TRIADS WITH ADDED SIXTH & NINTH
      <c e g a d'>-\chord_mu_sixnine
    %%  MAJOR TRIADS WITH ADDED NINTH ONLY
      <c e g d'>-\chord_mu_addnine
    %%  DOMINANT SEVENTHS
        <c e g bes>-\markup \raise #0.875 \concat { \hspace #0.2 \fontsize #-2 "7" }
    %%  DOMINANT NINTHS
        <c e g bes d'>-\chord_mu_nine
    %%  DOMINANT ELEVENTHS
        <c e g bes d' f'>-\chord_mu_eleven
        <c g bes d' f'>-\chord_mu_eleven
    %%  DOMINANT THIRTEENTHS
        <c e g bes d' f' a'>-\chord_mu_thirteen
        <c e g bes d' a'>-\chord_mu_thirteen
        <c e bes d' a'>-\chord_mu_thirteen
    %%  MAJOR SEVENTHS
      <c e g b>-\markup \concat {
            \hspace #0.2 \fontsize #-3 "MA"
            \hspace #0.1
            \fontsize #-2 \raise #0.875 "7"
      }
    %%  MAJOR NINTHS
      <c e g b d'>-\markup \concat {
            \hspace #0.2 \fontsize #-3 "MA"
            \hspace #0.1
            \fontsize #-2 \raise #0.875 "9"
      }

  %%%  CHAPTER 5: MINOR CHORDS
    %%  MINOR TRIADS
      <c ees g>-\markup \concat { \hspace #0.1 \fontsize #-3 "MI" }
    %%  MINOR TRIADS WITH ADDED SIXTH
      <c ees g a>-\markup \concat {
            \hspace #0.1 \fontsize #-3 "MI"
            \hspace #0.1 \fontsize #-2 \raise #0.875 "6"
      }
    %%  MINOR TRIADS WITH ADDED SIXTH & NINTH
      <c ees g a d'>-\markup \chord_mu_sixnine
    %%  MINOR TRIADS WITH ADDED NINTH ONLY
      <c ees g d'>-\markup \concat {
            \hspace #0.1 \fontsize #-3 "MI"
            \hspace #0.2
            \fontsize #-3 \raise #0.875 "(ADD 9)"
      }
    %%  MINOR SEVENTHS
      <c ees g bes>-\markup \concat {
            \hspace #0.1 \fontsize #-3 "MI"
            \hspace #0.1 \fontsize #-2 \raise #0.875 "7"
      }
    %%  MINOR NINTHS
      <c ees g bes d'>-\markup \concat {
            \hspace #0.1 \fontsize #-3 "MI"
            \hspace #0.1 \fontsize #-2 \raise #0.875 "9"
      }
    %%  MINOR ELEVENTHS
      <c ees g bes d' f'>-\markup \concat {
            \hspace #0.1 \fontsize #-3 "MI"
            \hspace #0.1 \fontsize #-2 \raise #0.875 "11"
      }
    %%  MINOR THIRTEENTHS
      <c ees g bes d' f' a'>-\chord_mu_minthirteen
      <c ees g bes d' a'>-\chord_mu_minthirteen
    %%  MINOR TRIADS WITH A MAJOR SEVENTH
      <c ees g b>-\markup \concat {
            \hspace #0.1 \fontsize #-3 "MI"
            \raise #0.875 \fontsize #-2 \concat { \hspace #0.2 "(MA" \hspace #0.4 "7)" }
      }
    %%  MINOR NINTHS WITH A MAJOR SEVENTH
      <c ees g b d'>-\markup \concat {
            \hspace #0.1 \fontsize #-3 "MI"
            \raise #0.875 \fontsize #-2 \concat { \hspace #0.2 "9" \hspace #0.33 "(MA" \hspace #0.4 "7)" }
      }

  %%%  CHAPTER 6: DIMINISHED CHORDS
    %%  DIMINISHED SEVENTHS
      <c ees ges beses>-\markup \concat { \hspace #0.2 \lower #0.75 \fontsize #4 "°" }
    %%  DIMINISHED TRIADS
      <c ees ges>-\markup \concat {
            \hspace #0.1 \fontsize #-3 "MI"
            \hspace #0.2 \raise #0.875 \fontsize #-2 \concat { "(" \chordFlat "5)" }
      }

  %%%  CHAPTER 7: AUGMENTED CHORDS
    %%  AUGMENTED TRIADS
      <c e gis>-\markup "+"
    %%  AUGMENTED (DOMINANT) SEVENTHS & NINTHS
      <c e gis bes>-\markup \concat { "+"  \hspace #0.2 \raise #0.875 \fontsize #-2 "7" }
      <c e gis bes d'>-\markup \concat { "+" \hspace #0.2 \raise #0.875 \fontsize #-2 "9" }
    %%  AUGMENTED MAJOR SEVENTHS & NINTHS
      <c e gis b>-\markup \concat {
            \hspace #0.1 "+"
            \raise #0.875 \fontsize #-2 \concat { \hspace #0.2 "(MA" \hspace #0.4 "7)" }
      }
      <c e gis b d'>-\markup \concat {
            \hspace #0.1 "+"
            \raise #0.875 \fontsize #-2 \concat { \hspace #0.2 "9" \hspace #0.33 "(MA" \hspace #0.4 "7)" }
      }
    %%  AUGMENTED MINOR TRIADS & MINOR SEVENTHS
      <c ees gis>-\markup " *TBD"
      <c ees gis bes>-\markup " *TBD"

  %%%  CHAPTER 8: SUSPENSIONS
    %%  SUSPENDED DIMINISHED SEVENTHS

  %%%  CHAPTER 9: CHORDS WITH ALTERED FUNCTIONS
    %%  FLAT FIFTHS
    %%  ALTERED NINTHS
    %%  ALTERED FIFTHS & NINTHS COMBINED
    %%  ALTERED ELEVENTHS

  %%%  CHAPTER 10: COMPOUND CHORDS

  %%%  CHAPTER 11: POLYTONAL CHORDS

  %%%  CHAPTER 12: MISCELLANY
    %%  FOURTH CHORDS
    %%  OMITTED NOTES
}

roemerChordsAdd = #(append
	 (sequential-music-to-chord-exceptions roemerChords_markups #t)
	 ignatzekExceptions)

\layout {
  \context {
    \Score
    chordNameExceptions = #roemerChordsAdd
    chordRootNamer = #chord-name->roemer-markup
    \override ChordName.extra-spacing-width = #'(-1.25 . 1.25)
  }
}
