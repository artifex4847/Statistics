ods html; 
ods listing close; 
ods graphics on; 
libname TS6 'c:\Library_timeseries';

Data example66_1;
e1=0;
y=0;
do t=1 to 500;
        e=normal(0);
        y=0.6*y+e+0.8*e1;
		e1=e;
        if t>400 then output;       
end;
run;

Proc arima data=example66_1;
   identify var=y esacf scan minic;
 run;

Proc gplot data=example66_1; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Plot of a simulated ARMA(1,1)';
   run;


ods graphics off;
ods html close;
ods listing;
