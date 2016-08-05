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

  page-count = #4
  top-margin = #10
  ragged-right = ##f
  bottom-margin = #10
  last-bottom-spacing.basic-distance = #10
  #(include-special-characters)
}

\layout {
  indent = #15
  ragged-last-bottom = ##t
  ragged-last = ##f
  ragged-bottom = ##f
  line-width = #185

  \context {
    \Staff
    %\omit ClefModifier
    %\override Clef.break-visibility = #'#(#f #t #t)
    %\consists "Bar_number_engraver"
    %\override BarNumber.padding = #0
    % \override BarNumber.self-alignment-X = #CENTER
    % \override BarNumber.break-visibility = #end-of-line-invisible
    %\override Slur.outside-staff-priority = #150
    % \override OttavaBracket.outside-staff-priority = #1000
    % \override TextScript.outside-staff-priority = #100
    %\override OttavaBracket.outside-staff-priority = #'()
    %\override OttavaBracket.Y-offset = #0
    %\override OttavaBracket.extra-offset = #'(0 . 8)
    %\override OttavaBracket.padding = #5
    %\override OttavaBracket.staff-padding = #6
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    \consists Mark_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override StaffSymbol.thickness = #0.35 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
    %\override Hairpin.thickness = #2
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
    \override NonMusicalPaperColumn.line-break-permission = ##f
    \override NonMusicalPaperColumn.page-break-permission = ##f
    \remove Mark_engraver
    %\override Hairpin.thickness = #2
    \override RehearsalMark.self-alignment-X = #LEFT
    \override KeyCancellation.break-visibility = #'#(#f #t #t)
    \override TextScript.self-alignment-X = #LEFT
    \override TextScript.staff-padding = #3.5
  }
  \context {
    \ChordNames
    \remove "Staff_performer"
  }
  \context {
    \Voice
    \override Hairpin.thickness = #2.5
    %\override PhrasingSlur.padding = #4
    \override PhrasingSlur.outside-staff-priority = #150
    \override Slur.outside-staff-priority = #150
    %\override Beam.beam-thickness = #0.4 % 0.48
    %\override Slur.line-thickness = #0.5 % 0.8
    %\override Tie.line-thickness = #0.5
    \override Script.stencil = #bold-tenuto-script-stencil
  }
}
