ods html; 
ods listing close; 
ods graphics on; 

Data a;
do t=-50 to 200;
        e=normal(1021);
        y=e+1*lag12(e);
        if t>0 then output;       
end;
run;
proc print data=a;
run;

Proc gplot data=a; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Plot of a simulated MA(1)_12 with -0.9';
   run;

Proc arima data=a;
   identify var=y center esacf scan minic;
 run;
   estimate q=(12) noconstant method=cls;
run;



Data b;
do t=-50 to 200;
        e=normal(1021);
        y=e-0.9*lag12(e);
        if t>0 then output;       
end;
run;
Proc gplot data=b; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Plot of a simulated MA(1)_12 with 0.9';
   run;

Proc arima data=b;
   identify var=y center esacf scan minic;
 run;
   estimate q=(12) noconstant method=cls;
run;



Data c;
do t=-50 to 200;
        e=normal(1021);
        y=e+0.3*lag12(e);
        if t>0 then output;       
end;
run;

Proc gplot data=c; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Plot of a simulated MA(1)_12 with -0.3';
   run;

Proc arima data=c;
   identify var=y center esacf scan minic;
 run;
   estimate q=(12) noconstant method=ml;
run;



Data d;
do t=-50 to 200;
        e=normal(1021);
        y=e-0.3*lag12(e);
        if t>0 then output;        
end;
run;

Proc gplot data=d; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Plot of a simulated MA(1)_12 with 0.3';
   run;

Proc arima data=d;
   identify var=y center esacf scan minic;
 run;
   estimate q=(12) noconstant method=ml;
 run;



ods graphics off;
ods html close;
ods listing;
