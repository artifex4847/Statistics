
ods listing close;
ods html;  
ods graphics on; 
libname TS9 'c:\Library_timeseries';

Data TS9.example93;
infile 'C:\Data_CC\oil.price.dat';
input price @@;
if _N_<1 then delete;
		 date = intnx( 'month', '1jan1986'd, _N_-2); 
         format date monyy.;  
         t=_N_-1;	
		 logprice=log(price);
		 sq=t*t;
run;

symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot data=TS9.example93;
plot price*date=1 price*date=2/overlay;
title 'Time plot of oil price';
run;

proc gplot data=TS9.example93;
plot logprice*date=1 logprice*date=2/overlay;
title 'Time plot of log(oil price)';
run;

proc arima data=TS9.example93;
 identify var=logprice(1) scan minic center esacf stationarity=(adf=(0,1,2,3,4));
run;
 estimate q=1 noconstant method=ml;
run;
 outlier;
run;
 forecast lead=24 interval=month id=date
 out=results_oilprice;
run;

symbol1 i=join c=blue v=circle h=1;
symbol2 i=join c=red v=none;
symbol3 i=join c=green v=none;
symbol4 i=join c=green v=none;

proc gplot data=results_oilprice;
plot logprice*date=1 forecast*date=2 
l95*date=3 U95*date=4/overlay;
title 'Forecast of log(oil price)';
run;

Data residual_forecast;
set results_oilprice;
if logprice='.' then
logprice=forecast;
run;

Data one;
set  residual_forecast;
price=exp(logprice);
ll95=exp(l95);
uu95=exp(u95);
forecast1=exp(forecast+std*std/2);
run;

proc gplot data=one;
plot price*date=1 forecast1*date=2 
ll95*date=3 uu95*date=4/overlay;
title 'Forecast of oil price';
run;

data b3; 
      logprice=.;
      do t = 242 to 265;
       sq=t*t;  
      output; end; 
run;

data bb3; 
merge b3 TS9.example93;
by t; 
run;

axis1 label=(a=90 'Oil log(price) data from 1995 to 2007');
symbol1 i=join c=blue v=;
symbol2 i=join c=red v=F;
symbol3 i=join c=black line=1;
symbol4 i=join c=green line=20;
symbol5 i=join c=green line=20;

proc autoreg data=bb3;
 model logprice=t sq/nlag=6 dwprob dw=8 backstep method=ml normal;
 output out=resdat42 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a trend';
run;

axis1 label=(a=90'Oil log(price) data from 1996 to 2007');

proc gplot data=resdat42;
 plot (logprice forecast ytrend lcl ucl) * t/overlay 
 vaxis=axis1 href=150;
 where t>120 & t <265;

title 'Oil logprice data from 1996 to 2007';
footnote1 'Star=actual data, F=forecast, Solid=trend';
 footnote2 'Dotted lines=forecast interval limits';
 run;

 
Data two;
set resdat42;
price=exp(logprice);
lcl1=exp(lcl);
ucl1=exp(ucl);
ytrend1=exp(ytrend);
forecast1=exp(forecast);
run;

axis1 label=(a=90 'Oil price data from 1996 to 2007');

proc gplot data=two;
 plot (price forecast1 ytrend1 lcl1 ucl1) * t/overlay 
 vaxis=axis1 href=150;
 where t>120 & t <265;

title 'Oil price data from 1996 to 2007';
footnote1 'Star=actual data, F=forecast, Solid=trend';
 footnote2 'Dotted lines=forecast interval limits';
 run;






ods graphics off;
ods html close;
ods listing;





