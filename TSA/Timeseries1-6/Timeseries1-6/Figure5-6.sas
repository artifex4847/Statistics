ods html; 
ods listing close; 
ods graphics on; 
Data figure56;
y=0;
y1=0;
e1=0;
e2=0;
do t=1 to 200;
    if t=1 then do;
        e=normal(0);
        y=2*y-1*y1+e-0.3*e1+0.3*e2;
        if t>100 then output;
        end;
   else if t=2 then do;
       temp=y;
	   e1=e;
	   e=normal(0);
       y=2*y-1*y1+e-0.3*e1+0.3*e2;
       y1=temp;
       diff1=y-y1;
	   if t>100 then
       output;        
        end;
		else do;
         temp=y;
         e2=e1;
         e1=e;
	     e=normal(0);
         y=2*y-1*y1+e-0.3*e1+0.3*e2;
         y1=temp;
         diff1=y-y1;
		 diff2=y-2*y1+lag(y1);
         if t>100 then output;        
		end;
 end;
drop temp;
run;

Proc gplot data=figure56; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Time plot of IMA(2,2)';
   run;

Proc autoreg data=figure56;
 model y=t/dw=12 dwprob;
 title;
run;

Proc gplot data=figure56; 
     symbol i=join v=circle h=1; 
      plot diff1 * t;
      title 'Time plot of 1st difference';
   run;

Proc autoreg data=figure56;
  model diff1=t/dw=12 dwprob;
  title;
  run;

Proc gplot data=figure56; 
     symbol i=spline v=circle h=1.5; 
      plot diff2 * t;
      title 'Time plot of 2nd difference';
   run;

Proc autoreg data=figure56;
  model diff2=t/dw=12 dwprob;
  title;
 run;

ods graphics off;
ods html close;
ods listing;
