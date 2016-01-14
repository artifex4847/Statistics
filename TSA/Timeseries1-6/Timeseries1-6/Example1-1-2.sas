
ods html; 
ods listing close; 
ods graphics on; 
libname TS1 'c:\Library_timeseries';
Data TS1.example11_2;
set TS1.example11_1;
fitvalue=-12.19+0.0062*t;
residuals=temperatureV-fitvalue;
run;

Proc gplot data= TS1.example11_2; 
      plot residuals * t;
      title 'Residuals plot';
   run;
ods graphics off;
ods html close;
ods listing;





