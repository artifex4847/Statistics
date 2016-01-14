
ods listing close;
ods html;  
ods graphics on; 
libname TS6 'c:\Library_timeseries';

title 'Figure 6.8: simulation of AR(1) error';
title2 'Generation of an estimated sample';
data bb;
  u1=0;
   do time=-50 to 100;
   u=.6*u1+normal(10);
   y=-2+.6*time+u;
   if time>0 then output;
   u1=u;
   end;
   run;
symbol1 i=join c=blue v=circle;
symbol2 i=r c=red v=none;

proc gplot;
plot Y*time=1 Y*time=2/overlay;
run;

proc arima data=bb;
identify var=y esacf scan minic stationarity=(adf=(0,1,2,3,4,5,6));
title2 'Check of AR error in original data';
run;
identify var=y(1) esacf scan minic stationarity=(adf=(0,1,2,3,4,5,6));
title2 'Check of AR error in the first differeced data';
run;
estimate q=1 method=ml plot;
run;


proc autoreg data=bb;
 model y =time/nlag=6 method=ml dwprob dw=6 backstep;
 output out=resdat2 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title2 'ARIMA(1,0,0) model of the data';
run;

data resck;
set resdat2;
title2 'The residual data set';
/*
Proc univariate data=resck normal;
var resid2;
histogram resid2/normal;
qqplot resid2/normal(mu=0 sigma=1 color=red l=1 w=2);
probplot resid2/normal(mu=0 sigma=1 color=red l=2 w=2);
title;
run;
*/
data together;
set resdat2;
if time > 50 then forecast=.;
if time > 50 then ucl=.;
if time > 50 then lcl=.;
run;

data anno;
 input time 1-4 text $ 5-58;
 function='label'; angle = 90 ; xsys='2'; ysys='1';
 x=time; y=60; position='B';
 cards;

axis1 label=(a=90 'Simulated Y(t)');
symbol1 i=join c=blue v=star;
symbol2 i=join c=green v=F;
symbol3 i=join c=black line=1;
symbol4 i=join c=red line=20;
symbol5 i=join c=red line=20;

proc gplot data=together;
 plot (y forecast ytrend lcl ucl) * time/overlay 
 vaxis=axis1 href=50 annotate=anno;
 where time >25 & time < 60;

title 'Forecast profile of regression with AR(1) errors';
footnote1 'Star=actual data, F=forecast, Solid=trend';
 footnote2 'Dotted lines=forecast interval limits';
 run;


ods graphics off;
ods html close;
ods listing;





