ods html; 
ods listing close; 
ods graphics on; 
libname TS5 'c:\Library_timeseries';
Data TS5.figure58;
infile 'C:\Data_CC\electricity.dat';
input electricity;
t=_N_-1;
if _N_<2 then delete;
date = intnx( 'month', '1jan1973'd, _N_-2); 
         format date year4.; 
run;

ods output boxcox=b details=d;

Proc transreg data=TS5.figure58 details;
model BoxCox(electricity/lambda=-0.4 to 1 by 0.01)=identity(t);
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
         then call symput('href1', compress(put(lambda, best12.)));
      if ci  = '<'
         then call symput('href2', compress(put(lambda, best12.)));
      if eof
         then call symput('href3', compress(put(lambda, best12.)));
      run;

/*These steps plot the log likelihood, root mean square 
error, and R2. The input data set is the Box-Cox 
transformation table, which was output using ODS.*/

   * Plot log likelihood, confidence interval;
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

ods graphics off;
ods html close;
ods listing;
