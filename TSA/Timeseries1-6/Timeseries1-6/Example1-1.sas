
ods listing close; /* output delivery system*/
ods html;  /* hypertext markup language*/
ods graphics on; 
libname TS1 'c:\Library_timeseries';


/*************************
 Earth temperature data 
**************************/

Data TS1.example11;
infile 'C:\Data_SS\chapter1\globtemp.dat';
input temperatureV @@;
year=intnx('year','1jan1856'd, _N_-1);
format year year4.;
run;
Data TS1.example11_1;
set TS1.example11;
t=year(year);
if t<1900 then delete;
run;

/**********************************************
  Time serie plot for global temperature data  
***********************************************/

symbol interpol=spline
       value=circle
	   color=red
       height=1.5;


		
Proc gplot data= TS1.example11; 
   plot temperatureV * year;
   title 'Global temperature from 1856 to 1997';
run;

		
Proc gplot data= TS1.example11_1; 
   plot temperatureV * year;
   title 'Global temperature from 1900 to 1997';
run;

/***********************
  Regression analysis
************************/

Proc reg data=TS1.example11_1;
model TemperatureV=t;

output out=example11 r=residuals student=sresiduals;
title 'Simple regression';
run;
plot temperatureV*t;
run;

symbol interpol=
       value=circle
	   color=blue
       height=1.5;
Proc gplot data=example11;
plot residuals*t;
run;
plot sresiduals*t;
run;


/************************
 Box-Cox transformation
*************************/

Data TS1.example11_bc;
set TS1.example11_1;
y=temperatureV+0.55;
run;

ods output boxcox=b details=d;

Proc transreg data=TS1.example11_bc details;
model BoxCox(y/lambda=-1 to 2 by 0.01)=identity(t);
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



/*********************************
  Difference of temperature data
**********************************/

Data example11_diff;
set TS1.example11_1;
d=temperatureV-lag(temperatureV);
run;


/**************************************
   Regression analysis for difference
***************************************/

Proc reg data=example11_diff;
model d=t;
output out=example11_d r=residuals student=sresiduals;
title 'Simple regression of difference';
run;


symbol interpol=
       value=circle
	   color=red
       height=1.5;

Proc gplot data=example11_d;
plot residuals*t;
run;
plot sresiduals*t;
run;


ods graphics off;
ods html close;
ods listing;





