\version "2.19.37"

ghostRH= {
  \override DynamicLineSpanner.staff-padding = #4
  \override TextScript.staff-padding = #5
  %s16\mp s16*3 s16*4 s16\< s16*3 s s s\mf s16*2 s\> s16*4
  s16 s16-1\mp s-2 s-3 s16*4 s16\< s16*3 s16*4
  s16 s-1\mf s-4 s s16*4 s16*4 s16\> s16*3 \bar "||"
  \mark \markup \box "A"
  s4\pdolce s2 s1*3/16 s16
  s4 s ~ s16 s16*3 s16\< s16*3
  s4\mp s4 s4\> s1*3/16 s16
  s1\p
  s4\mp s2 s1*3/16 s16
  s4 s ~ s16\< s s s s s s s
  s4\mf s4 s4\> s1*3/16 s16
  s1\mp \bar "||"
  \mark \markup \box "B"
  s16 %\vspace #1
  \once \override Slur.positions = #'(2 . 2)
  s-1\mp ( s16-3-5 s16 s16 s16 s16 s16)
  s
  %\offsetPositions #'(0 . 3)
  s-( s16 s16 s16 s16 s16-3-5 s16-1 )
  s4-2-5 s8-1-4 s8-3 s32-2-5\< ( s32-4 s-3 s-2 s16-1 s-5 )
  s4-1-2 s16 s\f\> ( s16 s16 s16 s16\mf s16 s16)
  s s-( s16 s16 s16 s16 s16 s16)
  s4 s8 s16 s16 ~ s16 s s s ~ s s s s
  % für die 32-stel
  s32-1->( s-2 s-4 s-5 s-> s s s
  s-1-> s-2 s-3 s-5 s-> s s s
  s-1->-\markup { \bold \italic \fontsize #-0.3 ritardando } s-2 s-4 s-5 s-> s s s
  s-1-> s-2 s-3 s-5 s-> s s s
  \time 2/4 \bar "||"
  \ottava #1
  s-1\f->\<-\markup { \bold \italic \fontsize #-0.3 ritardando } s-2 s-4 s-5 s-> s s s
  s-1-> s-2 s-3 s-5 s-> s s s)
  \time 4/4 \bar "||"
  \mark \markup \box "C"
  s4->\ff s2->-\markup { \italic \fontsize #0.2 "a tempo" } s1*3/16->[ s16->]
  s4 s ~ s16 s s s s s s s
  s4 s2 s1*3/16\mp ([ s16]  s4) s16\f s s s s\< s s s s16 s16 s8
  s4\ff-> s~ s16 s16 s s s s s s
  s4-> s~ s16 s16 s s s s s s
  s4->\mf s4 s4\> s1*3/16-\p[ s16]
  s1
  \ottava #0
  \mark \markup \box "D"
  s16 s\mp-( s16 s16 s16 s16 s16 s16) s
  s-( s16 s16 s16 s16 s16 s16) s4 s8 s16 s ~ s
  \tuplet 3/2 { s32 s s } s16 s s4 s16
  s\mf\> ( s16 s16 s16 s16 s16\mp s16 ) s s ( s16 s16 s16 s16 s16 s16 )
  s1
  s32->\< ( s s s s-> s s s s-> s s s s-> s s s
  s->-\markup { \bold \italic \fontsize #-0.3 ritardando } s s s s-> s s s s-> s s s s-> s s s
  \time 2/4
  \ottava #1 s->\f\< s s-\markup { \bold \italic \fontsize #-0.3 ritardando } s s-> s s s s-> s s s s-> s s s)
  \time 4/4
  \mark \markup \box "E"
  s4->\ff s2->-\markup { \italic \fontsize #0.2 "a tempo" }  s1*3/16->\mp s16->
  s4 s ~ s16 s s s s s s s
  s4 s2 s1*3/16( s16
  s4) s16\f s s s\< s s s s s16 s16 s8
  s4->\ff s->~ s16-> s16-> s-> s-> s-> s-> s-> s->
  s4-> s->~ s16-> s16-> s-> s-> s-> s-> s-> s->
  s4->\mf s4 s4\> s1*3/16\p ( s16
  \ottava #0 \ottava #1 s2 ) s16\< s s s s s s s
  \mark \markup \box "F"
  s4->\ff s->~ s16 s16-> s-> s-> s-> s-> s-> s->
  s4-> s->~ s16 s16-> ->s s-> s-> s-> s-> s->
  s4\mf s4 s4\> s1*3/16\mp ( s16
  s2\> ) s16\p s s s s s s s s2 s16 s-\markup { \bold \italic \fontsize #-0.3 ritardando } s s s s s s
  \ottava #0 \override NoteColumn.force-hshift = #0.2
  s1%\arpeggio
}

ghostLH=
{
  \set Timinging . baseMoment = #(ly:make-moment 1/4)
  \set Staff . beatStructure = #'(2 2)
  s4 s s s
  << { s s s s } \\ { s1 } >>
  s8 s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s
  s8[ s8] s s s s s s s s s16( s s s) s[( s s s)] s4 ~ s16 s s16 s s8 s8 s s s s s s s16[ s s s] s s s s ~ s4 s
  \set Timing . baseMoment = #(ly:make-moment 1/4)
  \set Staff . beatStructure = #'(2 2)
  s8 s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s4 s s8. s16 s8( s8 s s) s( s s s) s8( s8 s s) s( s s s) s( s s s s s) s4 s8 s s s s s s s s s s s s s s s s16( s s s) s[( s s s)] s8-> s-> s16( s s s) s8 s8 s s s s s s s4 s s16_( s
  \change Staff = "up" s s) \change Staff = "down" s_(
  \change Staff = "up" s s s) \change Staff = "down"
  s8 s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s s4 s s8. s16 s8( s8 s s) s( s s s) s8( s8 s s) s( s s s) s( s s s s s) s4 s8( s s s) s4-- s-- s8( s8 s s) s( s s s) s8( s8 s s) s( s s s) s( s s s s s) s4 s8( s s s) s4-- s-- s8( s s s) s4 s
  \change Staff = "up" s1\arpeggio
}
