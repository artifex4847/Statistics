
ods html; 
ods listing close; 
ods graphics on; 
libname TS1 'c:\Library_timeseries';

Data TS1.example11_1;

set TS1.example11;

t=year(year);

if t<1900 then delete;

run;
proc reg data=TS1.example11_1;

model TemperatureV=t;

output out=example11 r=residuals 
student=sresiduals;

title 'Simple regression';
run;
plot temperatureV*t;
run;

proc gplot data=example11;
plot residuals*t;
run;
plot sresiduals*t;
run;


ods graphics off;
ods html close;
ods listing;





