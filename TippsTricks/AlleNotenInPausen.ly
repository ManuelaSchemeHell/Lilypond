%% gleichzeitig verschwinden alle sonstigen Zutaten (Fingering etc)

toRestII =
#(define-music-function (mus) (ly:music?)
   (music-map
     (lambda (m)
       (if (music-is-of-type? m 'note-event)
           #{ r $(ly:music-property m 'duration) #}
           m))
     mus))
     
%% r kann ich durch jede beliebige Note ersetzen, dann kriege ich nur eine Tonhöhe raus
TestMusik=relative c' { c4\sfz <d f>2\< e8-3\> f16\! }
%\displayMusic
\toRestII \TestMusik

%% Nur Noten

nurMusic =
#(define-music-function (parser location music) (ly:music? )
   (music-map
    (lambda (m)
      (case (ly:music-property m 'name)
        ((NoteEvent RestEvent MultiMeasureRestMusic)
         (ly:music-set-property! m 'articulations '()))
        ((EventChord)
         (ly:music-set-property! m 'articulations '())
         (ly:music-set-property! m 'elements
           (filter
            (lambda (e)
              (not (eq? 'TextScriptEvent (ly:music-property e 'name))))
            (ly:music-property m 'elements)))))
      m)
    music))

\TestMusik
\nurMusic \TestMusik
