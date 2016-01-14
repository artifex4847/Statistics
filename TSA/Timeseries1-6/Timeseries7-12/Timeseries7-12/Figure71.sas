ods html; 
ods listing close; 
ods graphics on; 

/* Simulating AR(1) */

Data figure71_1;
y=0.9;
do t=-50 to 200;
e=rannor(23456);
y=0.7*y+e;
if t>0 then output; 
end;
run;

symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;
proc gplot;
plot y*t=1 y*t=2/overlay;£¨2¶ÔÓ¦symbol2µÄÃèÊö£©
title 'Simulated series of AR(1) with 0.7';
run;


Proc arima data=figure71_1;
   identify var=y esacf scan center minic stationarity=(adf=(0,1,2,3,4));
   run;
   estimate p=1 noconstant method=cls;
   run; 
 run;


/* simulating AR(2) */

Data figure71_2;
 y1=0; y2=0;
 do t=-50 to 200;
  e=rannor(23456);
   if t=-50 then do; 
     y=0.7*y1-0.5*y2+e;
     end;
	 else if t=-49 then do;
	      y1=y;
          y=0.7*y1-0.5*y2+e;   
	     end;
		 else do;
          y2=y1;
          y1=y;
          y=0.7*y1-0.5*y2+e;   
	     end;
		 if t>0 then output;
   end; 
 run;

symbol1 i=join c= v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot;
plot y*t=1 y*t=2/overlay;
title 'Simulated series of AR(2) with (.7,-.5)';
run;

proc arima data=figure71_2;
   identify var=y esacf center scan minic stationarity=(adf=(0,1,2,3,4));
  run;
   estimate p=2 noconstant method=cls;
 run;
/* Simulating AR(3)*/

Data figure71_3;
 y1=0; y2=0; y3=0;
 do t=-50 to 200;
  e=rannor(23456);
   if t=-50 then do; 
     y=0.7*y1-0.5*y2+0.4*y3+e;
     end;
	 else if t=-49 then do; 
	      y1=y;
          y=0.7*1-0.5*y2+0.4*y3+e;
	     end;
		 else if t=-48 then do; 
          y2=y1;
          y1=y;
          y=0.7*y1-0.5*y2+0.4*y3+e;
	     end;
		 else do;
		  y3=y2;
          y2=y1;
          y1=y;
          y=0.7*y1-0.5*y2+0.4*y3+e;
	     end;
		 if t>0 then output;
   end; 
 run;

symbol1 i=join c= v=circle h=1;
symbol2 i=r c=red v=none;

Proc gplot;
plot y*t=1 y*t=2/overlay;
title 'Simulated series of AR(3) with (.7,-.5,.4)';
run;

Proc arima data=figure71_3;
   identify var=y esacf scan center minic stationarity=(adf=(0,1,2,3,4));
   run;
   estimate p=3 noconstant method=cls;
   run;

   /*  simulating AR(4)*/

Data figure71_4;
 y1=0; y2=0; y3=0; y4=0;
 do t=-50 to 200;
  e=rannor(23456);
   if t=-50 then do; 
     y=0.7*y1-0.5*y2+0.4*y3-0.2*y4+e;
     end;
	 else if t=-49 then do; 
	      y1=y;
          y=0.7*y1-0.5*y2+0.4*y3-0.2*y4+e;
	     end;
         else if t=-48 then do; 
          y2=y1;
          y1=y;
          y=0.7*y1-0.5*y2+0.4*y3-0.2*y4+e;
	     end;
		 else if t=-47 then do;
          y3=y2;
          y2=y1;
          y1=y;
          y=0.7*y1-0.5*y2+0.4*y3-0.2*y4+e;
	     end;
		 else do;
          y4=y3;
          y3=y2;
          y2=y1;
          y1=y;
          y=0.7*y1-0.5*y2+0.4*y3-0.2*y4+e;
	     end;
		 if t>0 then output;
   end; 
 run;
 
symbol1 i=join c= v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot;
plot y*t=1 y*t=2/overlay;
title 'Simulated series of AR(4) with (.7,-.5,.4,-.2)';
run;

proc arima data=figure71_4;
   identify var=y esacf scan center minic stationarity=(adf=(0,1,2,3,4));
 run;
   estimate p=4 noconstant method=cls;
 run;
   estimate p=4 noconstant method=uls;
 run;
   estimate p=4 noconstant method=ml;
 run;


proc autoreg data=figure71_4;
 model y=/noint center nlag=6 dwprob dw=8 backstep method=ml;
 output out=resdat1_4 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a trend';
run;

ods graphics off;
ods html close;
ods listing;
