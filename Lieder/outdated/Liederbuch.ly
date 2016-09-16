\version "2.19.37"
\language "deutsch"
Absatz=#0.5
smallerNoteHead= #-1.5
KommSingMit=\markup { \italic "Komm sing mit 2" }
%myFont=#"MS Mincho"
%myFont=#"TeX Gyre Heros"
%myFont=#"Oranda BT"
myFont=#"Palatino Linotype"
%myFont=#"Cambria Math"
%myFont=#"Georgia"
%myFont=#"DejaVu Serif"
%myFont=#"Monospac821 BT"

#(set-global-staff-size 18)

FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))

leftbrace = \set stanza = \markup {
  \translate #'(0 . -1) "1. "
  \hspace #-0.5
  \translate #'(0 . -0.6) \left-brace #25
}

rightbrace = \set stanza = \markup {
  " "
  \hspace #-17
  \translate #'(0 . 0.4) \right-brace #25 \hspace #8 "1.-3."
}

dropLyrics = {
  \override LyricText.extra-offset = #'(0 . -1.5)
  \override LyricHyphen.extra-offset = #'(0 . -1.5)
  \override LyricExtender.extra-offset = #'(0 . -1.5)
  \override StanzaNumber.extra-offset = #'(0 . -1.5)
}

undropLyrics= {
  \revert LyricText.extra-offset
  \revert LyricHyphen.extra-offset
  \revert LyricExtender.extra-offset
}

\paper {
  #(set-paper-size "a4")
  annotate-spacing = ##f
  top-margin = 25\mm
  ragged-right = ##f
  ragged-bottom = ##f
  bottom-margin = 5\mm
  indent = #0
  line-width = 150\mm
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
    \Voice
    \name FirstVoice
    \alias Voice
    autoBeaming = ##f
    \override NoteCollision.merge-differently-dotted = ##t
    \override NoteCollision.merge-differently-headed = ##t
    \override Stem.direction = #UP
    \override Slur.direction = #UP
    \override Tie.direction = #UP
    \override NoteColumn.horizontal-shift = #0
  }
  \context {
    \Voice
    \name SecondVoice
    \alias Voice
    \remove "Slur_engraver"
    autoBeaming = ##f
    \override NoteCollision.merge-differently-dotted = ##t
    \override NoteCollision.merge-differently-headed = ##t
    \override NoteHead.font-size = #smallerNoteHead
    \override Stem.direction = #DOWN
    \override Tie.direction = #DOWN
    \override NoteColumn.horizontal-shift = #0
  }
  \context {
    \Staff
    explicitClefVisibility = #end-of-line-invisible
    explicitKeySignatureVisibility = #end-of-line-invisible
    %\consists Mark_engraver
    \override StaffSymbol.thickness = #0.5 %0.3=optimaler wert
    \override DynamicLineSpanner.staff-padding = #3
    \accepts FirstVoice
    \accepts SecondVoice
    \consists "Bar_number_engraver"
    \override BarNumber.break-visibility = #end-of-line-invisible
    \override BarNumber.outside-staff-priority =#'()
    \override BarNumber.padding = #1
    \override BarNumber.self-alignment-X = #CENTER
    % \set Beam.autoBeaming = ##f
    %\remove System_start_delimiter_engraver
  }
  \context {
    \StaffGroup
    \remove System_start_delimiter_engraver
    \accepts AltLyrics
  }
  \context {
    \Lyrics
    \name AltLyrics
    \alias Lyrics
    \override StanzaNumber.font-series = #'medium
    \override LyricText.font-shape = #'italic
    \override LyricText.color = #(x11-color 'grey20)
  }
  \context {
    \Score
    %\remove Bar_number_engraver
    \remove System_start_delimiter_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override RehearsalMark.outside-staff-priority=##f
    \override RehearsalMark.extra-offset = #'(-3 . 4)
    \override SpacingSpanner.base-shortest-duration =
    #(ly:make-moment 1/16)
    \remove "Bar_number_engraver"
    startRepeatType = #"|"
    endRepeatType = #":|"
    doubleRepeatType = #":|:"
    beamExceptions = #'()
  }
  \context {
    \ChordNames
    chordNameLowercaseMinor = ##f
    majorSevenSymbol = \markup { maj7 }
    chordChanges = ##f
    \override ChordName.font-name = \myFont
    \override ChordName.font-series = #'bold
    \germanChords
    alignAboveContext = #"leadsheet"
  }
  \context {
    \Voice
    \override NoteCollision.merge-differently-dotted = ##t
    \override NoteCollision.merge-differently-headed = ##t
    beamExceptions = #'()
    autoBeaming = ##f
  }
}

\markuplist \table-of-contents \pageBreak
smallerNoteHead= #-1.5
slurShifts=
#(define-music-function (amount offsets)
   (pair? pair?)
   #{
     \once \override Slur.positions =
     #(lambda (grob)
        `(,(+ (car offsets) (cdar (ly:slur::calc-control-points grob))) .
           ,(+ (cdr offsets) (cdr (cadddr (ly:slur::calc-control-points grob))))))
     \once \override Voice.Slur.extra-offset = $amount
   #}
   )

myTitel="Das Schönste auf der Welt"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  \partial 4
  g4 c,4. e8 e4. g8
  g2. g4 g4. g8 a4 g d2 h'4\rest c,
  h4. d8 d4. h'8 h4. ( a8 ) h4 a g4. g8 a4 g e2 h'4\rest
  g8. e16 c8. c16 c8. c16 c4 c8. e16
  g8. g16 g8. g16 g4 c h4. h8 a4 h c h4\rest h4\rest g \bar ".|:"
  \repeat volta 2 {
    c4. c8 c c d c
    a4 f' d c h4. h8 h h a h
  }
  \alternative {
    { c4 h8 a g4 \breathe g8 g \bar ":|." }
    { c2 h4\rest }
  } \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c'' {
  \partial 4
  g4  c,4. c8 c4. e8
  e2. e4
  e4. e8 f4 e h2 s4 c
  h4. d8 d4. d8 d4. ( c8 ) d4 f e4. e8 f4 e c2 s4
  g'8. e16 c8. c16 c8. c16 c4 c8. e16
  g8. g16 g8. g16 e4 e g4. g8 f4 g e s s g
  e4. e8 e e f e f4 a f a
  g4. g8 g g f g e4 g8 f e4 g8 g e2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 c1 c c g g g g c c c g c c f g:7 c4 f c2 c2.
}
%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Des Morgens in der Früh',"
          "steig ich so hoch hinauf,"
          "da geht so wunderschön"
          "die liebe Sonne auf."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Des Nachts, wenn alles schläft,"
          "nur ich allein bin wach,"
          "dann steig ich auf die Alm hinauf"
          "und jag dem Gamsbock nach."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Den Schatz, den ich nicht mag,"
          "den seh ich alle Tag,"
          "und die mein Herz erfreut,"
          "die ist so weit, so weit."
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "Wenn ich gestorben bin,"
          "so tragt mich hoch hinauf,"
          "begrabt ihr mich im Tale,"
          "dann steig ich selber nauf."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}
%% Songtext
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. " Das Schöns -- te auf der Welt
  ist mein Ti -- ro -- ler -- land,
  mit sei -- nen stei -- len Hö -- hen,
  mit sei -- ner Fel -- sen -- wand.
  \set stanza = #"1.-5." Hol -- la -- ri -- a, hol -- la -- ro,
  hol -- la -- ri -- a, hol -- la -- ro
  hoch dro -- ben auf der Alm.
  Ti -- ro -- ler -- land, wie bist du schön, so schön
  wer weiß, ob wir uns wie -- der -- sehn
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \context Lyrics \with {
        alignBelowContext = "leadsheet"
      } \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Volkslied"
        "Melodie: Volksweise"
      }
    }
    piece = ""
    opus = ""
  }
}
\markup \vspace #(* Absatz -1)
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Wem Gott will rechte Gunst erweisen
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Wem Gott will rechte Gunst erweisen"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \partial 4 \slurDashed
  c4 e g c8. h16 c8 a g2 e4 g
  f8. e16 f8 d e4 c d2 h'4\rest d,8 ( e )
  f4. f8 e8. e16 f8 g a2 g4 g c8. h16 c8 d e4 d c2 h4\rest \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  \partial 4
  c4 e g a8. g16 a8 f e2 c4 e
  d8. c16 d8 h c4 c h2 s4 h8  c
  d4. d8 c8. c16 d8 e f2 e4 g c8. g16 e8 g c4 g e2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 c2 f c1 g2:7 c g1 g2:7 c f c c4 e:m  c/g g:7 c
}
%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Die Bächlein von den Bergen springen,"
          "die Lerchen schwirren hoch vor Lust;"
          "was sollt ich nicht mit ihnen singen"
          "aus voller Kehl und frischer Brust?"
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Den lieben Gott lass ich nur walten,"
          "der Bächlein, Lerchen, Wald und Feld"
          "und Erd und Himmel will erhalten,"
          "hat auch mein Sach aufs Best bestellt."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}
%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "1\"")) = \lyricmode {
  \set stanza = #"1. "
  Wem Gott will rech -- te Gunst er -- wei -- sen,
  den schickt er in die wei -- te Welt,
  dem will er seine Wun -- der wei -- sen
  in Berg und Tal und Strom und Feld.
}
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Die Trä -- gen, die zu Hau -- se lie -- gen,
  er -- quic -- ket nicht das Mor -- gen -- rot,
  sie wis -- sen nur vom Kin -- der -- wie  -- gen,
  von Sor -- gen, Last und Not um Brot.
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics \with {
        alignBelowContext = "leadsheet"
      } \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "2\""))
      }
      \new AltLyrics \with {
        alignBelowContext = "leadsheet"
      } \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "1\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 0.6)
      \right-column {
        "Text: Joseph von Eichendorff (1788-1857), 1822"
        "Melodie: Friedrich Theodor Fröhlich (1803-1836 ), 1833"
      }
    }
    piece = ""
    opus = ""
  }

}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied MGaudeamus igitur
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Gaudeamus igitur"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  \time 3/4 \key b \major
  b8. f16 f4 b g8. g16 g4 h4\rest a8. b16 c4 a b8 [ d ] b4 h4\rest
  \bar ":|."
  a8. b16 c4 c d8 b c4 c a8. b16 c4 c d8 b c4 c

  b8. a16 g8 [ es' ] d [ c ] b4 ( c ) d
  b8. a16 g8 [ es' ] d [ c ] f4 ( a, ) b\fermata   \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  d8. d16 d4 f es8.
  \once \override NoteColumn.force-hshift =#0.4
  f16 es4 s4 es8. es16 es4 es d8 [ f ] d4 s4
  f8. f16 f4 f f8 f f4 f f8. f16 f4 f c8 g' a8 [ g ] f4
  f8. f16 es8 ( g4 ) g8 f2 f4
  f8. f16 es8 ( g4 ) g8 f4 ( es ) d
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  b2. es f b f b4 f2 f2. b4 f2 b4 es2 f2 g4:m es2. f2 b2
}
%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Ubi sunt qui ante nos"
          "in mundo fuere?"
          "Vadite ad superos"
          "transite ad inferos"
          "ubi iam fuere."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Vita nostra brevis est,"
          "brevi finietur,"
          "venit mors velociter,"
          "rapit nos atrociter"
          "nemini parcetur!"
        }
      }
      \vspace #Absatz
      \line {
        \bold "4."
        \column {
          "Vivat academia,"
          "vivant professores!"
          "Vivat membrum quodlibet,"
          "vivant membra quaelibet,"
          "semper sint in flore! "
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "Vivat et res publica,"
          "et qui illam regit!"
          "Vivat nostra civitas,"
          "maecenatum caritas,"
          "quae nos hic protegit!"
        }
      }
      \vspace #Absatz
      \line {
        \bold "6."
        \column {
          "Pereat tristitia"
          "pereant osores"
          "pereat diabolus"
          "quivis antiburschius"
          "atque irrisores "
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold " "
        \column {
          "Sagt mir doch, wo trifft man an,"
          "die vor uns gewesen?"
          "Schwingt euch auf zur Sternenbahn,"
          "geht hinab zu Charons Kahn,"
          "wo sie längst gewesen!"
        }
      }
      \vspace #Absatz
      \line {
        \bold " "
        \column {
          "Kurz ist unsre Lebenszeit,"
          "sie vergeht geschwinde;"
          "unter Sorgen, Müh’ und Streit"
          "schwindet Jugend-Fröhlichkeit,"
          "wie der Rauch vom Winde."
        }
      }
      \vspace #Absatz
      \line {
        \bold " "
        \column {
          "Blüh’, du edler Musenthron,"
          "blühet auch, ihr Lehrer!"
          "Jedem braven Musensohn"
          "werde Ehr’ und Glück zum Lohn,"
          "ihm, der Weisheit Hörer!"
        }
      }
      \vspace #Absatz
      \line {
        \bold " "
        \column {
          "Staat und Städtchen sei beglückt,"
          "auch der Landesvater!"
          "Vivat wer uns Nummos schickt,"
          "wenn die Schuldenlast uns drückt,"
          "vivat Freund und Rather!"
        }
      }
      \vspace #Absatz
      \line {
        \bold " "
        \column {
          "Gram und Sorgen, fliehet jetzt!"
          "Sterbet, Burschenfeinde!"
          "Mag verderben, wer uns verpetzt,"
          "uns belächelt und verhetzt"
          "mit dem besten Freunde!"
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "1\"")) = \lyricmode {
  \set stanza = #"1. "
  Gau -- de -- a -- mus i -- gi -- tur,
  ju -- ve -- nes dum su -- mus,
  post iu -- cun -- dam iu -- ven -- tu -- tem,
  post mo -- les -- tam se -- nec -- tu -- tem
  nos ha -- be __ bit __ hu __ mus,
  nos ha -- be __ bit __ hu __ mus.
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  U -- bi sunt, qui an -- te nos
  in mun -- do fu -- e -- re?
  Va -- di -- te ad su -- pe -- ros,
  tran -- si -- te ad in -- fe -- ros,
  u -- bi iam fu -- e -- re.
}
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"1. "  {
    Laßt uns, weil wir jung noch sind,
    uns des Le -- bens freu -- en!
    Denn wir kom -- men doch ge -- schwind _
    wie ein Pfeil durch Luft und Wind _
    zu der Tod -- ten Rei -- hen,
    zu der Tod -- ten Rei -- hen.
  }
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics \with {
        % alignBelowContext = "leadsheet"
      } \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "1\""))
      }
      \new AltLyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "2\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Christian Wilhelm Kindleben (1748-1786), Halle 1781"
        "Deutscher Text: Johann Christian Günther (1695-1723), 1717"
        "Melodie: Studentenlied, ursprünglich mittelalterliches Bußlied, 1788"
      }
    }
    piece = #KommSingMit
    opus = "S. 291"
  }

}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Gaudeamus igitur
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Der Mai ist gekommen
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

myTitel="Der Mai ist gekommen"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \time 3/4 \partial 4
  c8 (  d  ) e4 e4. f8 a8 (  g  ) g4. e8 g8 f f4 g e2 \bar "|"
  c8 (  d  ) e4 e4. f8 a8 (  g  ) g4. e8 g8 ( f ) f4 g e2 \bar "."
  e8 e d8  ( g  ) g4. g8 fis8  ( a  ) a4. a8
  \set melismaBusyProperties = #'() \unset melismaBusyProperties
  %% melisma: wenn mehrere Noten auf einer Silbe gesungen werden
  d8. ( c16 ) h8.(  a16 )
  \slurDashed
  g8.(  fis16 )
  g2 g8 ( f ) e8. e16 e4. f8
  a4 g4. e8 g8. f16 f4 g e2 \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  \partial 4
  c8  d  c4 c4. c8 f8  e   e4. c8 d8 d d4 < f d> c2
  c8  d  c4 c4. c8 f8  e   e4. c8 d8 d d4 < f d> c2
  e8 e d8   d   d4. d8 d8   fis   fis4. a8 d8.  c16  h8.  a16  g8.  fis16  g2
  g8  f  e8. e16 e4. f8
  a4 g4. e8 g8. f16 f4 g e2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 c2. f4 c2 g2.:7 c c c g:7 c g d d g c
}
%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  %translate #'(0 . 13)
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Frisch auf drum, frisch auf drum im hellen Sonnenstrahl"
          "wohl über die Berge, wohl durch das tiefe Tal."
          "Die Quellen erklingen, die Bäume rauschen all;"
          "mein Herz ist wie ’ne Lerche und stimmet ein mit Schall."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Und abends im Städtlein, da kehr ich durstig ein:"
          "Herr Wirt, eine Kanne, eine Kanne blanken Wein!"
          "Ergreife die Fiedel, du lust’ger Spielmann du,"
          "von meinem Schatz das Liedel, das sing ich dazu."
        }
      }
      \vspace #Absatz
      \line {
        \bold "4."
        \column {
          "Und find ich keine Herberg, so lieg ich zu Nacht"
          "wohl unter blauem Himmel, die Sterne halten Wacht."
          "Im Winde die Linde, die rauscht mich ein gemach,"
          "es küsset in der Frühe das Morgenrot mich wach."
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "O Wandern, o wandern, du freie Burschenlust!"
          "Da weht Gottes Odem so frisch in die Brust,"
          "da singet und jauchzet das Herz zum Himmelszelt:"
          "wie bist du doch so schön, du weite, weite Welt!"
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}
%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "1\"")) = \lyricmode {
  \set stanza = #"1. "
  Der Mai ist ge -- kom -- men, die Bäu -- me schla -- gen aus,
  da blei -- be, wer Lust hat, mit Sor -- gen zu -- haus;
  wie die Wol -- ken dort wan -- dern am himm -- li -- schen Zelt,
  so steht auch mir der Sinn in die wei -- te, wei -- te Welt.
}
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Herr Va -- ter, Frau Mut -- ter, dass Gott euch be -- hüt!
  Wer weiß, wo in der Fer -- ne mein Glück mir noch blüht?
  Es gibt so man -- che Stras -- se, die nim -- mer
  \set ignoreMelismata = ##t
  ich marschiert,
  es gibt so man -- chen Wein, den ich nim -- mer noch pro -- biert.
}
\pageBreak
\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "1\""))
      }
      \new AltLyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "2\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Emanuel Geibel (1815–1884), 1842"
        "Melodie: Justus Wilhelm Lyra (1822–1882), 1843"
      }
    }
    piece = ""
    opus = ""
  }

}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)

Struktur={
  s4 s1 * 3 s2 s4 \break
  s4 s1 * 3 s2 s4 \break
  %  s4 s1 * 3 s2 s4 \break
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Der Mai ist gekommen
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Drei Lilien
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\pageBreak
myTitel="Drei Lilien"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \partial 4 \key b \major
  b8 [ ( d ) ] f4. g8 f4 es b4. c8 b4 f'
  g f es d c2 r4 \bar "|" b8 [ ( d ) ] f4 f f8 ( [ g ) ]  a8 ( [ b ) ]
  b2 g4 c d2 c b r4 \bar "|" b,8  d
  f8. f16 f8 f f8. f16 f8 f f2 ( d4 ) \breathe d8. f16
  b8. b16 b8 b8 d8. c16 b8 c d2 ( b4 ) \breathe g
  f f f b b2 g4 c b2 a b r4 \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  b4 b4. b8 b4 b b4. c8 b4 b
  es d c b a2 s4 b4 d4 d d4  f4
  g2 es4 es f2 f f s4 b,4 b1 b2 s4
  \once \override NoteColumn.force-hshift = #0.6
  %\shiftOnnn
  d4 d2 f2 f2 s4
  d
  d d d f g2 es4 es f2 f f
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 b1 b es f b es b2 f:7 b1
}
#(define-markup-list-command (rparagraph layout props args) (markup-list?)
   (interpret-markup-list layout props
     (make-justified-lines-markup-list (cons (make-hspace-markup -2) args))))

%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Ach Reiter, lieber Reitersmann,"
          "laß doch die Lilien stehn,"
          "die soll ja mein Feinsliebchen"
          "noch lange sehn."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Und sterbe ich noch heute,"
          "so bin ich morgen tot;"
          "dann begraben mich die Leute"
          "ums Morgenrot."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Drei Li -- li -- en, drei Li -- li -- en,
  die pflanzt ich auf mein Grab,
  da kam ein stol -- zer Rei -- ter
  und brach sie ab.
  Ju -- vi -- val -- le -- ral -- le -- ral -- le -- ral -- le -- ra, __
  Ju -- vi -- val -- le -- ral -- le -- ral -- le -- ral -- le -- ra, __
  da kam ein stol -- zer Rei -- ter
  und brach sie ab.
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
        \new Voice \Struktur
      >>
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Volkslied (19. Jhdt)"
        "Melodie: Volksweise (19. Jhdt)"
      }
    }
    piece = ""
    opus = ""
  }

}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Drei Lilien
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Hoch auf dem gelben Wagen
myTitel="Hoch auf dem gelben Wagen"
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Hoch auf dem gelben Wagen"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key f \major
  c4 f8 g a4 c a ( g ) f2 c4 f8 g a4 g f2. r4
  c4 f8 g a4 c a ( g ) f r g4 g g8 [ f ] e f g2. r4
  d4 d8 d g4 g8 a f2 c4 r
  g'4 g8 g c4 g a2 r4 a4
  \repeat volta 2
  {
    \bar ".|:"
    d,4 d8 d f4 e8 d c4 ( f8 [ a ] ) c2
    c2 h4 c d2 c4 b
  }
  \alternative { {a2 r4 a \bar ":|." } { a2 r2 } }
  \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  s1
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  f1 f1 f2. c4 f1 f f c:7 c
  b2 c2 f1 c:7 f b f f
  b2 c:7 f1 f
}
%% Text
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "3."
        \column {
          "Postillon in der Schenke"
          "füttert Rosse im Flug,"
          "schäumendes Gerstengetränke"
          "reicht uns der Wirt im Krug."
          "Hinter den Fensterscheiben"
          "lacht ein Gesicht gar hold,"
          "ich möchte so gerne noch bleiben,"
          "aber der Wagen, der rollt."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Sitzt einmal ein Gerippe"
          "hoch auf dem Wagen vorn,"
          "hält statt der Peitsche die Hippe,"
          "Stundenglas statt Horn."
          "Sag ich: Ade, nun, ihr Lieben,"
          "die ihr nicht mitfahren wollt,"
          "ich wäre so gern noch geblieben,"
          "aber der Wagen, der rollt."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Hoch auf dem gel -- ben Wa -- gen
  sitz ich beim Schwa -- ger vorn.
  Vor -- wärts die Ros -- se tra -- ben,
  lus -- tig schmet -- tert das Horn.
  Ber -- ge und Tä -- ler und Au -- en,
  leuch -- ten -- des Äh -- ren -- gold,
  ich "|:möch" -- te so ger -- ne noch  schau -- en;
  a -- ber der Wa -- gen, der rollt. "Ich :|" rollt.
}

#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Flö -- ten hör ich und Gei -- gen,
  lus -- ti -- ges Baß -- ge -- brumm,
  jun -- ges Volk im Rei -- gen
  tanzt um die Lin -- de he -- rum.
  Wir -- belt wie Blät -- ter im Win -- de,
  ju -- belt und lacht und tollt,
  ich "|:blie" -- be so gern bei der Lin -- de;
  a -- ber der Wa -- gen, der rollt. "Ich :|" rollt.
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
      \new AltLyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "2\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Musik: Heinz Höhne (1892-1968)"
        "Text: Rudolf Baumbach (1840–1905)"
      }
    }
    piece = ""
    opus = ""
  }

}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Ende
%%%%%%%% Hoch auf dem gelben Wagen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Die grauen Nebel
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Die grauen Nebel"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key g \major
  \partial 2
  r8 d8 g a h4 h h8 a g h d4 d2 c8 h a4 a a8 c h a g2 r8
  d8 g a h4 h h8 a g h d4 d2 c8 h a4 a a8 c h a g2 r2
  h2 h h4 c d2 a4 a8 h c4 a h e d4 \breathe \tuplet 3/2 { d8 e d }
  h2 h h4 c d2
  a4 a8 c h4 a g2\fermata \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  s8 d8 g a d,4 d e8 e e e
  fis4 fis2 fis8 fis fis4 fis fis8 a g d d2 s8
  d8 g a g4 g g8 fis e g fis4 fis2 fis8 fis fis4 fis fis8 fis fis fis d2 s2
  d2 d d4 e fis2 fis4 fis8 fis fis4 fis g g h2
  d,2 d d4 e fis2
  fis4 fis8 fis g4 fis d2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s2 g2 e:m d1:7 d g g2 e:m
  d1 d g g g d g g g d g
}
%% Text
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Sie lassen alles in der Tiefe liegen,"
          "wollen nur hinauf zum hellen Licht,"
          "sie wollen in den klaren Höhen siegen,"
          "einen Weg nach unten gibt es nicht."
        }
      }
    }
    \hspace #0 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Sie werden Männer, die ihr Reich erringen,"
          "die es schützen vor dem großen Feind."
          "Die Augen strahlen und die Lieder klingen,"
          "ihre Herzen sind im Kampf vereint."
        }
      }
    }
    \hspace #0 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  Die grau -- en Ne -- bel hat das Licht durch -- drun -- gen,
  und die düs -- tern Ta -- ge sind da -- hin.
  Wir se -- hen ei -- ne blau -- e Schar von Jun -- gen
  an der lau -- ten Stadt vor -- ü -- ber zieh'n.
  Komm, komm, lockt der Schritt.
  Komm, Ka -- me -- rad wir zie -- hen mit.
  Jei jei jei
  Komm, komm, lockt der Schritt.
  komm, wir mar -- schie -- ren mit.
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Volkslied (20. Jhdt.)"
        "Melodie: Volksweise (20. Jhdt.)"
      }
    }
    piece = ""
    opus = ""
  }

}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Die grauen Nebel
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Wiegende Welle
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Wiegende Welle"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  \key g \major
  h4 h8 a g4 g8 e d4 g8 a h4 r
  a4 a8 g fis g a c h2 g4 r
  h4 h8 a \slurDotted g4 ( g8 ) e d4 g8 a h4 r
  a4 a8 g fis g a h g2 r4 r8 g
  e4 g c4. e,8 d4 g h4. g8 fis4. g8 a g a c
  h2 g4 r8 g e e g g c4. e,8
  d d g g h4. g8 fis4. g8 a g a h g2 r \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  d4 d8 c h4 h8 h h4 h8 c d4 s
  fis4 fis8 e d e fis a g2 d4 s
  d4 d8 c h4 h8 h h4 h8 c d4 s
  fis4 fis8 e d e fis g d2 s4 s8 c
  c4 e g4. c,8 h4 d g4. d8 d4. d8 d d fis a
  g2 d4 s8 c c c c c g'4. c,8
  h h d d g4. d8 d4. d8 fis g fis g <d h >2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  g1 g1 d:7 g g  d1 d:7 g c g d:7 g c g d:7 g
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  \set ignoreMelismata = ##t \set stanza = #"1. "
  Wie -- gen -- de Wel -- le auf wo -- gen -- der See,
  wal -- len -- de Flu -- ten der Ge -- zei -- ten,
  schau -- kelnd her -- nie -- der und wie -- der zur Höh,
  trägst du mein Boot im fro -- hen Spiel.
  %\set stanza=#"1.-2."
  "1.-2. Ein" fri -- scher Wind weht uns ge -- schwind
  in blau -- e, un -- be -- grenz -- te Wei -- ten,
  weht im -- mer, im -- mer zu,
  ihr Win -- de, mein Ka -- nu
  fliegt mit uns fort zum fer -- nen Ziel.
}
#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Gisch -- ten -- de Bran -- dung am tük -- ki -- schen Riff,
  stru -- deln -- de Was -- ser mich um -- lau -- ern.
  Al -- len Ge -- fah -- ren trot -- zet mein Schiff,
  hei, wie wir flie -- gen durch die Flut!
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
      \new AltLyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "2\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Volkslied"
        "Melodie: Volksweise"
      }
    }
    piece = ""
    opus = ""
  }

}

\markup \vspace #(* Absatz 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Wiegende Welle
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Wir lieben die Stürme
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Wir lieben die Stürme"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \key a \major
  \partial 8
  \slurDotted
  e8 e4 a8 h8 cis4 h8. a16 h4 a8. gis16 a4 e8 e
  fis4 a8 fis e4 e4 d e8 d cis4 r8 e
  e4 a8 h cis4 h8. a16 h4 a8. gis16 a4 e8 e fis4 a8 (  fis )  e4
  cis'8. cis16
  cis8 ( h ) a8 gis a4 r
  \bar ".|:"
  \stemDown
  e2 a cis a4 e8 e a e a h cis4 d cis h8 a h4 a8. gis16 a2. r8
  \bar ":|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  \key a \major
  \partial 8
  e8 cis4 cis8 d8 e4 d8. cis16 d4 cis8. d16 a4 cis8 cis
  d4 fis8 d cis4 cis4 h cis8 h a4 s8 cis
  cis4 e8 d fis4 d8. cis16 d4 cis8. h16 cis4 cis8 cis d4 fis8 d cis4
  e8. e16
  a4 fis8 e e4 s
  \stemUp
  cis'2 cis e cis4 e8 e cis cis cis d e4 fis e d8 cis d4 e8. e16 cis2.
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s8 a1 h2:m a d a d:7 a a1
  d2 a d a e:7 a a1 a a a2 e:7 a2
}
%% Text
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Wir treiben die Beute mit fliegenden Segeln,"
          "wir jagen sei weit auf das endlose Meer."
          "Wir stürzen auf Deck, und wir kämpfen wie Löwen,"
          "hei, unser der Sieg, viel Feinde, viel Ehr!"
        }
      }
    }
    \hspace #1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "3."
        \column {
          "Ja, wir sind Piraten und fahren zu Meere,"
          "wir fürchten nicht Tod und den Teufel dazu,"
          "wir lachen der Feinde und aller Gefahren,"
          "am Grunde des Meeres erst finden wir Ruh."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {

  \set stanza = #"1. "
  Wir lie -- ben die Stür -- me, die brau -- sen -- den Wo -- gen,
  der eis -- kal -- ten Win -- de rau -- hes Ge -- sicht.
  Wir sind schon der Mee -- re so vie -- le ge -- zo -- gen,
  und den -- noch sank uns' -- re Fah __ _ ne nicht.
  Hei -- jo, hei -- jo, hei -- jo, hei -- jo, hei -- jo -- ho,
  hei -- jo, hei -- jo -- ho, hei -- jo -- jo!
}

#(ly:parser-include-string (string-append "\"l" myTitel "2\"")) = \lyricmode {
  \set stanza = #"2. "
  Unser Schiff glei -- tet stolz durch die schäu -- men -- den Wo -- gen,
  jetzt strafft der __ _ Wind uns're Se -- gel mit Macht.
  Seht ihr hoch __ _ dro -- ben die Fah -- ne sich wen -- den,
  \set ignoreMelismata = ##t
  die blut -- ro -- te Fah -- ne,
  \set ignoreMelismata = ##f
  ihr See __  leut, habt acht.
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics="fstly" \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
      \new AltLyrics="sndly"
      \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "2\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Volkslied"
        "Melodie: Volksweise"
      }
    }
    piece = ""
    opus = ""
  }
}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Wir lieben die Stürme
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Lili Marleen
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Lili Marleen"
%% Voice 1
voltaItalicOne = \markup { \text \fontsize #4 "1.-4." }
voltaItalicThree = \markup { \text \fontsize #4 "5." }
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \set Staff.doubleRepeatType = "|"
  \autoBeamOff
  \key c \major
  \stemUp \repeat volta 2 {
    \slurDotted e8 ( e ) e8 f g4 e
    f8. f16 f8 c' h2
    d,8. d16 d8 e f4 f8 g h8. a16 g8. f16 e2 \breathe
    a4 h8. c16 h4 a a g h4. a8
    g4 f a4. g8 f4 e g4. \breathe e8 g4. f8 f4 d'
    c2. e,4 g4. f8 f4 h,
  }
  \alternative {
    {
      \set Score.repeatCommands = #(list (list 'volta voltaItalicOne) 'start-repeat)
      c2 h'2\rest \bar ":|."
    } {
      \set Score.repeatCommands = #(list (list 'volta #f) (list 'volta voltaItalicThree) 'end-repeat)
      c,1
    }
  }
  \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  c8 ( c ) c d e4 c d8. d16 d8 a'
  <<
    {
      %\once \override NoteColumn.force-hshift = #-1
      \stemDown  \override NoteHead.font-size = #smallerNoteHead

      g2
    }
    \\ {
      \stemDown  \override NoteHead.font-size = #smallerNoteHead
      \once \override NoteColumn.force-hshift = #1.5
      h4.
      %\once \override NoteColumn.force-hshift = #-2
      d,8
    }
  >>
  h8. h16 h8 c8 d4 d8 e g8. f16 e8. d16 c2
  f4 g8. a16 g4 f f e g4. f8
  e4 d f4. e8 d4 c e4. c8
  e4. d8 d4 f e2. c4 e4. d8 d4 f e2 s2
  \once \override NoteColumn.force-hshift = #0.2
  e1
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  c g:7 g:7 g f f2 g e:m d:m d:m c g d:m c1 c2 d:m c1 c
}
%% Text
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Unsere beide Schatten"
          "sah'n wie einer aus."
          "Dass wir so lieb uns hatten,"
          "das sah gleich man daraus."
          "Und alle Leute soll'n es seh'n,"
          "wenn wir bei der Laterne stehn"
          "|: wie einst, Lili Marleen. :| "
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Schon rief der Posten,"
          "sie blasen Zapfenstreich,"
          "es kann drei Tage kosten,"
          "Kam'rad, ich komme gleich."
          "Da sagten wir auf Wiederseh'n."
          "Wie gerne wollt' ich mit dir geh'n,"
          "|: mit dir, Lili Marleen'. :|"
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Deine Schritte kennt sie,"
          "deinen zieren Gang,"
          "alle Abend brennt sie,"
          "doch mich vergaß sie lang."
          "Und sollte mir ein Leids gescheh'n,"
          "Wer wird bei der Laterne stehn"
          "|: mit dir, Lili Marleen? :| "
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "Aus dem stillen Raume,"
          "aus der Erden Grund"
          "küsst mich wie im Traume"
          "dein verliebter Mund."
          "Wenn sich die späten Nebel drehn,"
          "werd' ich bei der Lanterne stehn"
          "|: wie einst, Lili Marlen'. :| "
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. "
  \set stanza = #"1. "
  Vor der Ka -- ser -- ne,
  vor dem gros -- sen Tor
  stand ei -- ne La -- ter -- ne
  und steht sie noch da -- vor,
  so woll'n wir da uns wie -- der seh'n
  bei der La -- ter -- ne wolln wir steh'n
  wie einst, Li -- li Mar -- leen,
  wie einst, Li -- li Mar -- leen.
  -leen.
}

\score
{
  <<
    \new Staff="leadsheet" \with {
    }
    <<
      \tocItem \markup #myTitel
      <<
        \context FirstVoice="melody" {
          #(ly:parser-include-string (string-append "\\\"m" myTitel "1\""))
        }
        \context SecondVoice="sndvoice"
        {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
      >>
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Hans Leip (1893-1983), 1915"
        "Melodie: Norbert Schultze (1911-2002), 1940"
      }
    }
    piece = ""
    opus = ""
  }

}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Lili Marleen
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Vom Barette schwankt die Feder
%%%%%%%% Anfang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myTitel="Vom Barette schwankt die Feder"
%% Voice 1
baretteMelody =
\relative c' {
  \key g \major
  \set Timing.beamExceptions = #'()
  d4 d g g h8 ( a ) g ( a ) h4 g
  g4. h8 a ( g ) fis ( g ) a4 a a r e e a a
  c8 ( h ) a ( h ) c4 a
  \slurDashed
  d4( d8 ) e\noBeam d4 c h a g \breathe d \bar "||"
  \slurSolid
  %% why not \repeat volta ...
  \bar ".|:"
  <<
    \context Voice = "voice" {
      \voiceOne
      g2 g
      h4^( a g fis ) e2 e
      %% Here some trickery
      a4-\tweak transparent ##t ^(\( h c) a\)
      h2 h4. h8 h4 c d h c^( d c d ) h2
    }
    \new Voice = "alt" {
      \set Voice.fontSize = #-2
      \voiceTwo
      g4 d g d
      g d
      g( d )
      e h
      e( h ) e
      h e ( fis )
      g2 g4. g8
      g4 a h g
      a( d, e fis) g2
    }
  >>
  \oneVoice r
  \bar ":|."
}

%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  d4 d d d d d d d
  d4. d8 d4 d4 fis4 fis fis s
  e e e e
  a8 ( g ) fis ( g ) a4 fis
  fis4 fis8 a a4 a g d d
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  g1 g g d a:m a:m d g g g e:m a:m g g d:7 g
}
%% Text
#(ly:parser-include-string (string-append "\"" myTitel "\"")) =
\markup {
  \fill-line {
    \hspace #0.1 % moves the column off the left margin;
    % can be removed if space on the page is tight
    \column {
      \line {
        \bold "2."
        \column {
          "Unsre Linke an dem Schwerte,"
          "in der Rechten einen Spieß,"
          "kämpfen wir, so weit die Erde,"
          "bald für das und bald für dies."
          "Ja |: dies und das, Suff und Fraß"
          "muß ein, ja muß ein""Landsknecht haben.:|"
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "Ruhm und Beute zu gewinnen,"
          "zieh'n wir mutig in die Schlacht;"
          "einmal müssen wir von hinnen"
          "lustig drum bei Tag und Nacht."
          "Bei |: Nacht und Tag, was er mag,"
          "muß ein, ja muß ein""Landsknecht haben.:|"
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "Landsknechtleben, lustig Leben,"
          "in der Schenk' bei Tag und Nacht!"
          "Sitzt ein fader Kerl daneben,"
          "der nicht singt und der nicht lacht."
          "Ja |: schmeißt in raus, reines Haus,"
          "muß ein, ja muß ein""Landsknecht haben! :|"
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "Sollte ich einst liegen bleiben"
          "in der blutdurchtränkten Schlacht,"
          "sollt ihr mir ein Kreuzlein schreiben"
          "über dem tiefen, dunklen Schacht."
          "Mit |: Trommelspiel, Pfeifen viel"
          "sollt ihr mich begraben.:|"
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
baretteLyrics = \lyricmode {
  \set stanza = #"1. "
  Vom Ba -- ret -- te schwankt -- die -- Fe --  der,
  wiegt und biegt -- im -- Win -- de sich.
  Un -- ser Wams von Büf -- fel -- le -- der
  ist   zer -- fetzt von
  Hieb und Stich.
  Ja
  %% Here some trickery
  %% send this to another Lyrics-context
  \context Lyrics = "up" {
    Stich und Hieb __  und ein Lieb __
  }
  \skip 1 muß ein, ja muß ein Lands -- knecht ha --  ben.
}

altLyr = \lyricmode {
  Stich und Hieb und Stich und Hieb __ und ein Lieb __ und ein Lieb __
}

\score
{
  <<
    \new Staff = "leadsheet"

    <<
      \tocItem \markup #myTitel
      \new FirstVoice = "voice" \baretteMelody
      \context SecondVoice="sndvoice"
      {  #(ly:parser-include-string (string-append "\\\"m" myTitel "2\"")) }
    >>
    \new Lyrics = "up" \with {
      alignAboveContext = #"leadsheet"
      % lyrics above a staff should have this override
      \override VerticalAxisGroup.staff-affinity = #DOWN
    }
    \lyricsto "voice" { \repeat unfold 37 \skip 1  }

    \new Lyrics = "down" \lyricsto "voice" \baretteLyrics

    \new Lyrics = "alt" \with { fontSize = #-1 } \lyricsto "alt" \altLyr
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = ""
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Volkslied"
        "Melodie: Volksweise"
      }
    }
    piece = ""
    opus = ""
  }
}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Lied Vom Barette schwankt die Feder
%%%%%%%% Ende
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\include "Fortsetzung-01.ly"
