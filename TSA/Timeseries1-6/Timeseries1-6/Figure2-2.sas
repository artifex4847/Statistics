ods html; 
ods listing close; 
ods graphics on; 
libname TS2 'c:\Library_timeseries';
Data figure22;
y1=0;
do t=-50 to 100;
y1=y1+normal(0);
if t>0 then output;       
end;
run;

Proc gplot data=figure22; 
      title 'scatter plot of a N(0,1) walk';
      symbol i=    v=circle h=1; 
	  plot y1 * t;
run;
      symbol i=spline v=circle h=1.5; 
      plot y1 * t;
      title '1st simulated realization of a N(0,1)walk';
run;
 
ods graphics off;
ods html close;
ods listing;
