\version "2.19.37"
\language "deutsch"
Absatz=#0.5
smallerNoteHead= #-1.5
KommSingMit=\markup { \italic "Komm sing mit 2" }
%myFont=#"MS Mincho"
myFont=#"TeX Gyre Heros"
%myFont=#"Oranda BT"
%myFont=#"Palatino Linotype"
%myFont=#"Cambria Math"
%myFont=#"Georgia"
%myFont=#"DejaVu Serif"
%myFont=#"Monospac821 BT"

#(set-global-staff-size 18)

FootLeft = #(string-append "" )
FootCenter = #(string-append "")
FootLeft = #(string-append "gesetzt mit LILYPOND " (lilypond-version) " am " (strftime "%d.%m.%Y %H:%M:%S" (localtime (current-time))))
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
  }
  \context {
    \Score
    %\remove Bar_number_engraver
    \remove System_start_delimiter_engraver
    \override RehearsalMark.self-alignment-X = #LEFT
    \override RehearsalMark.outside-staff-priority=##f
    \override RehearsalMark.extra-offset = #'(-3 . 4)
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
  g4  c,4. e8 e4. g8
  g2. g4
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
    composer = "Volkslied"
    piece = ""
    opus = ""
  }

}
\markup \vspace #(* Absatz -1)
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)

myTitel="Wem Gott will rechte Gunst erweisen"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \partial 4
  c4 e g c8. h16 c8 a g2 e4 g
  f8. e16 f8 d e4 c d2 h'4\rest d,8 [ e ]
  f4. f8 e8. e16 f8 g a2 g4 g c8. h16 c8 d e4 d c2 h4\rest \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  \partial 4
  c4 e g a8. g16 a8 f e2 c4 e
  d8. c16 d8 h c4 c h2 s4 h8 [ c ]
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
      \new Lyrics \with {
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
      \new Lyrics \with {
        \override LyricText.font-series = #'italic
        %   alignBelowContext = "leadsheet"
      } \lyricsto "melody" {
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


myTitel="Der Mai ist gekommen"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c' {
  \time 3/4 \partial 4
  c8 ( [ d ] ) e4 e4. f8 a8 ( [ g ] ) g4. e8 g8 f f4 g e2 \bar "|"
  c8 ( [ d ] ) e4 e4. f8 a8 ( [ g ] ) g4. e8 g8 ( f ) f4 g e2 \bar "."
  e8 e d8 [ ( g ] ) g4. g8 fis8 [ ( a ] ) a4. a8 d8. ([ c16 ]) h8.( [ a16 ]) g8.( [ fis16 ])
  g2 g8 ([ f ]) e8. e16 e4. f8
  a4 g4. e8 g8. f16 f4 g e2 \bar "|."
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  \partial 4
  c8 [ d ] c4 c4. c8 f8 [ e ]  e4. c8 d8 d d4 < f d> c2 \bar "|"
  c8  [ d ]  e4 e4. f8 a8  [ g ]  g4. e8 g8 ( f ) f4 g e2 \bar "."
  e8 e d8 [  d ]  d4. d8 d8 [  fis ]  fis4. a8 d8. [ c16 ] h8. [ a16 ] g8. [ fis16 ] g2 g8 [ f ] e8. e16 e4. f8
  a4 g4. e8 g8. f16 f4 g e2
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  s4 c2 f4 f/c c2 d4:m g g:7 c2
}
%% Lyrics
#(ly:parser-include-string (string-append "\"" myTitel "\"")) = \markup
{
  \hspace #5
  \override #'(line-width . 85)
  \left-column
  {
    "Frisch auf drum, frisch auf drum im hellen Sonnenstrahl"
    "wohl über die Berge, wohl durch das tiefe Tal."
    "Die Quellen erklingen, die Bäume rauschen all;"
    "mein Herz ist wie ’ne Lerche und stimmet ein mit Schall."
    \vspace #Absatz
    "Und abends im Städtlein, da kehr ich durstig ein:"
    "Herr Wirt, eine Kanne, eine Kanne blanken Wein!"
    "Ergreife die Fiedel, du lust’ger Spielmann du,"
    "von meinem Schatz das Liedel, das sing ich dazu."
    \vspace #Absatz
    "Und find ich keine Herberg, so lieg ich zu Nacht"
    "wohl unter blauem Himmel, die Sterne halten Wacht."
    "Im Winde die Linde, die rauscht mich ein gemach,"
    "es küsset in der Frühe das Morgenrot mich wach."
    \vspace #Absatz
    "O Wandern, o wandern, du freie Burschenlust!"
    "Da weht Gottes Odem so frisch in die Brust,"
    "da singet und jauchzet das Herz zum Himmelszelt:"
    "wie bist du doch so schön, du weite, weite Welt!"
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
  Es gibt so man -- che Stras -- se, da nimmer ich marschiert,
  es gibt so man -- chen Wein, den ich nim -- mer noch pro -- biert.
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
        #(ly:parser-include-string (string-append "\\\"l" myTitel "1\""))
      }
      \new Lyrics \lyricsto "melody" {
        #(ly:parser-include-string (string-append "\\\"l" myTitel "2\""))
      }
    >>
    \context ChordNames
    { #(ly:parser-include-string (string-append "\\\"c" myTitel "\"")) }
  >>
  \header {
    title = #myTitel
    poet = "aus Tirol"
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

\markuplist {
  \rparagraph {
    "2. Ach Reiter, lieber Reitersmann,"
    "laß doch die Lilien stehn,"
  }
  \column-lines {
    "2. Ach Reiter, lieber Reitersmann,"
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

myTitel="LiedTitel1"
%% Voice 1
#(ly:parser-include-string (string-append "\"m" myTitel "1\"")) =
\relative c'' {
  c
}
%% Voice 2
#(ly:parser-include-string (string-append "\"m" myTitel "2\"")) =
\relative c' {
  c
}
%% Chords
#(ly:parser-include-string (string-append "\"c" myTitel "\"")) =
\chordmode {
  c
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
          "This is verse two."
          "It has two lines."
        }
      }
      \vspace #Absatz
      \line {
        \bold "3."
        \column {
          "This is verse three."
          "It has two lines."
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line {
        \bold "4."
        \column {
          "This is verse four."
          "It has two lines."
        }
      }
      \vspace #Absatz
      \line {
        \bold "5."
        \column {
          "This is verse five."
          "It has two lines."
        }
      }
    }
    \hspace #0.1 % gives some extra space on the right margin;
    % can be removed if page space is tight
  }
}

%% Song Lyrics
#(ly:parser-include-string (string-append "\"l" myTitel "\"")) = \lyricmode {
  \set stanza = #"1. " ca
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
    poet = "aus Tirol"
    composer = \markup {
      \override #'(baseline-skip . 1)
      \right-column {
        "Text: Christian Wilhelm Kindleben (1748-1786), Halle 1781"
        "Deutscher Text: Johann Christian Günther (1695-1723), 1717"
        "Melodie: Studentenlied, ursprünglich mittelalterliches Bußlied, 1788"
      }
    }
    piece = #KommSingMit
    opus = "S. 294"
  }

}
\markup \vspace #(* Absatz 2)
%% Songtext
#(ly:parser-include-string (string-append "\\\"" myTitel "\""))
\markup \vspace #(* Absatz 3)
