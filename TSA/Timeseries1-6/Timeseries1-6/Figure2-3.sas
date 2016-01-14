ods html; 
ods listing close; 
ods graphics on; 
libname TS2 'c:\Library_timeseries';

Data figure23;
y=0;
theta=0.2;
do t=-50 to 100;
y=theta+y+normal(0);
if t>0 then output;        
end;

run;

Proc gplot data=figure23; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title '1st simulated realization of random walk with drift 0.1';
   run;


ods graphics off;
ods html close;
ods listing;
