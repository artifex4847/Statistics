ods html; 
ods listing close; 
ods graphics on; 
libname TS6 'c:\Library_timeseries';

Data figure65;
y=0;
y1=0;
do t=-50 to 100;
  if t=-50 then do;
      y=0.3*y+0.6*y1+normal(0);
      if t>0 then output;     
       end;
   else do;
    temp=y;
    y=0.3*y+0.6*y1+normal(0);
	y1=temp;
	if t>0 then output;
   end;
end;
run;

Proc gplot data=figure65; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'time plot of a simulated AR(2)';
   run;

Proc autoreg data=figure65;
           model y=t/dwprob;
           title;
run;







ods graphics off;
ods html close;
ods listing;
