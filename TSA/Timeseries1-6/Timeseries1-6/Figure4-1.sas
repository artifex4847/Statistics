ods html; 
ods listing close; 
ods graphics on; 
libname TS4 'c:\Library_timeseries';

Data figure41;

do t=1 to 100;
e=normal(0);
y=e+0.9*lag(e);
y1=lag(y);
y2=lag2(y);
y3=lag(y2);
output;        
end;

run;

Proc gplot data=figure41; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Simulated series of MA(1) with 0.9';
   run;
     symbol i= v=circle h=1; 
      plot y * y1;
      title 'Scatter plot (y,y1)';
   run;
    symbol i= v=circle h=1; 
      plot y * y2;
      title 'Scatter plot (y,y2)';
   run;
   symbol i= v=circle h=1; 
      plot y * y3;
      title 'Scatter plot (y,y3)';
   run;

Proc autoreg data=figure41;
   model y=t/dw=12 dwprob normal;
 run;

proc autoreg data=figure41;;
 model y=/noint nlag=12 dwprob dw=8 backstep method=ml;
 output out=resdat1_4 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a trend';
run;

ods graphics off;
ods html close;
ods listing;
