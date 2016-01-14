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
run;
symbol1 i=spline c= v=circle h=1.5;
symbol2 i=r c=red v= h=1;

Proc gplot data=example101;  
      plot milk * date=1 milk * date=2/overlay;
      title 'Monthly US milk production from 1/1994 to 12/2005';
   run;
    
Proc arima data=example101;	
  identify var=milk(1,12) center stationarity=(adf=(0,1,2,3,4,5));
run;
    estimate p=(12 24 36) noconstant method=ml;
run; 
   outlier;
   run;
   forecast lead=24 id=date interval=month back=0 out=out;
run;

Proc print data=out;
run;

symbol1 i=spline c=blue v=circle h=0.5;
symbol2 i=joint c=red  v= h=1;
symbol3 i=spline c=green v= h=1;
symbol4 i=spline c=green v= h=1;

Proc gplot data=out;
plot milk*date=1 
     forecast*date=2 
     l95*date=3
	 u95*date=4/overlay;
title 'Forecast for US milk production';
run;


ods graphics off;
ods html close;
ods listing;


