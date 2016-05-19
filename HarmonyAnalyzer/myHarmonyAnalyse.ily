#(define (music-elts x)
   (if (not (ly:music? x))
       #()
       (ly:music-property x 'elements)))

#(define (music-name x)
   (if (not (ly:music? x))
       #f
       (ly:music-property x 'name)))

#(define (pitch-equals? p1 p2)
   (and
    (= (ly:pitch-alteration p1) (ly:pitch-alteration p2))
    (= (ly:pitch-notename p1) (ly:pitch-notename p2))))

#(define remove-unnecessary-alterations
   (lambda (plis)
     (cond
      ;; wir haben fertig
      ((null? plis) '())
      (else (cons (ly:make-pitch 0
                    (ly:pitch-notename (car plis))
                    (ly:pitch-alteration (car plis)))
              (remove-unnecessary-alterations (cdr plis)))

        ))))

#(define remove-double-pitches
   ;; wir entfernen aus der sortierten und gebügelten Liste doppelte Einträge
   (lambda (plis)
     (cond
      ;; wir haben fertig
      ;; wenn kein Schwanz mehr vorhanden ist
      ((null? (cdr plis)) plis)
      (else
       (cond
        ((eq? (car plis) (cadr plis))
         (remove-double-pitches (cdr plis)))
        (else
         (cons (car plis) (remove-double-pitches (cdr plis))
           )))))))

#(define wer-are-done-now
   (lambda (music)
     (cond
      ;; das dient nur dazu, um Fehler abzufangen
      ;; von nix kommt nix ;-)
      ((null? music) '())
      ;; keine MusiK?
      ;; dann retournieren wir den Input
      ((not (ly:music? music)) music)
      (else
       (remove-double-pitches (sort (remove-unnecessary-alterations (music-pitches music) ) ly:pitch<?) )
       ))))

#(define (naturalize-pitch p)
   (let ((o (ly:pitch-octave p))
         (a (* 4 (ly:pitch-alteration p)))
         ;; alteration, a, in quarter tone steps,
         ;; for historical reasons
         (n (ly:pitch-notename p)))
     (cond
      ((and (> a 1)
            (or (eq? n 6)
                (eq? n 2)))
       (set! a (- a 2))
       (set! n (+ n 1)))
      ((and (< a -1)
            (or (eq? n 0) (eq? n 3)))
       (set! a (+ a 2))
       (set! n (- n 1))))
     (cond
      ((> a 2) (set! a (- a 4)) (set! n (+ n 1)))
      ((< a -2) (set! a (+ a 4)) (set! n (- n 1))))
     (ly:make-pitch 0 n (/ a 4))))

#(define (all-pitches-from-music music)
   "Return a list of all pitches from @var{music}."
   ;; Opencoded for efficiency.
   (reverse!
    (let loop ((music music) (pitches '()))
      (let ((p  (ly:music-property music 'pitch)))
        (if (ly:pitch? p)
            (cons (naturalize-pitch p) pitches)
            (let ((elt (ly:music-property music 'element)))
              (fold loop
                (if (ly:music? elt)
                    (loop elt pitches)
                    pitches)
                (ly:music-property music 'elements))))))))

#(define make-pitchlist-from-musiclist
   ;; wir erschaffen eine Pitchliste aus der Musikliste
   (lambda (ls)
     (cond
      ;; wir haben fertig, wenn Liste leer ist
      ((null? ls) '())

      ;; wenn das Listenelement ein gültiger Musikausdruck ist
      ;; dann fügen wir die sortierte Pitchliste als Listenelement hinzu
      ((ly:music? (car ls))
       (cons (sort (all-pitches-from-music (car ls) ) ly:pitch<?)
         ;(cons (car l2) (vvv l1 (cdr l2)))
         (make-pitchlist-from-musiclist (cdr ls)))
       )
      ;; ansonsten machen wir mit dem Rest der Liste weiter
      (else (make-pitchlist-from-musiclist (cdr ls)))
      )
     )
   )

#(define is-in?
   ;; wir versuchen zu eruieren
   ;; ob alle Elemente der Liste l1 in l2 enthalten sind
   ;; genauer gesagt müssen nur notename und alteration stimmen
   ;; die Oktavlage interessiert uns nicht
   (lambda ( l1 l2 )
     ( cond
       ;; zunächst prüfen wir, ob die Testliste bereits erschöpft ist
       ;; wenn ja dann ist es wahr
       ((null? l1) #t
         )
       ;; wenn die Zielliste erschöpft ist
       ;; ist es falsch
       ((null? l2) #f
         )
       ;; wir überprüfen das erste Element der Testliste
       ;; wenn es gleich dem ersten Element der Zielliste ist
       ;; dann können wir mit dem restlichen Teil der Testliste fortsetzen
       ((pitch-equals? (car l1) (car l2))
        (is-in? (cdr l1) l2)
        ;'equalPitch
        )
       ;; ansonsten versuchen wir es mit dem folgenden Element der Zielliste
       (else (is-in? l1 (cdr l2))
         )
       )
     )
   )

#(define make-chord-list
   ;; wir wollen jetzt die Musikausdrücke in eine Liste hängen
   ;; l1 ist unsere Testliste
   ;; l2 enthält die Pitches
   ;; l3 enthält die Musik

   (lambda (l1 l2 l3)
     ( cond
       ;; wenn die Akkordliste leer ist, dann verabschieden wir uns
       ((null? l2) '()
         )
       ;; wenn die Testliste leer ist, dann ist es auch aus
       ((null? l1) '() )
       ;; wenn die Noten der Testliste im ersten Akkord enthalten sind,
       ;; wird der Akkord hinzugefügt
       ((is-in? l1 (car l2))
        (cons (car l3) (make-chord-list l1 (cdr l2) (cdr l3)))
        )
       ;; wenn die Noten von l1 nicht im ersten Akkord enthalten sind
       ;; machen wir mit der restlichen Akkordliste weiter
       (else (make-chord-list l1 (cdr l2) (cdr l3))
         )
       )
     )
   )

#(define make-scale-list
   ;; wir wollen jetzt die Musikausdrücke in eine Liste hängen
   ;; l1 ist unsere Tonleiter
   ;; l2 enthält die Liste der Akkorde
   ;; wenn ein Akkord aus l2 in der Tonleiter enthalten ist, wird car l3 zur Ergebnisliste hinzugefügt
   ;; l3 enthält die Musik

   (lambda (l1 l2 l3)
     ( cond
       ;; wenn die Akkordliste leer ist, dann verabschieden wir uns
       ((null? l2) '()
         )
       ;; wenn die Testliste leer ist, dann ist es auch aus
       ((null? l1) '() )
       ;; wenn die Noten der Liste l1 im ersten Akkord der Liste l2 enthalten sind,
       ;; wird der Akkord hinzugefügt
       ((is-in? (car l2) l1)
        (cons (car l3) (make-scale-list l1 (cdr l2) (cdr l3)))
        )
       ;; wenn die Noten von l1 nicht im ersten Akkord enthalten sind
       ;; machen wir mit der restlichen Akkordliste weiter
       (else (make-scale-list l1 (cdr l2) (cdr l3))
         )
       )

     )
   )

%% Liste der transponierten AKkorde
%% in zwei Stufen
%% die innere Funktion durchläuft die Akkordliste
%% die äußere die Tonleiterliste
%% das hat den Sinn, dass ich die Liste der Akkorde insgesamt transponieren will
%% und nicht jeden Akkord transponiere

#(define ( chords-in-all-scales Pitch Musik)
   (append-map
    (lambda (p)
      (map
       (lambda (music)
         #{ { \transpose c $p $music } #})
       Musik
       )
      )
    (event-chord-pitches Pitch)
    )
   )

#(define  (list-all-chords-from-music music)
   "Return a list of all Chords from @var{music}."
   (reverse!
    (let loop ((music music) (pitches '()))
      (let ((p  (music-name music)))
        (if (eq? p 'EventChord)
            (cons  music pitches)
            (let ((elt (ly:music-property music 'element)))
              (fold loop
                (if (ly:music? elt)
                    (loop elt pitches)
                    pitches)
                (music-elts music))))))))

#(define  (display-music-tree music)
   "arbeitet alle Zweige einer Musikdefinition durch @var{music}."
   (reverse!
    (let loop ((music music) (pitches '()))
      (let ((p  (music-name music)))
        ;#!#
        (write (string-append
                "\n(eq? p 'EventChord): " (format "~a" p)
                ))  ;#!#
        (if (eq? p 'EventChord)
            (cons  music pitches)
            (let ((elt (ly:music-property music 'element)))
              (fold loop
                (if (ly:music? elt)
                    (loop elt pitches)
                    pitches)
                (music-elts music))))))))

%% und jetzt das Ergebnis aller Mühen

%{
   ;; Input ist der Musikausdruck, der analysiert werden soll
   ;; Akkordliste eine Liste von Akkorden, mit denen der Input abgeglichen werden soll
   ;; Tonarten enthält eine Liste von Pitches, in die Akkorde transponiert werden sollen

   ;; wir ziehen die Pitches raus
   ;; normieren sie und sortieren sowie Entfernen doppelte
   ;;(define myInput (fixfertig Input))

   ;; jetzt müssen wir die Akkordliste analysieren

   ;(define ChordListe (list-all-chords-from-music Akkordliste))

   ;; wir transponieren die Akkordliste in alle Tonarten
   ;;(define MusikListe (chords-in-all-scales Tonarten (list-all-chords-from-music Akkordliste))

   ;; wir machen aus unserer Liste der Akkorde eine Liste von Pitches zwecks Vergleichsmöglichkeit
   ;;(define PitLis (mk-pitch MusikListe))

   ;; das funktioniert nur, wenn alles ineinandergeschachtelt wird
%}

PitchesInChords =
#(define-music-function (Input Akkordliste Tonarten)
   (ly:music? ly:music? ly:music?)
   (make-sequential-music
    (make-chord-list
     (wer-are-done-now Input)
     (make-pitchlist-from-musiclist (chords-in-all-scales Tonarten (list-all-chords-from-music Akkordliste)))
     (chords-in-all-scales Tonarten (list-all-chords-from-music Akkordliste) ))
    )
   )

ScalesContainingChordNotes=
#(define-music-function (mychords myscales mypitches)
   (ly:music? ly:music? ly:music?)
   (make-sequential-music
    (map
     (lambda (m)
       #{
         \mark \markup "these Scales contain all Notes from the Input" \grace s32^\markup "Input Chord" $m
         \PitchesInChords $m $myscales $mypitches   \bar "|." \break
       #})
     (list-all-chords-from-music mychords))))

ChordsInScale =
#(define-music-function (mychords myscale)
   (ly:music? ly:music?)
   (make-sequential-music
    (make-scale-list
     (wer-are-done-now myscale)
     (make-pitchlist-from-musiclist (list-all-chords-from-music mychords))
     (list-all-chords-from-music mychords) )
    )
   )
