%% does not work with 2.18
%% from the old Lilypond forum
%% https://archiv.lilypondforum.de/index.php/topic,2457.0.html

\version "2.19.48"

tupletU = {
  \tupletUp
  \override TupletNumber.direction = #UP
}

tupletD = {
  \tupletDown
  \override TupletNumber.direction = #DOWN
}

tupletN = {
  \revert TupletBracket.direction
  \revert TupletNumber.direction
}

#(define (my-tuplet-number::calc-fraction-text grob)
    (let (;; let 'direction evaluate to use the generic tie-markup-command
          (dir (ly:grob-property grob 'direction)))
    (make-tie-markup(string-append  " " (tuplet-number::calc-fraction-text grob)" "))))

\relative c'' {
  \override TupletNumber.text = #my-tuplet-number::calc-fraction-text
  \tuplet 6/4 { < d c' >16  a' fis d c a }
  \voiceOne
  \tuplet 6/4 { < d c' >16  a' fis d c a }
}

#(define (my-tuplet-number::calc-denominator-text grob)
   (let (;; let 'direction evaluate to use the generic tie-markup-command
          (dir (ly:grob-property grob 'direction)))
     (make-tie-markup
      (string-append  "  " (tuplet-number::calc-denominator-text grob) "  "))))

%% Beispiel zum Ausprobieren

\relative c'' {
  \tupletU
  \override TupletNumber.text = #my-tuplet-number::calc-fraction-text
  \tuplet 6/4 { d16  a' fis d c a }
  \tupletD
  \tuplet 6/4 { d16  a' fis d c a }
 \tupletN
  \tuplet 6/4 { d16  a' fis d c a }
  \tuplet 6/4 { d,16  a' fis d c a }
}
