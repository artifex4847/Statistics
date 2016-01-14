
ods listing close;
ods html;  
ods graphics on; 
libname TS9 'c:\Library_timeseries';

Data TS9.example91_ngl;
infile 'C:\Data_cru\NH_year.dat';
input temperatureV @@;
year=intnx('year','1jan1850'd, _N_-1);
format year year4.;
t=year(year);
run;

Data TS9.example91_ngl1;
set TS9.example91_ngl;
if t>1900 then output;
run;

Data aa;
set TS9.example91_ngl1;
y=temperatureV+0.55;
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

proc gplot data=TS9.example91_ngl1;
plot temperatureV*year=1 temperatureV*year=2/overlay;
title 'North year temperature from 1901 to 2001';
run;

proc arima data=TS9.example91_ngl1;
identify var=temperatureV(1) center scan minic esacf stationarity=(adf=(0,1,2,3,4,5,6));
run;
estimate p=3 method=ml noconstant outmodel=outmodel outest=outest outstat=outstat;
title 'Model selection';
run;
outlier;
run;
forecast lead=24 alpha=0.05 id=year interval=year back=0 
out=results;
run;

symbol1 i=join c=blue v=circle h=1;
symbol2 i=join c=red v=F h=1;
symbol3 i=spline c=green v= h=;
symbol4 i=spline c=green v= h=;

proc gplot data=results;
plot temperatureV*year=1  forecast*year=2 
l95*year=3 u95*year=4/overlay;
title 'North yearly temperature from 1901 to 2022';
run;


data b; 
     temperatureV = .; 
     do t = 2012 to 2035; output; end; 
   run; 
    
data bb; merge TS9.example91_ngl1 b; by t; run;

proc print data=bb;
run;

proc autoreg data=bb;
 model temperatureV=t/nlag=6 dwprob dw=8 backstep method=ml;
 output out=resdat3 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a linear trend';
run;
proc print data=resdat3;
run;

axis1 label=(a=90 'North yearly temperature data from 1901 to 2011');
symbol1 i=join c=blue v=;
symbol2 i=join c=red v=F;
symbol3 i=join c=black line=1;
symbol4 i=join c=green line=20;
symbol5 i=join c=green line=20;

proc gplot data=resdat3;
 plot (temperatureV forecast ytrend lcl ucl) * t/overlay 
 vaxis=axis1 href=24;
 where t>1900 & t <2035;

title 'North yearly temperature from 1900 to 2035';
footnote1 'Star=actual data, F=forecast, Solid=trend';
 footnote2 'Dotted lines=forecast interval limits';
 run;

ods graphics off;
ods html close;
ods listing;





