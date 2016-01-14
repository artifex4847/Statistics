
ods listing close;
ods html;  
ods graphics on; 
libname TS7 'c:\Library_timeseries';

Data TS7.example73;
infile 'C:\Brockwell_data_itsm2000\Nile.tsm';
input waterlevel @@;
year=intnx('year','1jan1622'd, _N_-1);
format year year4.;
t=year(year)-1000;
diff0=waterlevel-lag(waterlevel);
run;

ods output boxcox=b details=d;
proc transreg data=TS7.example73 details;
model BoxCox(waterlevel/lambda=-2 to 0 by 0.05 alpha=0.05)
=identity(t);
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

proc gplot Data=TS7.example73;
plot waterlevel*t=1 waterlevel*t=2/overlay;
title 'Time plot of waterlevel of Nile river (662-871)';
run;

data TS7.example73_1;
set TS7.example73;
tran=1/waterlevel;
log=log(waterlevel);
run;

proc gplot Data=TS7.example73_1;
plot tran*t=1 tran*t=2/overlay;
title 'Time plot of transformated Nile waterlevel by 1/Yt';
run;


proc gplot Data=TS7.example73_1;
plot log*t=1 log*t=2/overlay;
title 'Time plot of transformated Nile waterlevel by log';
run;

proc arima data=TS7.example73_1;
identify var=tran(1) esacf center scan minic
stationarity=(adf=(0,1,2,3,4,5,6));
run;
estimate q=2 noconstant method=ml;
title 'Model selection with transformation 1/Yt';
run;

proc autoreg data=TS7.example73_1;
 model tran=/nlag=6 dwprob dw=8 backstep method=ml;
 output out=resdat4 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a trend';
run;

proc arima data=TS7.example73_1;
identify var=log(1) esacf center scan minic
stationarity=(adf=(0,1,2,3,4,5,6));
run;
estimate q=2 noconstant method=ml;
title 'Model selection with transformation log(Yt)';
run;

proc autoreg data=TS7.example73_1;
 model log=/nlag=6 dwprob dw=8 backstep method=ml;
 output out=resdat4 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a trend';
run;

ods graphics off;
ods html close;
ods listing;





