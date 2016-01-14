
ods listing close;
ods html;  
ods graphics on; 
libname TS6 'c:\Library_timeseries';

Data TS6.figure69;
infile 'C:\Data_SS\chapter1\globtemp.dat';
input temperatureV @@;
year=intnx('year','1jan1856'd, _N_-1);
format year year4.;
run;

symbol1 i=join c=blue v=circle;
symbol2 i=r c=red v=none;

Proc gplot data=TS6.figure69; 
      plot temperatureV * year=1 temperatureV * yea=2/overlay;
      title 'Plot of Global temperature (1856-1997)';
run;

Proc arima data=TS6.figure69;
identify var=temperatureV 
stationarity=(adf=(0,1,2,3,4,5,6));
run;
identify var=temperatureV(1) 
scan esacf minic stationarity=(adf=(0,1,2,3,4,5,6));
run;
estimate q=2 noconstant method=ml plot;
run;
estimate p=1 q=1 noconstant method=ml plot;
run;
outlier;
run;

Proc autoreg data=TS6.figure69;
 model temperatureV=year/nlag=12 
 method=ml noint dwprob dw=6 normal backstep;
 output out=resdat3 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title2 'With a trend';
run;

Proc univariate data=resdat3 normal;
var resid2;
histogram resid2/normal;
title;
run;

ods graphics off;
ods html close;
ods listing;





