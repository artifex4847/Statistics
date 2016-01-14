ods html; 
ods listing close; 
ods graphics on; 
libname TS3 'c:\Library_timeseries';

Data TS3.example36_2;
set TS3.example36_1;
t=_N_;
sq=t*t;
x1=cos(2*3.14159*t/12);
x2=sin(2*3.14159*t/12);
run;

Proc glm data=TS3.example36_2;
model beersales=x1 x2;
output out=bbb r=residuals p=predicted student=sresiduals;
title 'Regression analysis of US beer sales data';
run;
/*
Data TS3.example36_3;
set TS3.example36_2;
y=14.80446-2.23393*x1-0.21791*x2;
delta=beersales-y;
run;
*/
Proc gplot data=bbb; 
      title 'Monthly US beer sales with a cosine trend';
      plot beersales * date  predicted * date /overlay;
        symbol1 color=blue
		      i=
              value=circle
              height=1;

        symbol2 color=red
		        v=dot
                interpol=join
                height=1;
     run;
    title 'Plot of residuals from a cosine trend model fit';
    symbol i=spline v=circle h=1; 
    plot predicted * date; 
   run;

proc autoreg data=bbb;
model residuals=/nlag=49 noint dwprob normal backstep method=ml;
 output out=resdat36 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'Autoregression procedure';
run;

ods graphics off;
ods html close;
ods listing;


