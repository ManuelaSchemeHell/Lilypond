\version "2.19.37"
\language "deutsch"
Absatz=#0.5
\include "Lyrics.ly"
\include "Melody.ly"
\include "Chords.ly"
\include "Texte.ly"

FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))
\paper {
  #(set-paper-size "a4")
  annotate-spacing = ##f
  top-margin = 25\mm
  ragged-right = ##f
  ragged-bottom = ##t
  bottom-margin = 25\mm
  indent = #0
  line-width = 140\mm
  #(include-special-characters)
  print-all-headers = ##t
  % system-system-spacing.minimum-distance = #60 %50
  %system-system-spacing.extra-distance = #10
  %system-system-spacing.basic-distance = #50 %30
  oddFooterMarkup = \markup \fill-line {
    \abs-fontsize #7 { \FootLeft }
  }
  tocItemMarkup = \tocItemWithDotsMarkup
  first-page-number = #0
  print-first-page-number = #f
}
\layout {

  \context {
    \Staff
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    %\consists Mark_engraver
    \override StaffSymbol.thickness = #0.35 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
    % \set Beam.autoBeaming = ##f
    %\remove System_start_delimiter_engraver
  }
  \context {
    \StaffGroup
    \remove System_start_delimiter_engraver
  }
  \context {
    \Score
    %\remove Bar_number_engraver
    \remove System_start_delimiter_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override RehearsalMark.outside-staff-priority=##f
    \override RehearsalMark.extra-offset = #'(-3 . 4)
  }
  \context {
    \ChordNames
    chordNameLowercaseMinor = ##f
    majorSevenSymbol = \markup { maj7 }
    chordChanges = ##f
  }
  \context {
    \Voice
    \override NoteCollision.merge-differently-dotted = ##t
    \override NoteCollision.merge-differently-headed = ##t
  }
}
\markuplist \table-of-contents \pageBreak

\score
{
  <<
    \new Staff="leadsheet"
    <<
      \tocItem \markup "Hoch auf dem gelben Wagen"
      \new Voice="melody" { \"mHoch auf dem gelben Wagen" }
      \new Lyrics \with { alignBelowContext = "leadsheet" }
      \lyricsto "melody" { \"lHoch auf dem gelben Wagen" }
    >>
    \new ChordNames {  \"cHoch auf dem gelben Wagen" }

  >>
  \header {
    title = "Hoch auf dem gelben Wagen"
    %subtitle = "localsubtitle"
    composer = "Weise: Heinz Höhne, 1892-1968"
    poet = "Worte: Rudolf Baumbach (1840–1905)"
  }
}
\"Hoch auf dem gelben Wagen"

\score
{
  <<
    \context Staff="leadsheet"
    <<
      \tocItem \markup "Wiegende Welle"
      \context Voice="melody" { \"mWiegende Welle" }
      \context Lyrics \with { alignBelowContext = "leadsheet" }
      \lyricsto "melody" {  \"Wiegende Welle2" }
      \new Lyrics \with { alignBelowContext = "leadsheet" }
      \lyricsto "melody" { \"Wiegende Welle1" }
    >>
    \context ChordNames { \"cWiegende Welle" }

  >>
  \header {
    title = "Wiegende Welle"
    composer = "Volksweise"
    poet = "Mündlich überliefert"
  }
}

\score
{
  <<
    \context Staff="leadsheet"
    <<
      \tocItem \markup "Wir lieben die Stürme"
      <<
        \context Voice="melody" { \"mWir lieben die Stürme1" }
        \context Voice="tiefer" { \"mWir lieben die Stürme2" }
      >>
      \context Lyrics \with { alignBelowContext = "leadsheet" }
      \lyricsto "melody" { \"lWir lieben die Stürme" }
    >>
    \context ChordNames {  \"cWir lieben die Stürme" }
  >>
  \header {
    title = "Wir lieben die Stürme"
    composer = "Volksweise"
    poet = "Mündlich überliefert"
  }
}
\"Wir lieben die Stürme"

%%{
\score
{
  <<
    \context Staff="leadsheet"
    <<
      \tocItem \markup "Die grauen Nebel"
      \context Voice="melody" { \"mDie grauen Nebel" }
      \context Lyrics \with { alignBelowContext = "leadsheet" }
      \lyricsto "melody" { \"lDie grauen Nebel" }
    >>
    \context ChordNames {  \"cDie grauen Nebel" }
  >>
  \header {
    title = "Die grauen Nebel"
    composer = "Volksweise"
    poet = "Mündlich überliefert"
  }
}
\"Die grauen Nebel"
%}

\score
{
  <<
    \context Staff="leadsheet"
    <<
      \tocItem \markup "Wir ziehen über die Straßen"
      <<
        \context Voice="melody" { \"mWir ziehen über die Straßen1" }
        \context Voice="tiefer" { \"mWir ziehen über die Straßen2" }
      >>
      \context Lyrics \with { alignBelowContext = "leadsheet" }
      \lyricsto "melody" { \"lWir ziehen über die Straßen" }
    >>
    \context ChordNames {  \"cWir ziehen über die Straßen" }
  >>
  \header {
    title = "Wir ziehen über die Straßen"
    composer = "Wort und Weise: Robert Götz (1892-1978)"
  }
}
\"Wir ziehen über die Straßen"

%mystring="Lili Marleen"
\score
{
  <<
    \context Staff="leadsheet"
    <<
      \tocItem \markup "Lili Marleen"
      <<
        \context Voice="melody" { \"mLili Marleen1" }
        \context Voice="tiefer" { \"mLili Marleen2" }
      >>
      \context Lyrics \with { alignBelowContext = "leadsheet" }
      \lyricsto "melody" { \"lLili Marleen" }
    >>
    \context ChordNames {  \"cLili Marleen" }
  >>
  \header {
    title = "Lili Marleen"
    poet = "Worte: Hans Leip"
   composer = "Weise: Norbert Schultze, 1940"
  }
}
\"Lili Marleen"
