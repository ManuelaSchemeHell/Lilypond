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

\header {
  title = "Brandt & Roemer Chord Names"
}

\paper {
  indent = 0
  ragged-right = ##t
  top-markup-spacing = #'((basic-distance . 8))
  last-bottom-spacing = #'((basic-distance . 8))
  oddHeaderMarkup = ##f
  evenHeaderMarkup = ##f
  tagline = ##f
}

testingGlobal = {
  \time 3/4

  %%%  CHAPTER FOUR: MAJOR CHORDS
      \mark \markup \bold { "Chapter 4: Major Chords" }
      s4*3*3 \break
      s4*3 \break
      s4*3*2 \break
      s4*3*2 \break
      s4*3*3 \break
      s4*3*2 \break

  %%%  CHAPTER FIVE: MINOR CHORDS
      \mark \markup \bold { "Chapter 5: Minor Chords" }
      s4*3*3 \break
      s4*3 \break
      s4*3*3 \break
      s4*3*2 \break
      s4*3*2 \break

  %%%  CHAPTER SIX: DIMINISHED CHORDS
      \mark \markup \bold { "Chapter 6: Diminished Chords" }
      s4*3*2 \break

  %%%  CHAPTER SEVEN: AUGMENTED CHORDS
      \mark \markup \bold { "Chapter 7: Augmented Chords" }
      s4*3*2 \break
      s4*3*2 \break
      s4*3*2 \break
      s4*3*2 \break

  %%%  CHAPTER TEN: COMPOUND CHORDS
      \mark \markup \bold { "Chapter 10: Compound Chords" }
      s4*3
}

testingChords = \chordmode {
  %%%  CHAPTER 4: MAJOR CHORDS
    %%  MAJOR TRIADS
      c4 ees4 fis4
    %%  MAJOR TRIADS WITH ADDED SIXTH
      c4:6 ees4:6 fis4:6
    %%  MAJOR TRIADS WITH ADDED SIXTH & NINTH
      c4:6.9 ees4:6.9 fis4:6.9
    %%  MAJOR TRIADS WITH ADDED NINTH ONLY
      c4:3.5.9 ees4:3.5.9 fis4:3.5.9
    %%  DOMINANT SEVENTHS
      c4:7 ees4:7 fis4:7
    %%  DOMINANT NINTHS
      c4:9 ees4:9 fis4:9
    %%  DOMINANT ELEVENTHS
      c4:11 ees4:11 fis4:11 \bar "|"
      c4:11^3 ees4:11^3 fis4:11^3
    %%  DOMINANT THIRTEENTHS
      c4:13.11 ees4:13.11 fis4:13.11 \bar "|"
      c4:13 ees4:13 fis4:13 \bar "|"
      c4:13^5 ees4:13^5 fis4:13^5
    %%  MAJOR SEVENTHS
      c4:maj7 ees4:maj7 fis4:maj7
    %%  MAJOR NINTHS
      c4:maj9 ees4:maj9 fis4:maj9

  %%%  CHAPTER 5: MINOR CHORDS
    %%  MINOR TRIADS
      c4:m ees4:m fis4:m
    %%  MINOR TRIADS WITH ADDED SIXTH
      c4:m6 ees4:m6 fis4:m6
    %%  MINOR TRIADS WITH ADDED SIXTH & NINTH
      c4:m6.9 ees4:m6.9 fis4:m6.9
    %%  MINOR TRIADS WITH ADDED NINTH ONLY
      c4:m3.5.9 ees4:m3.5.9 fis4:m3.5.9
    %%  MINOR SEVENTHS
      c4:m7 ees4:m7 fis4:m7
    %%  MINOR NINTHS
      c4:m9 ees4:m9 fis4:m9
    %%  MINOR ELEVENTHS
      c4:m11 ees4:m11 fis4:m11
    %%  MINOR THIRTEENTHS
      c4:m13 ees4:m13 fis4:m13  \bar "|"
      c4:m13^11 ees4:m13^11 fis4:m13^11
    %%  MINOR TRIADS WITH A MAJOR SEVENTH
      c4:m3.5.7+ ees4:m3.5.7+ fis4:m3.5.7+
    %%  MINOR NINTHS WITH A MAJOR SEVENTH
      c4:m9.7+ ees4:m9.7+ fis4:m9.7+

  %%%  CHAPTER 6: DIMINISHED CHORDS
    %%  DIMINISHED SEVENTHS
      c4:dim7 ees4:dim7 fis4:dim7
    %%  DIMINISHED TRIADS
      c4:dim ees4:dim fis4:dim

  %%%  CHAPTER 7: AUGMENTED CHORDS
    %%  AUGMENTED TRIADS
      c4:aug ees4:aug fis4:aug  \bar "|"
      c4:3.5+ ees4:3.5+ fis4:3.5+
    %%  AUGMENTED (DOMINANT) SEVENTHS & NINTHS
      c4:aug7 ees4:aug7 fis4:aug7 \bar "|"
      c4:aug9 ees4:aug9 fis4:aug9
    %%  AUGMENTED MAJOR SEVENTHS & NINTHS
      c4:maj7.5+ ees4:maj7.5+ fis4:maj7.5+ \bar "|"
      c4:maj9.5+ ees4:maj9.5+ fis4:maj9.5+
    %%  AUGMENTED MINOR TRIADS & MINOR SEVENTHS
      c4:m3.5+ ees4:m3.5+ fis4:m3.5+ \bar "|"
      c4:m7.5+ ees4:m7.5+ fis4:m7.5+

  %%%  CHAPTER 8: SUSPENSIONS
    %%  SUSPENDED DIMINISHED SEVENTHS

  %%%  CHAPTER 9: CHORDS WITH ALTERED FUNCTIONS
    %%  FLAT FIFTHS
    %%  ALTERED NINTHS
    %%  ALTERED FIFTHS & NINTHS COMBINED
    %%  ALTERED ELEVENTHS

  %%%  CHAPTER 10: COMPOUND CHORDS
      g4:m7/c bes4:m7/ees cis'4:m7/fis

  %%%  CHAPTER 11: POLYTONAL CHORDS

  %%%  CHAPTER 12: MISCELLANY
    %%  FOURTH CHORDS
    %%  OMITTED NOTES
}

\layout {
  \context {
    \Score
    defaultBarType = "||"
    \accidentalStyle forget
    \omit BarNumber
    \override BarLine.space-alist.next-note = #'(fixed-space . 3.0)
    \override RehearsalMark.self-alignment-X = #LEFT
    \override RehearsalMark.padding = #10
    \override RehearsalMark.extra-offset = #'(0 . -5)
    \override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/128)
    \omit Stem
    \omit TimeSignature
  }
  \context {
    \ChordNames
    \override ChordName.font-name = "Minion Pro Semibold"
    \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.padding = #1
  }
}

\score {
  <<
    \new ChordNames \testingChords
    \new Staff << \testingGlobal \testingChords >>
  >>
}
