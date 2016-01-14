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
  identify var=logboardings nlag=40 
   outcov=outcov;
  run;
   estimate p=(1)(12) method =ml;
  run;


/*
symbol1 i=spline c=blue v=circle h=1.5;
symbol2 i=joint c=red  v= h=3;
symbol3 i=spline c=green v= h=1;
symbol4 i=spline c=green v= h=1;
Proc gplot data=out;
plot logboardings*date=1 
     forecast*date=2 
     l95*date=3
	 u95*date=4/overlay;
title 'Forecast for log Denver boarding data';
run;
Data out;
set out;
y=exp(logboardings);
ll95=exp(l95);
uu95=exp(u95);
forecast1=exp(forecast+std*std/2);
forecast2=exp(forecast);
run;
symbol5 i=joint c=blue  v=  h=1;
Proc gplot data=out;
plot y*date=1 
     forecast1*date=2 
     ll95*date=3
	 uu95*date=4
     forecast2*date=5/overlay;
title 'Forecast for Denver boarding data';
run;

Proc print data=out;
title 'Out set';
run;

Proc print data=outcov;
title 'Outcov';
run;
Proc print data=outest;
title 'Outest';
run;
Proc print data=outmodel;
title 'Outmodel';
run;
Proc print data=outstat;
title 'Outstat';
run;
*/ 
ods graphics off;
ods html close;
ods listing;


