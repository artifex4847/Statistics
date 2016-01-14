ods html; 
ods listing close; 
ods graphics on; 
libname TS6 'c:\Library_timeseries';
Data example66_2;
y=0;
y1=0;
e1=0;
e2=0;
do t=1 to 500;
   if t=1 then do; 
        e=normal(0);
        y=0.5*y-0.5*y1+e+0.8*e1-0.2*e2;
        output;
        end;
    else do;
		temp=y;
        e2=e1;
        e1=e;
        e=normal(0);
        y=0.5*y-0.5*y1+e+0.8*e1-0.2*e2;
		y1=temp;
        output;        
    end;
end;
drop t temp;
run;

proc arima data=example66_2;
   identify var=y esacf scan minic stationarity=(adf=(1,2,3,4,5,6,7,8,9,10));
 run;

Proc gplot data=example66_2; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Plot of a simulated ARMA(2,2)';
   run;


ods graphics off;
ods html close;
ods listing;
