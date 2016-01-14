ods html; 
ods listing close; 
ods graphics on; 
libname TS2'c:\Library_timeseries';

data figure24; 
     a1 = 0;
     a2=0; 
     do t = -50 to 100; 
        a3=rannor(0);
 
        y =a1/3+a2/3+a3/3; 

        if t>0 then output;
        a1 = a2; 
        a2 = a3; 
        end; 
   run;

   Proc gplot data=figure24; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title '1st simulated realization of a N(0,1) MA model';
   run;

ods graphics off;
ods html close;
ods listing;
