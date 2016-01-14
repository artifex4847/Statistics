ods html; 
ods listing close; 
ods graphics on; 
libname TS1 'c:\Library_timeseries';

proc reg data=TS1.example11_1;
model temperatureV=t;

output out=example34 r=residuals student=sresiduals;
run;

Proc univariate data=example34 normal;
var residuals sresiduals;
histogram residuals/normal;
qqplot residuals/normal(mu=0 sigma=0.129125 color=red l=1 w=2);
probplot sresiduals/normal(mu=0 sigma=1 color=red l=2 w=2);
title;
run;

proc autoreg data=example34 all;
model temperatureV=t;

run;


ods graphics off;
ods html close;
ods listing;
