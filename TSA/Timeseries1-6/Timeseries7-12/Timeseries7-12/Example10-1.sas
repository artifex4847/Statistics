ods html; 
ods listing close; 
ods graphics on; 
libname TS10 'c:\Library_timeseries';
Data TS10.example101;
         infile 'c:\Data_CC\milk.dat';
         input milk @@;
		 if _N_<2 then delete;
		 date = intnx( 'month', '1jan1994'd, _N_-2); 
         format date monyy.; 
	     char = date; 
         format char monname1.;  
	     month=month(date);
         diff_milk=milk-lag(milk);	
run;
symbol1 i=spline c= v=circle h=1.5;

Proc gplot data= TS10.example101;  
      plot milk * date;
      title 'Monthly US milk production from 1/1994 to 12/2005';
   run;
   	plot diff_milk * date;
      title 'The 1st difference of US milk production';
   run;

ods graphics off;
ods html close;
ods listing;


