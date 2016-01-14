
ods listing close; 
ods html;  
ods graphics on; 
libname TS0 'c:\Library_timeseries';

Data TS0.example00;
infile 'C:\Data_cru\NH_year.dat';
input temperature @@;
year=intnx('year','1jan1850'd, _N_-1);
format year year4.;
run;

symbol interpol=spline
       value=circle
	   color=blue
       height=1;
		
Proc gplot data= TS0.example00; 
   plot temperature * year;
   title 'Global temperature from 1850 to 2011';
run;

Proc reg data=TS0.example00;
model  temperature=year;
title 'A simple regression';
run;


ods graphics off;
ods html close;
ods listing;





