
ods listing close;
ods html;  
ods graphics on; 
libname TS0 'c:\Library_timeseries';

Data aa;
set TS0.example01_shmonth;
y=temperature+2;
logT=log(y);
run;

ods output boxcox=b details=d;
proc transreg data=aa details;
model BoxCox(y/lambda=-2 to 2 by 0.05 alpha=0.05)=identity(t);
output out=trans;
title 'Box-Cox graphical displays';
run;

data _null_;
      set d;
      if description = 'CI Limit'
         then call symput('vref', formattedvalue);
      if description = 'Lambda Used'
         then call symput('lambda', formattedvalue);
      run;

data _null_;
      set b end=eof;
      where ci ne ' ';
      if _n_ = 1
        then call symput('href1',compress(put(lambda, best12.)));
      if ci  = '<'
        then call symput('href2',compress(put(lambda, best12.)));
      if eof
        then call symput('href3', compress(put(lambda, best12.)));
      run;

 axis1 label=(angle=90 rotate=0) minor=none;
   axis2 minor=none;

proc gplot data=b;
   title2 'Log Likelihood';
   plot loglike * lambda / vref=&vref href=&href1 &href2 &href3
                           vaxis=axis1 haxis=axis2 frame cframe=ligr;
   footnote "Confidence Interval: &href1 - &href2 - &href3, "
               "Lambda = &lambda";
   symbol v=none i=spline c=blue;
run;
footnote;
title2 'RMSE';
plot rmse * lambda / vaxis=axis1 haxis=axis2 frame cframe=ligr;
run;

title2 'R-Square';
plot rsquare * lambda / vaxis=axis1 haxis=axis2 frame cframe=ligr;
axis1 order=(0 to 1 by 0.1) label=(angle=90 rotate=0) minor=none;
run; quit;

symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot data=aa;
plot temperature*t=1 temperature*t=2/overlay;
title 'North monthly temperature from 1850 to 2011';
run;

proc arima data=aa;
identify var=temperature nlag=24 center scan minic esacf stationarity=(adf=(0,1,2,3,4,5,6));
run;
estimate q=1 noconstant method=ml;
title 'Model selection';
run;
outlier;
run;
forecast lead=24 alpha=0.05 id=t interval=month back=0 
out=results;
run;

symbol1 i=join c=blue v=circle h=1;
symbol2 i=join c=red v=F h=1;
symbol3 i=spline c=green v= h=;
symbol4 i=spline c=green v= h=;

proc gplot data=results;
plot temperature*date=1  forecast*date=2 
l95*date=3 u95*date=4/overlay;
title 'South monthly temperature from 1901 to 2022';
run;

proc autoreg data=aa;
 model temperature=t/nlag=40 dwprob dw=8 backstep method=ml;
 output out=resdat3 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a linear trend';
run;

axis1 label=(a=90 'South temperature data from 1850 to 2011');
symbol1 i=join c=blue v=;
symbol2 i=join c=red v=F;
symbol3 i=join c=black line=1;
symbol4 i=join c=green line=20;
symbol5 i=join c=green line=20;

proc gplot data=resdat3;
 plot (temperature forecast ytrend lcl ucl) * date/overlay 
 vaxis=axis1 href=24;
 /* where date>1900 & date <2022; */

title 'South monthly temperature from 1900 to 2022';
footnote1 'Star=actual data, F=forecast, Solid=trend';
 footnote2 'Dotted lines=forecast interval limits';
 run;

ods graphics off;
ods html close;
ods listing;





