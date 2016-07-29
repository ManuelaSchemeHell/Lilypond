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
  %% system-system-spacing.extra-distance = #0
  left-margin = #15
  %% system-system-spacing.basic-distance = #0
  page-count = #3
  %top-margin = #20
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
    % \override Clef.full-size-change = ##t
  }

  \context {
    \Score
    %\remove "Bar_number_engraver" % Taktnummerierung
    %\override BarNumber.break-visibility = #'#(#f #f #f)
    \override BarNumber.break-visibility = #end-of-line-invisible
    \override BarNumber.padding = #0
    %\override BarNumber.break-visibility = #end-of-line-invisible
    \override BarNumber.self-alignment-X = #CENTER
    %% \override NonMusicalPaperColumn.line-break-permission = ##f
    %% \override NonMusicalPaperColumn.page-break-permission = ##f
    \override RehearsalMark.self-alignment-X = #LEFT
    \override KeyCancellation.break-visibility = #'#(#f #t #t)
    \override TextScript.self-alignment-X = #LEFT
  }
}
