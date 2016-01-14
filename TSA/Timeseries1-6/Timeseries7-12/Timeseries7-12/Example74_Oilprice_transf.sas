
ods listing close;
ods html;  
ods graphics on; 
libname TS7 'c:\Library_timeseries';

Data TS7.example74;
infile 'C:\Data_CC\oil.price.dat';
input price @@;
if _N_<2 then delete;
		 date = intnx( 'month', '1jan1986'd, _N_-2); 
         format date monyy.;  
         t=_N_-1;	
         diff_price=price-lag(price);
run;

ods output boxcox=b details=d;

proc transreg data=TS7.example74 details;
model BoxCox(price/lambda=-1 to 0.5 by 0.01 alpha=0.05)=identity(t);
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





