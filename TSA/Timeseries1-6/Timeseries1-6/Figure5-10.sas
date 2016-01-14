ods html; 
ods listing close; 
ods graphics on; 
libname TS5 'c:\Library_timeseries';

Data TS5.figure510;
set TS5.figure58;
y=log(electricity);
diff1=y-lag(y);
run;

Proc gplot data=TS5.figure58; 
      symbol i=spline v=circle h=1; 
      title 'Time plot of electricity';
	  plot  electricity* t;
	  run;
Proc gplot data=TS5.figure510; 
      symbol i=spline v=circle h=1; 
      title 'Time plot of electricity after Box-Cox';
	  plot y * t;
	  run;
Proc gplot data=TS5.figure510; 
      symbol i=spline v=circle h=1; 
      title 'Time plot of difference after Box-Cox';
	  plot diff1 * t;
	  run;

Proc autoreg data=TS5.figure510;
  model y=t/dwprob normal;
  title;
run;

Proc autoreg data=TS5.figure510;
  model diff1=t/dwprob normal;
  title;
run;

ods graphics off;
ods html close;
ods listing;
