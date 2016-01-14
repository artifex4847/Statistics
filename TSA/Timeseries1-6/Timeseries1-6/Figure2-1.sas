ods html; 
ods listing close; 
ods graphics on; 
libname TS2 'c:\Library_timeseries';

data figure21;

do t=1 to 100;
y1=rand('lognormal');
output;
end;
run;
proc print data=figure21;
run;

proc gplot data=figure21;
title 'Times series plot';

symbol i=spline v=circle h=1;

plot y1*t;

run;

title 'Scatter plot from a realization of N(0,1)';
symbol i=   v=circle h=2;
plot y1*t;

run;



ods graphics off;
ods html close;
ods listing;


/*
rand('lognormal')
rand('T',3)
normal(1234)
rand('Cauchy')
rand('normal')
*/
