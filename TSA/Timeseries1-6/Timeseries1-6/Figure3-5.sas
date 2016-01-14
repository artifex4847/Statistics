
ods html; 
ods listing close; 
ods graphics on; 
libname TS1 'c:\Library_timeseries';

Data aaa;
set TS1.example11_1;
delta=temperatureV-lag(temperatureV);
delta1=temperatureV-2*lag(temperatureV)+lag2(temperatureV);
run;

Proc gplot data=aaa; 
      symbol i=spline v=circle h=1.5;
      plot delta1 * t;
      title;
run;

Proc autoreg data=aaa;
model delta=t/dw=4 dwprob normal;
run;

Proc autoreg data=aaa;
model delta1=t/dw=4 dwprob normal;
run;

ods graphics off;
ods html close;
ods listing;





