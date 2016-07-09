%% Include File für alle Etüden
%% um gleiches Layout sicherzustellen
FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))
#(set-global-staff-size 20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A function to modify the shape of slurs by offsetting the positions property
% from default control-point values. Setting either y1 or y2 to zero will leave
% that attachment-point unchanged. Syntax: \offsetPositions #'(y1 . y2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

offsetPositions =
#(define-music-function (offsets) (pair?)
   #{
     \once \override Slur.positions = #(lambda (grob)
                                         `(,(+ (car offsets) (cdar (ly:slur::calc-control-points grob))) .
                                            ,(+ (cdr offsets) (cdr (cadddr (ly:slur::calc-control-points grob))))))
   #})

%{
#(let loop ((c 1000))
   (if (> c 0)
       (begin
        (ly:expect-warning "octave check failed")
        (loop (1- c)))))
%}

\paper {
  #(set-paper-size "a4")
  myStaffSize = #20
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }

  annotate-spacing = ##f
  %% system-system-spacing.extra-distance = #0
  left-margin = #10
  %% system-system-spacing.basic-distance = #0
  %page-count = #4
  top-margin = #20
  ragged-right = ##f
  bottom-margin = #10
  last-bottom-spacing.basic-distance = #10
  %last-bottom-spacing = #0
  %{
  markup-system-spacing = #'((basic-distance . 15)
                             (padding . 0.5)
                             (stretchability . 30))
  score-markup-spacing = #'((basic-distance . 15)
                            (padding . 0.5)
                            (stretchability . 60))
  markup-markup-spacing = #'((basic-distance . 1)
                             (padding . 0.5))
  top-system-spacing = #'((basic-distance . 1)
                          (minimum-distance . 0)
                          (padding . 1))
  top-markup-spacing = #'((basic-distance . 0)
                          (minimum-distance . 0)
                          (padding . 1))
  %}
  %  bottom-margin-default = 25\mm
  %system-system-spacing.basic-distance = #8
}

\layout {
  indent = #0
  ragged-last-bottom = ##t
  ragged-last = ##f
  ragged-bottom = ##f
  line-width = #190

  \context {
    \Staff
    \omit ClefModifier
    %\override Clef.break-visibility = #'#(#f #t #t)
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    \override Clef.full-size-change = ##t
    \remove Time_signature_engraver
  }

  \context {
    \Score
    \remove "Bar_number_engraver" % Taktnummerierung
    \override BarNumber.break-visibility = #'#(#f #f #f)
    \override BarNumber.break-visibility = #end-of-line-invisible
    \override BarNumber.self-alignment-X = #CENTER
    \override NonMusicalPaperColumn.line-break-permission = ##f
    \override NonMusicalPaperColumn.page-break-permission = ##f
    \override RehearsalMark.self-alignment-X = #LEFT
    \override KeyCancellation.break-visibility = #'#(#f #t #t)
  }
}
