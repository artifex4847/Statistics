ods html; 
ods listing close; 
ods graphics on; 
libname TS10 'c:\Library_timeseries';

Proc arima 	data= TS10.example104; 
  identify var=logboardings nlag=40 outcov=outcov;
  run;
  estimate p=(1)(12) method =ml 
           outest=outest outmodel=outmodel 
           outstat=outstat;
  run;
  outlier;
  run;
  forecast lead=24 alpha=0.05 id=date interval=month 
           out=out;
run;

symbol1 i=spline c=blue v=circle h=1.5;
symbol2 i=joint c=red  v= h=3;
symbol3 i=spline c=green v= h=1;
symbol4 i=spline c=green v= h=1;

Proc gplot data=out;
plot logboardings*date=1 
     forecast*date=2 
     l95*date=3
	 u95*date=4/overlay;
title 'Forecast for log Denver boarding data';
run;

Data out;
set out;
y=exp(logboardings);
ll95=exp(l95);
uu95=exp(u95);
forecast1=exp(forecast+std*std/2);
run;

Proc gplot data=out;
plot y*date=1 
     forecast1*date=2 
     ll95*date=3
	 uu95*date=4/overlay;

title 'Forecast for Denver boarding data';
run;


Proc print data=out;
title 'Out set';
run;

Proc print data=outcov;
title 'Outcov';
run;
Proc print data=outest;
title 'Outest';
run;
Proc print data=outmodel;
title 'Outmodel';
run;
Proc print data=outstat;
title 'Outstat';
run;

ods graphics off;
ods html close;
ods listing;


