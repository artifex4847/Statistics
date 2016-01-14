ods html; 
ods listing close; 
ods graphics on; 
libname TS2 'c:\Library_timeseries';

Data figure54;
y=0;
y1=0;
do t=-50 to 100;
    if t=-50 then do;
        y=1.7*y-0.7*y1+normal(0);
		if t>0 then
        output;
        end;
   else do;
         temp=y;
         y=1.7*y-0.7*y1+normal(0);
         y1=temp;
         diff1=y-y1;
		 if t>0 then
         output;        
		end;
end;
drop temp;
run;
Proc gplot data=figure54; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Time plot of Y=1.7Y1-0.7Y2+e';
   run;
      symbol i=spline v=circle h=1.5; 
      plot diff1 * t;
      title 'Time plot of difference';
   run;

proc autoreg data=figure54;
 m1: model y=t/dw=12 dwprob;
 m2: model diff1=t/dw=12 dwprob;
 run;

ods graphics off;
ods html close;
ods listing;
