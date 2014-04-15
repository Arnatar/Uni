% draw(Size)
% draws a graphics with a given Size

draw(Size) :-
   % prepare a Display to draw the object on
   % generate a new display name
   gensym(w,Display),
   free('@'Display),
   % define size of the display (picture size + scroll bar area)
   SizeD is Size,
   % create a new display and open it
   new('@'Display,picture('*** Your picture''s name ***',size(SizeD,SizeD))),
   send('@'Display,open),
   send('@'Display,background,colour(grey)), %* MK: ggf. Farbe auf 'white' stellen

   % Haesslichster Andy der Welt:
   % Head
   new('@'Headc,circle(100)),
   send('@'Headc,colour(green)),
   send('@'Headc,fill_pattern(green)),
   send('@'Display,display,'@'Headc,point(150,90)),
   new('@'Headb,box(100,20)),
   send('@'Headb,colour(grey)),
   send('@'Headb,fill_pattern(grey)),
   send('@'Display,display,'@'Headb,point(150,140)),

   % Eyes
   new('@'LEye,circle(10)),
   send('@'LEye,colour(white)),
   send('@'LEye,fill_pattern(white)),
   send('@'Display,display,'@'LEye,point(175,115)),
   new('@'REye,circle(10)),
   send('@'REye,colour(white)),
   send('@'REye,fill_pattern(white)),
   send('@'Display,display,'@'REye,point(215,115)),

   % Antenas
   new('@'LAnt,ellipse(10,30)),
   send('@'LAnt,colour(green)),
   send('@'LAnt,fill_pattern(green)),
   send('@'Display,display,'@'LAnt,point(175,80)),
   new('@'RAnt,ellipse(10,30)),
   send('@'RAnt,colour(green)),
   send('@'RAnt,fill_pattern(green)),
   send('@'Display,display,'@'RAnt,point(215,80)),

   % Legs
   new('@'RLeg,ellipse(20,100)),
   send('@'RLeg,colour(green)),
   send('@'RLeg,fill_pattern(green)),
   send('@'Display,display,'@'RLeg,point(170,200)),
   new('@'LLeg,ellipse(20,100)),
   send('@'LLeg,colour(green)),
   send('@'LLeg,fill_pattern(green)),
   send('@'Display,display,'@'LLeg,point(210,200)),

   % Body
   new('@'Body,box(100,100)),
   send('@'Body,colour(green)),
   send('@'Body,fill_pattern(green)),
   send('@'Display,display,'@'Body,point(150,150)),

   % Arms
   new('@'RArm,ellipse(20,100)),
   send('@'RArm,colour(green)),
   send('@'RArm,fill_pattern(green)),
   send('@'Display,display,'@'RArm,point(255,150)),
   new('@'LArm,ellipse(20,100)),
   send('@'LArm,colour(green)),
   send('@'LArm,fill_pattern(green)),
   send('@'Display,display,'@'LArm,point(125,150)),



   % draw the object on the display
   (
        draw_object('@'Display,Size,Size /* , ***add additional parameters if needed *** */);
        true
   )
   /*
   % if desired save the display as .jpg
   write_ln('Save the graphics (y/n): '),
   get_single_char(A),
   put_code(A),nl,
   (A=:=121 ->
     (write_ln('enter file name: '),
      read_line_to_codes(user_input,X),
      atom_codes(File,X),
      atom_concat(File,'.jpg',FileName),
      get('@'Display,image,Image),
      send(Image,save,FileName,jpeg) ) ; true ),

   ! */
   .


% draw_object(Display,Size,CurrentSize,*** add additional parameters here, if needed ***)
% draws a gradient graphics of size Size into Display
% CurrentSize is decreased recursively fom Size to 0
draw_object(_,_,0 /* , *** add additional parameters here, if needed *** */).
draw_object(Name,Size,CSize /* , *** add additional parameters here, if needed *** */) :-
   CSize > 0 ,        % only for positive integers

  % *** insert the computation of graphical parameters here ***

  % *** create and draw the current graphical object here ***

  % *** send all additional parameters to the current graphical object ***

  % decrement CurrentSize and call draw_object recursively
  CSizeNew is CSize - 2,
% writeln(CSizeNew),
  draw_object(Name,Size,CSizeNew).



% Call the program and see the result
:- draw( 400 ).   % specify the desired display size in pixel here (required argument)




% ========== Tests from XPCE-guide Ch 5 ==========

% destroy objects
mkfree :-
   free(@p),
   free(@bo),
   free(@ci),
   free(@bm),
   free(@tx),
   free(@bz).

% create picture / window
mkp :-
   new( @p , picture('Demo Picture') ) ,
   send( @p , open ).

% generate objects in picture / window
mkbo :-
   send( @p , display , new(@bo,box(100,100)) ).
mkci :-
   send( @p , display , new(@ci,circle(50)) , point(25,25) ).
mkbm :-
   send( @p , display , new(@bm,bitmap('32x32/books.xpm')) , point(100,100) ).
mktx :-
   send( @p , display , new(@tx,text('Hello')) , point(120,50) ).
mkbz :-
   send( @p , display , new(@bz,bezier_curve(
	 point(50,100),point(120,132),point(50,160),point(120,200))) ).

% modify objects
mkboc :-
   send( @bo , radius , 10 ).
mkcic :-
   send( @ci , fill_pattern , colour(orange) ).
mktxc :-
   send( @tx , font , font(times,bold,18) ).
mkbzc :-
   send( @bz , arrows , both ).


