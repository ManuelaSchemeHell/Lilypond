% Pop chords as used in English/American popular music
% by James L. Hammons
% Mailinglist: https://lists.gnu.org/archive/html/lilypond-user/2010-03/msg00523.html

% Written against \version "2.11.52"

chordFlat = \markup { \hspace #0.2 \tiny \raise #1.0 \flat }

chordSharp = \markup { \hspace #0.1 \teeny \raise #1.0 \sharp }

popChordsMusic =
{
        % Triads

        <c g>-\markup { "5" }
        <c d g>-\markup { "2" }
%       <c d g>-\markup { "sus2" }

        <c f g>-\markup { "sus" }
%       <c f g>-\markup { "sus4" }
%       <c ees ges>-\markup { \small \raise #1.0 "o" }
        <c ees ges>-\markup { \raise #0.8 "o" }

%       <c ees ges>-\markup { "dim" }
%       <c e gis>-\markup { "aug" }                                             
                        % or +

        % Sixths

        <c e g a>-\markup { "6" }

        <c ees g a>-\markup { "m6" }

        % Sevenths (including altered)

        <c e g bes>-\markup { "7" }
        <c ees g bes>-\markup { "m7" }
        <c e g b>-\markup { "maj7" }

        <c f g bes>-\markup { "7sus4" }
        <c d g bes>-\markup { "7sus2" }
        <c e ges bes>-\markup { "7" \chordFlat "5" }
        <c e gis bes>-\markup { "7" \chordSharp "5" }

%       <c e gis bes>-\markup { "aug7" }                                        
                % or +7
        <c ees g b>-\markup { "m(maj7)" }
%       <c ees ges beses>-\markup { \small \raise #1.0 { "o" } "7" }

        <c ees ges beses>-\markup { \raise #0.8 { "o" } "7" }
%       <c ees ges beses>-\markup { "dim7" }
  

% <c ees ges bes>-\markup { \small \raise #1.0 { #(ly:export (ly:wide- char->utf-8 #x00f8)) } "7" } % <c ees ges bes>-\markup { \raise #0.8 { #(ly:export (ly:wide-char- >utf-8 #x00f8)) } "7" }

        <c ees ges bes>-\markup { "m7" \chordFlat "5" }
        <c e ges b>-\markup { "maj7" \chordFlat "5" }
        <c e gis b>-\markup { "maj7" \chordSharp "5" }


        % Ninths (including altered--incomplete)

        <c e g bes d'>-\markup { "9" }
        <c ees g bes d'>-\markup { "m9" }
        <c e g b d'>-\markup { "maj9" }

        <c e g d'>-\markup { "add9" }
        <c e g a d'>-\markup { "6/9" }
        <c ees g a d'>-\markup { "m6/9" }
        <c ees g b d'>-\markup { "m(maj9)" }

        <c e g bes des'>-\markup { "7" \chordFlat "9" }
        <c e g bes dis'>-\markup { "7" \chordSharp "9" }
%dim7add9, dim7b9, dim7#9, 9#5, 9b5, maj9#5, maj9b5, 9sus4, 9sus2


        % Elevenths (incomplete)

        <c e g bes d' f'>-\markup { "11" }
        <c ees g bes d' f'>-\markup { "m11" }
        <c e g b d' f'>-\markup { "maj11" }

        <c e g f'>-\markup { "add11" }
        <c ees g f'>-\markup { "m add11" }
        <c ees g bes f'>-\markup { "m7add11" }

        % Thirteenths (incomplete)


        <c e g bes d' a'>-\markup { "13" }
        <c ees g bes d' a'>-\markup { "m13" }
        <c e g b d' a'>-\markup { "maj13" }
        <c e g a'>-\markup { "add13" }


        % Misc add chords

        <c e g bes des' aes'>-\markup { "7" \chordFlat "9" \chordFlat "13" }
        <c e gis bes des'>-\markup { "7" \chordSharp "5" \chordFlat "9" }

        <c e g b d' fis'>-\markup { "maj9" \chordSharp "11" }
        <c e g bes d' fis'>-\markup { "9" \chordSharp "11" }
}

% Add to existing exceptions

popChordsAdd = #(append
         (sequential-music-to-chord-exceptions popChordsMusic #t)
         ignatzekExceptions)

% Bah, can't we set this globally? YES! See below...
% \set chordNameExceptions = #popChords


% Bah, this doesn't work either...
% #(set chordNameExceptions popChords)


% Let's try fixing the accidentals with some Scheme...

#(define (chord-name->pop-markup pitch)

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
              (make-hspace-markup 0.3) ;; WAS: 0.4
              (make-tiny-markup (make-raise-markup 1.0
                (make-musicglyph-markup "accidentals.flat")))

            )
          )

          ;; or handle adding the sharp symbol

          (make-line-markup
            (list
              (make-hspace-markup 0.1) ;; WAS: 0.2
              (make-teeny-markup (make-raise-markup 1.0

                (make-musicglyph-markup "accidentals.sharp")))
            )
          )

        )

      )

    )
  )

  )
)

%{
popChords =
{
  \set chordNameExceptions = #popChordsAdd

  \set chordRootNamer = #chord-name->pop-markup
  \override ChordName #'extra-spacing-width = #'(-1.25 . 1.25)
}
%}

\layout
{
  \context
  {
    \Score
    chordNameExceptions = #popChordsAdd

    chordRootNamer = #chord-name->pop-markup
    \override ChordName #'extra-spacing-width = #'(-1.25 . 1.25)
  }
}
  
