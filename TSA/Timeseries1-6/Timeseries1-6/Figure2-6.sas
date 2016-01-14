ods html; 
ods listing close; 
ods graphics on; 
libname TS2 'c:\Library_timeseries';

Data figure26_1; 
do t=1 to 200;
y=2*sin(2*3.14159*t/50+0.6*3.14159);   
output;
end;
run;

Proc gplot data=figure26_1; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'the curve of 2sin(2 pi t/50+0.6pi)';
   run;
  
Data figure26_2;
y=0;
do t=-50 to 200;
y=2*sin(2*3.14159*t/50+0.6*3.14159)+normal(0);
if t>0 then output;        
end;
run;

Proc gplot data=figure26_2; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'A realization of the asinusoidal model with N(0,1)';
   run;

Data figure26_3;
y=0;
do t=-50 to 200;
y=2*sin(2*3.14159*t/50+0.6*3.14159)+2*normal(0);
if t>0 then output;        
end;
run;
Proc gplot data=figure26_3; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'A realization of the asinusoidal model with N(0,4)';
   run;

Data figure26_4;
y=0;
do t=-50 to 100;
y=2*sin(2*3.14159*t/50+0.6*3.14159)+4*normal(0);
if t>0 then output;        
end;
run;
Proc gplot data=figure26_4; 
      symbol i=spline v=circle h=1; 
      plot y * t;
       title 'A realization of the asinusoidal model with N(0,16)';
   run;


ods graphics off;
ods html close;
ods listing;
