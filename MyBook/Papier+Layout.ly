%% Include File für alle Etüden
%% um gleiches Layout sicherzustellen
FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))

#(set-global-staff-size 18)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A function to modify the shape of slurs by offsetting the positions property
% from default control-point values. Setting either y1 or y2 to zero will leave
% that attachment-point unchanged. Syntax: \offsetPositions #'(y1 . y2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

offsetPositions =
#(define-music-function (offsets) (pair?)
   #{
     \once \override Slur.positions =
     #(lambda (grob)
        `(,(+ (car offsets) (cdar (ly:slur::calc-control-points grob))) .
           ,(+ (cdr offsets) (cdr (cadddr (ly:slur::calc-control-points grob))))))
   #})

\paper {
  #(set-paper-size "a4")
  myStaffSize = #20
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
  annotate-spacing = ##f
  left-margin = #15
  %system-system-spacing.basic-distance = #8
  %system-system-spacing.extra-distance = #0
  system-system-spacing = #'((padding . 0)
                             (basic-distance . 0.1)
                             (minimum-distance . 20))
  score-system-spacing = #'((basic-distance . 0)
                            (minimum-distance . 0)
                            (padding . 1)
                            (stretchability . 100))
  score-system-spacing = #'((basic-distance . 14)
                            (minimum-distance . 0)
                            (padding . 1)
                            (stretchability . 120))
  markup-system-spacing = #'((basic-distance . 5)
                             (padding . 0.5)
                             (stretchability . 10))
  score-markup-spacing = #'((basic-distance . 12)
                            (padding . 0.5)
                            (stretchability . 160))
  markup-markup-spacing = #'((basic-distance . 1)
                             (padding . 0.5))
  top-system-spacing = #'((basic-distance . 1)
                          (minimum-distance . 5)
                          (padding . 1))
  top-markup-spacing = #'((basic-distance . 0)
                          (minimum-distance . 0)
                          (padding . 1))
  last-bottom-spacing = #'((basic-distance . 1)
                           (minimum-distance . 0)
                           (padding . 1)
                           (stretchability . 10))

  markup-system-spacing.extra-distance = #0
  page-count = #3
  top-margin = #20
  ragged-right = ##f
  bottom-margin = #10
  last-bottom-spacing.basic-distance = #10
}

\layout {
  indent = #15
  ragged-last-bottom = ##t
  ragged-last = ##f
  ragged-bottom = ##f
  line-width = #185

  \context {
    \Staff
    \omit ClefModifier
    %\override Clef.break-visibility = #'#(#f #t #t)
    %\consists "Bar_number_engraver"
    %\override BarNumber.padding = #0
    % \override BarNumber.self-alignment-X = #CENTER
    % \override BarNumber.break-visibility = #end-of-line-invisible
    %\override Slur.outside-staff-priority = #150
    % \override OttavaBracket.outside-staff-priority = #1000
    % \override TextScript.outside-staff-priority = #100
    \override OttavaBracket.outside-staff-priority = #'()
    \override OttavaBracket.Y-offset = #0
    \override OttavaBracket.extra-offset = #'(0 . 8)
    %\override OttavaBracket.padding = #5
    %\override OttavaBracket.staff-padding = #6
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    \consists Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override StaffSymbol.thickness = #0.3
    % \override BarLine.hair-thickness =1.6 %1.9*staff-line thickness  Thickness of the thin line in a bar line.
    %\override BarLine.thick-thickness = 5 %6*staff-line thickness Bar line thickness, measured in line-thickness
  }

  \context {
    \Score
    %\remove "Bar_number_engraver" % Taktnummerierung
    %\override BarNumber.break-visibility = #'#(#f #f #f)
    \remove Bar_number_engraver
    %\override BarNumber.break-visibility = #end-of-line-invisible
    %\override BarNumber.padding = #0
    %\override BarNumber.break-visibility = #end-of-line-invisible
    %\override BarNumber.self-alignment-X = #CENTER
    %% \override NonMusicalPaperColumn.line-break-permission = ##f
    %% \override NonMusicalPaperColumn.page-break-permission = ##f
    \remove Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override KeyCancellation.break-visibility = #'#(#f #t #t)
    \override TextScript.self-alignment-X = #LEFT
  }
  \context {
    \ChordNames
    \remove "Staff_performer"
  }
  \context {
    \Voice
    %\override Beam.beam-thickness = #0.4 % 0.48
    %\override Slur.line-thickness = #0.5 % 0.8
    %\override Tie.line-thickness = #0.5
  }
}
