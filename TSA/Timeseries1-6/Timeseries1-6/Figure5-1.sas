ods html; 
ods listing close; 
ods graphics on; 

Data figure51;
y=0;
do t=-50 to 100;
y=y+normal(0);
diff1=y-lag(y);
if t>0 then output;        
end;
run;

Proc gplot data=figure51; 
      symbol i=spline v=circle h=1.5; 
      plot y * t;
      title 'Time plot of simulated realization from a N(0,1) walk';
   run;
      symbol i=spline v=circle h=1.5; 
      plot diff1 * t;
      title 'Time plot of differnce';
   run;
proc autoreg data=figure51;
  m1:  model y=t/dw=12 dwprob;
  m2:  model diff1=t/dw=12 dwprob;
 run;

ods graphics off;
ods html close;
ods listing;
