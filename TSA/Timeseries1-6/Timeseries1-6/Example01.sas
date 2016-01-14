ods html; 
ods listing close; 
ods graphics on; 
libname TS0 'c:\Library_timeseries';

Data TS0.example01;
         infile 'c:\Data_cru\gl_month.dat';
         input temperature @@;
         date = intnx( 'month', '1jan1850'd, _N_-1); 
         format date monyy.; 
	     char = date; 
         format char monname1.;  
	     month=month(date);	
run;
Data TS0.example01_1;
set TS0.example01;
if _N_<601 then delete;
run;
Proc gplot data= TS0.example01_1; 
      symbol i=joint v=circle h=1; 
      plot temperature * date;
      title 'Monthly temperature from 1900 to 2012';
   run;

Proc glm data=TS0.example01_1; 
class month; 
model temperature=month;
output out=aaa r=residuals student=sresiduals;

estimate 'Jan.' intercept 1 month 1;
estimate 'Feb.' intercept 1 month 0 1;
estimate 'Mar.' intercept 1 month 0 0 1;
estimate 'Apr.' intercept 1 month 0 0 0 1;

estimate 'May ' intercept 1 month 0 0 0 0 1;
estimate 'Jun.' intercept 1 month 0 0 0 0 0 1;
estimate 'Jul.' intercept 1 month 0 0 0 0 0 0 1;
estimate 'Aug.' intercept 1 month 0 0 0 0 0 0 0 1;

estimate 'Sep.' intercept 1 month 0 0 0 0 0 0 0 0 1;
estimate 'Oct.' intercept 1 month 0 0 0 0 0 0 0 0 0 1;
estimate 'Nov.' intercept 1 month 0 0 0 0 0 0 0 0 0 0 1;
estimate 'Dec.' intercept 1 month 0 0 0 0 0 0 0 0 0 0 0 1;
run; 

/*
Data TS3.example36_residual;
      set TS3.example36_1;
	  select(month);
	  when (1) residual=beersales-13.1608091;
      when (2) residual=beersales-13.0175818;
      when (3) residual=beersales-15.1058182;
      when (4) residual=beersales-15.3981273;
      when (5) residual=beersales-16.7695273;
      when (6) residual=beersales-16.8791818;
	  when (7) residual=beersales-16.8270091;
	  when (8) residual=beersales-16.5716182; 
      when (9) residual=beersales-14.4044545;
      when (10) residual=beersales-14.2847545;
      when (11) residual=beersales-12.8943091;
      other residual=beersales-12.3403818;
	  end;
run;
Proc gplot data=aaa; 
      symbol i=spline v=circle h=1; 
      plot residuals * date;
      title 'Residual plot of monthly temperature data';
   run;
   plot sresiduals*date;
    title 'SResidual plot';
   run;

proc autoreg data=aaa;
model residuals=date/dw=12 dwprob normal;
title;
run;
*/

ods graphics off;
ods html close;
ods listing;


