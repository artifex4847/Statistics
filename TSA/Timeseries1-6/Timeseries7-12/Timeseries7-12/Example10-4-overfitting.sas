ods html; 
ods listing close; 
ods graphics on; 
libname TS10 'c:\Library_timeseries';
Data TS10.example104;
         infile 'c:\Data_CC\boardings.dat';
         input logboardings logprice @@;
		 if _N_<2 then delete;
		 date = intnx( 'month', '8aug2000'd, _N_-2); 
         format date monyy.; 
	     char = date; 
         format char monname1.;  
	     month=month(date);	
run;

symbol1 i=spline c=blue v=circle h=1.5;
symbol2 i=r c=red v= h=1.5;

Proc gplot data= TS10.example104;  
      plot logboardings * date=1 
           logboardings * date=2/overlay;
      title 'Denver boarding data from 8/2000 to 3/2006';
   run;

Proc arima 	data= TS10.example104; 
  identify var=logboardings nlag=48 outcov=outcov;
  run;
  estimate p=(1 2)(12) method =ml;
  run;
  estimate p=(1)(12) q=1 method=ml;
  run;
  estimate p=(1)(12) q=(12) method=ml;
  run;
  estimate p=(1)(12 24) method=ml;
run;
 




ods graphics off;
ods html close;
ods listing;


