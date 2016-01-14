
ods listing close;
ods html; 
ods graphics on; 
libname TS1 'c:\Library_timeseries';

Data TS1.example11_3;

set TS1.example11_1;

difference=temperatureV-lag(temperatureV);

run;

Proc gplot data= TS1.example11_3; 
      symbol i=spline c=blue v=circle h=1.5;
      plot Difference * t;
      title 'Plot of global temperature difference';
   run;

proc reg data=TS1.example11_3;
model difference=t;
title 'Simple regression analysis on difference after 1900';
run;


ods graphics off;
ods html close;
ods listing;





