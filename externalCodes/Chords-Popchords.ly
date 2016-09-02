%% https://lists.gnu.org/archive/html/lilypond-user/2009-02/msg00788.html

popChords =
{
  \set chordNameExceptions = #popChordsAdd
  \set chordRootNamer = #chord-name->pop-markup
  \override ChordName #'extra-spacing-width = #'(-1.25 . 1.25)
}

\version "2.8.2"
\include "pop-chords.ly"
\include "english.ly"           % English note names, for cryin' out loud...

% Good sizes are 16, 18, & 20
staffSize = #16
#(set-default-paper-size "letter")
#(set-global-staff-size staffSize)
#(ly:set-option (quote no-point-and-click))

\header
{
        title    = \markup { \override #'(font-family . sans) \fontsize #3.5 
"Pop Chords" }
        composer = \markup { \override #'(font-family . sans) \fontsize #1.3 
"Words & music by James \"Shamus\" Hammons" }
}

Chords = \chordmode
{
%Bah, can't we set this globally?
        \popChords

% Triads

        c1:^3
        c
        c:m
        c:sus2
        c:sus4
        c:aug
        c:dim

% Sharp/flat rendering

        fs:m
        ef:m

% Sixths

        c:6
        c:m6

% Sevenths, including altered

        c:7                             % Dominant seventh
        c:maj7                  % Major seventh
        c:m7                    % Minor seventh
        c:m7.5-                 % Minor seven flat 5
        c:dim7                  % Diminished seventh
        c:sus4.7                % Seven sus 4
        c:sus2.7                % Seven sus 2
        c:m7+                   % Minor major seventh
        c:aug7                  % Augmented seventh
        c:7.5-                  % Dominant seven flat 5
        cf:7+.5-                % Major seven flat 5
        cs:aug7+                % Augmented major seventh

% Ninths

        c:7.9                   % Dominant ninth
        c:m7.9                  % Minor ninth
        c:maj9                  % Major ninth
        c:5.9                   % Add nine
        c:6.9                   % Six/nine
        c:m6.9                  % Minor six/nine
        c:m7+9                  % Minor major 9
        c:7.9+                  % Dominant seventh sharp nine
        c:7.9-                  % Dominant seventh flat nine

% Elevenths

        c:11                    % Dominant eleventh
        c:m11                   % Minor eleventh
        c:maj11                 % Major eleventh
        c:5.11                  % Add eleven
        c:m5.11                 % Minor add eleven
        c:m7.11                 % Minor seventh add eleven

% Thirteenths

        c:13                    % Dominant thirteenth
        c:m7.9.13               % Minor thirteenth
        c:maj13                 % Major thirteenth
        c:5.13                  % Add thirteen

% Misc add chords

        c:7.9-.13-              % Seventh add b9/b13
        c:7.5+.9-               % Augmented seventh add b9
        c:maj9.11+              % Major ninth/#11
        c:9.11+                 % Dominant ninth/#11
}


\score
{
        <<
                \new ChordNames = "chords" \Chords
                \new Staff = "chordRhythm" \Chords
        >>
        \layout {
%               ragged-last-bottom = ##t
                ragged-last = ##t
        }
}

\paper
{
  #(define fonts (make-pango-font-tree
    "Times New Roman"
    "DomCasual BT"
    "Luxi Mono"
    (/ staffSize 20)))
}
