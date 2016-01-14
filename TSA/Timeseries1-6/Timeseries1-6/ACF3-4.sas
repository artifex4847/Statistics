ods html; 
ods listing close; 
ods graphics on; 
libname TS3 'c:\Library_timeseries';

 proc timeseries data=TS3.sresiduals34 plot=ACF;
     id year interval=year accumulate=total;
     var sresiduals;
     title 'Sample ACF for residuals from global temperature data';
   run;

Data TS2.figure21_1;
do month=1 to 100;
y=normal(0);
output;        
end;
run;
Proc gplot data= TS2.figure21_1; 
      symbol i=spline v=circle h=1.5; 
      plot y * month;
      title 'The first simulated realization of white noise N(0,1)';
   run;
  
 proc timeseries data=TS2.figure21_1 plot=ACF;
     id month interval=month;
     var y;
   run;
/*

   proc autoreg data=TS2.figure21_1 all;
      model y = month / nlag=2 method=ml;
     /* output out=p p=yhat pm=ytrend
                lcl=lcl ucl=ucl;*/
				run;

Data TS2.figure21_2;
do month=1 to 100;
y=normal(0);
output;        
end;
run;
Proc gplot data= TS2.figure21_2; 
      symbol i=spline v=circle h=1.5; 
      plot y * month;
      title 'The second simulated realization of white noise N(0,1)';
   run;

 proc timeseries data=TS2.figure21_2 plot=ACF;
     id month interval=month accumulate=total;
     var y;
   run;
 

ods graphics off;
ods html close;
ods listing;
