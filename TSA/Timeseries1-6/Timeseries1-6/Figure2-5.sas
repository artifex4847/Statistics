ods html; 
ods listing close; 
ods graphics on; 
libname TS2 'c:\Library_timeseries';
Data figure25;

y=0;
a=-0.9; 

do t=-50 to 100;

y=a*y+normal(0);

if t > 0 then output;        

end;
run;
Proc gplot data=figure25; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title '1st simulated realization of the AR model Y(t)=0.7Y(t-1)+e(t)';
   run;
ods graphics off;
ods html close;
ods listing;
