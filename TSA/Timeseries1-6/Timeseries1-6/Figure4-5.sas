ods html; 
ods listing close; 
ods graphics on; 
libname TS4 'c:\Library_timeseries';

Data figure45;
do t=1 to 100;
e=normal(0);

y=e-0.9*lag(e)+0.7*lag2(e);

y1=lag(y);
y2=lag(y1);
y3=lag(y2);
output;        
end;
run;
Proc gplot data=figure45; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Simulated series of MA(2) with (0.9,-0.7)';
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
proc autoreg data=figure45;
   model y=t/dw=12 dwprob normal;
 run;

ods graphics off;
ods html close;
ods listing;
