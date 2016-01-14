
ods html; 
ods listing close; 
ods graphics on; 
libname TS1 'c:\Library_timeseries';

proc autoreg data=TS1.example11_1;
   model temperatureV=t/ dw=12 dwprob normal;
   title'autoregression DW test for global temperature data';
run; 

/*

Proc gplot data= TS1.example11_1; 
      symbol i=spline v=circle h=1.5;
      plot temperatureV * t;
      title 'Plot of global temperature';
   run;
Proc autoreg data=TS1.example11_1 all;
   model temperatureV=t/dwprob;
  run;
*/
ods graphics off;
ods html close;
ods listing;
/*
output out=p p=yhat pm=ytrend lcl=lcl ucl=ucl;
run;
Proc print data=p;
run;
*/


