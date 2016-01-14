
ods listing close;
ods html;  
ods graphics on; 
libname TS6 'c:\Library_timeseries';

title1 'Simulated IMA(1,1) time series';

Data aa;
  y1=0.9; 
  e1=0;  
  do t=-50 to 100;
      e=rannor(32565);
	  y=y1+e-0.8*e1;
      if t>0 then output;   
      e1=e;
	  y1=y;
	  end;
   run;

symbol1 i=join c=blue v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot;
plot y*t=1 y*t=2/overlay;
run;

Proc arima data=aa; 
 
identify var=y 
stationarity=(adf=(0,1,2,3,4));
run;
identify var=y(1) 
esacf scan minic 
stationarity=(adf=(0,1,2,3,4,5,6));
run;
estimate q=1 noconstant method=ml plot;
quit;

Proc autoreg data=aa;
 model y =t/nlag=6 method=ml dwprob dw=6 normal  
 backstep;
 output out=resdat2 r=resid2 ucl=ucl lcl=lcl p=forecast 
 pm=ytrend;
 title2;
run;

Proc print data=resdat2;
run;

ods graphics off;
ods html close;
ods listing;





