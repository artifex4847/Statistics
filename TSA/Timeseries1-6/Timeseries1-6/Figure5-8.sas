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

/* date = intnx( 'month', '1jan1975'd, _N_-2); 
         format date monyy.; 
	     char = date; 
         format char monname1.;  
	     t=month(date);	*/
run;

Proc gplot data=TS5.figure58; 
   /*   symbol i=spline v=circle h=1; 
      title 'Time plot of electricity';
	  plot electricity * t;
	  run;
*/
	  symbol i=spline v=circle h=1; 
      title 'Time plot of electricity';
	  plot electricity * date;
	  run;

Proc autoreg data=TS5.figure58;
model electricity=t/dwprob;
run;

ods graphics off;
ods html close;
ods listing;
