ods html; 
ods listing close; 
ods graphics on; 
libname TS3 'c:\Library_timeseries';

proc autoreg data=TS1.example11_2;
      model temperatureV=year/dw=4 dwprob normal;
	  title;
run;

ods graphics off;
ods html close;
ods listing;
