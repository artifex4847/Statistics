
ods listing close;
ods html;  
ods graphics on; 
libname TS9 'c:\Library_timeseries';

/**************************
  Earth temperature data
***************************/

data TS9.example91;
infile 'C:\Data_SS\chapter1\globtemp.dat';
input temperatureV @@;
year=intnx('year','1jan1856'd, _N_-1);
format year year4.;
t=year(year);
run;

data TS9.example91_1;
set TS9.example91;
if t>1900 then output;
run;


/**************************
  Box-Cox transformation
***************************/

/*
data aa;
set TS9.example91_1;
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
run; quit; */



/**********************************
  Plot of earth temperature data
***********************************/


symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot data=TS9.example91_1;
plot temperatureV*year=1 temperatureV*year=2/overlay;
title 'Global temperature from 1856 to 1997';
run;


/**********************************
  Use ARIMA procedure to fit data
***********************************/

proc arima data=TS9.example91_1;
identify var=temperatureV(1) center scan minic esacf outcov=outcov;
run;
estimate p=3 method=ml noconstant outmodel=outmodel outest=outest outstat=outstat;
title 'Model selection';
run;
outlier;
run;
forecast lead=24 alpha=0.05 id=year interval=year back=0 
out=results;
run;

Proc print data=results;
run; 


symbol1 i=join c=blue v=circle h=1;
symbol2 i=join c=red v=F h=1;
symbol3 i=spline c=green v= h=;
symbol4 i=spline c=green v= h=;

proc gplot data=results;
plot temperatureV*year=1  forecast*year=2 
l95*year=3 u95*year=4/overlay;
title 'Global temperature from 1901 to 2022';
run;

/************************************
  Use Autoreg procedure to fit data
*************************************/

data b; 
     temperatureV = .; 
     do t = 1998 to 2022; output; end; 
   run; 
    
data bb; merge TS9.example91_1 b; by t; run;

/*
proc print data=bb;
run;
*/

proc autoreg data=bb;
 model temperatureV=t/nlag=6 dwprob dw=8 backstep method=ml;
 output out=resdat3 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a linear trend';
run;
proc print data=resdat3;
run;

axis1 label=(a=90 'Global temperature data from 1856 to 1997');
symbol1 i=join c=blue v=;
symbol2 i=join c=red v=F;
symbol3 i=join c=black line=1;
symbol4 i=join c=green line=20;
symbol5 i=join c=green line=20;

proc gplot data=resdat3;
 plot (temperatureV forecast ytrend lcl ucl) * t/overlay 
 vaxis=axis1 href=24;
 where t>1900 & t <2022;

title 'Global temperature from 1900 to 2022';
footnote1 'Star=actual data, F=forecast, Solid=trend';
 footnote2 'Dotted lines=forecast interval limits';
 run;


/************************************
  Normality test for residuals
*************************************/

Proc univariate data=resdat3 normal;
var resid2;
title 'Normality test';
histogram resid2/normal;
qqplot resid2/normal(mu=0 sigma=0.1029999 color=red l=1 w=2);
probplot resid2/normal(mu=0 sigma=0.1029999 color=red l=2 w=2);
footnote1 'Box or Circle=actual data, Solid=normal';
run;

/************************************
  Independence test for risiduals
*************************************/

data resdat4;
set resdat3;
if resid2='.' then delete;
run;

data standardresiduals;
set resdat4;
sresiduals=(resid2-0.0016545)/0.1029999;
run;

data runcount;
   keep runs n1 n2 n;
   set standardresiduals nobs=nobs end=last;
   retain runs 0 n1 0;
      prevpos=(lag(sresiduals) GE 0);
        currpos=(sresiduals GE 0 );
      
        if currpos and prevpos then n1+1;
        else if currpos and ^prevpos then do;
           runs+1;
           n1+1;
           end;
        else if ^currpos and prevpos then runs+1;
        if last then do;
          n2=nobs-n1;
          n=nobs;
          output;
        end;
        run;
/*These steps compute and display the Wald-Wolfowitz 
(or runs) test statistic and its p-value. 
*/

data waldwolf;
label z='Wald-Wolfowitz Z' pvalue='Pr > |Z|';
set runcount;
mu =(2*n1*n2)/(n1+n2)+ 1;
sigmasq=((2*n1*n2)*(2*n1*n2-n))/
    ((n**2)*(n-1));
        sigma=sqrt(sigmasq);
        drop sigmasq;
        if n GE 50 then Z=(runs - mu)/sigma;
        else if runs-mu LT 0 then Z = (runs-mu+0.5)/sigma;
          else Z = (runs-mu-0.5)/sigma;
        pvalue=2*(1-probnorm(abs(Z)));
        run;
      title1  'Runs test for independence';
      footnote1 'H0: The data are independence';

proc print data=waldwolf label noobs;
        var runs mu z pvalue;
        format pvalue pvalue.;
        run;



ods graphics off;
ods html close;
ods listing;





