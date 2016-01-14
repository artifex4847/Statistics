ods html; 
ods listing close; 
ods graphics on; 
libname TS4 'c:\Library_timeseries';

Data figure47;
y=0;
do t=-50 to 100;
e=normal(0);
y=-0.9*y+e;
y1=lag(y);
y2=lag(y1);
y3=lag(y2);
if t>0 then output;        
end;
run;

Proc gplot data=figure47; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Simulated series of AR(1) with 0.9';
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

Proc autoreg data=figure47;
   model y=t/dw=12 dwprob normal;
 run;

ods graphics off;
ods html close;
ods listing;
