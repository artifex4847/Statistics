ods html; 
ods listing close; 
ods graphics on; 
libname TS10 'c:\Library_timeseries';
Data example101;
         infile 'c:\Data_CC\milk.dat';
         input milk @@;
		 if _N_<2 then delete;
		 date = intnx( 'month', '1jan1994'd, _N_-2); 
         format date monyy.; 
	     char = date; 
         format char monname1.;  
	     month=month(date);
         diff1=milk-lag(milk);
		 diff12=milk-lag12(milk);
		 diff_combined=diff12-lag(diff12);
		 t=_N_;
         x1=cos(2*3.14159*t/12);
         x2=sin(2*3.14159*t/12);	
run;
symbol1 i=spline c= v=circle h=1.5;

Proc gplot data=example101;  
      plot milk * date;
      title 'Monthly US milk production from 1/1994 to 12/2005';
   run;
      plot diff1 * date;
      title 'The 1st difference of US milk production';
   run;
   	  plot diff12 * date;
      title 'The seasonal difference of US milk production';
   run;
	  plot diff_combined * date;
      title 'The combined difference of US milk production';
   run;

Proc arima data=example101;	
identify var=milk stationarity=(adf=(0,1,2,3,4)) nlag=50;
run;
identify var=milk(12) stationarity=(adf=(0,1,2,3,4)) nlag=50;
run;
estimate p=49 method=ml;
run;
estimate p=(1)(12 24 36) method=ml;
run;

Proc arima data=example101;	
identify var=milk(1,12) nlag=50 center stationarity=(adf=(0,1,2,3,4,5));
run;
   estimate p=49 noconstant method=ml;
run; 
   estimate p=(12) noconstant method=ml;
run; 
   estimate p=(12 24 36) noconstant method=ml;
run; 


proc autoreg data=example101;
 model diff12=/nlag=49 backstep method=ml;
 output out=resdat10 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'Autoregression procedure';
run;


proc autoreg data=example101;
 model diff_combined=/nlag=50 noint backstep method=ml;
 output out=resdat10 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'Autoregression procedure';
run;

proc autoreg data=example101;
 model milk=x1 x2 t/ nlag=49 backstep method=ml;
 output out=resdat10 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'Autoregression procedure';
run;


ods graphics off;
ods html close;
ods listing;


