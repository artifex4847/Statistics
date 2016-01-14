
ods html; 
ods listing close; 
ods graphics on; 
libname TS1 'c:\Library_timeseries';

Data TS1.example11_5;
set TS1.example11_4;
if t=1900 then delete;
ddy=temperatureV-lag2(temperatureV);
run;

Proc gplot data= TS1.example11_5; 
      symbol i=spline v=circle h=1.5;
      plot ddy * t;
      title 'Plot of two-order difference';
   run;


ods graphics off;
ods html close;
ods listing;





