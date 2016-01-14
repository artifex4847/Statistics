ods html; 
ods listing close; 
ods graphics on; 

Data example52;
infile 'C:\Data_CC\gold.dat';
input price;
if _N_<2 then delete;
t=_N_-1;
diff1=price-lag(price);
diff2=price-2*lag(price)+lag2(price);
run;
Proc gplot data=example52; 
      symbol i=spline v=circle h=1; 
      title 'Time plot of gold price';
	  plot price * t;
	  run;
	  symbol i=spline v=circle h=1; 
      title 'Time plot of the 1st difference';
	  plot diff1 * t;
   run;
   symbol i=spline v=circle h=1; 
      title 'Time plot of the 2nd difference';
	  plot diff2 * t;
   run;
Proc autoreg data=example52;
   title 'ACF of gold price';
   model price=t/dw=12 dwprob normal;
run;

proc autoreg data=example52;
   title 'ACF of the 1st difference';
   model diff1=t/dw=12 dwprob normal;
run;

proc autoreg data=example52;
   title 'ACF of the 2nd difference';
   model diff2=t/dw=12 dwprob normal;
run;

ods graphics off;
ods html close;
ods listing;
