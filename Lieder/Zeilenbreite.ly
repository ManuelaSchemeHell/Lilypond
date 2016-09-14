\paper {
  #(set-paper-size "a4")
  indent = #0
  ragged-right = ##f
 line-width = 120\mm

 % check-consistency = ##t
}
\score {
  \relative c'' { \repeat unfold 40 c4 }
  \layout {
    line-width = 150\mm
    short-indent = -15\mm
    indent = -15\mm
    ragged-right = ##f
  }
}
\markup 
\line \override #'(line-width . 30)
{ \fill-with-pattern #1 #RIGHT . 30 right }
\markup  \line
{ \override #'(line-width . 50)
\fill-with-pattern #1 #RIGHT . 50 right
}

\header {
  title = "My title"
  myText = "Lorem ipsum dolor sit amet, consectetur adipisicing
    elit, sed do eiusmod tempor incididunt ut labore et dolore magna
    aliqua.  Ut enim ad minim veniam, quis nostrud exercitation ullamco
    laboris nisi ut aliquip ex ea commodo consequat."
}

\paper {
  bookTitleMarkup = \markup {
    \column {
      \fill-line { \fromproperty #'header:title }
      \null
      \justify-field #'header:myText
    }
  }
}

\markup {
  \null
}

\markup
{ \hspace #10
      \override #'(line-width . 300) 
 
    \line {
      
      \column {
      
          "2. Ubi sunt qui ante nos"
          "in mundo fuere?"
          "vadite ad superos"
          "transite ad inferos"
          "ubi iam fuere."
      " "
          "3. Vita nostra brevis est,"
          "brevi finietur,"
          "venit mors velociter,"
          "rapit nos atrociter"
          "nemini parcetur!"  }
\column {
          "2. Sagt mir doch, wo trifft man an,"
          "Die vor uns gewesen?"
          "Schwingt euch auf zur Sternenbahn,"
          "Geht hinab zu Charons Kahn,"
          "Wo sie längst gewesen!"
          " "
          "3. Kurz ist unsre Lebenszeit,"
          "Sie vergeht geschwinde;"
          "Unter Sorgen, Müh’ und Streit"
          "Schwindet Jugend-Fröhlichkeit,"
          "Wie der Rauch vom Winde."
        
        }
      }
   } 
   
  
	
