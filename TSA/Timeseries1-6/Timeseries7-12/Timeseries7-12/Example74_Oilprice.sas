
ods listing close;
ods html;  
ods graphics on; 
libname TS7 'c:\Library_timeseries';

Data TS7.example74;
infile 'C:\Data_CC\oil.price.dat';
input price @@;
if _N_<2 then delete;
		 date = intnx( 'month', '1jan1986'd, _N_-2); 
         format date monyy.;  
        t=_N_-1;
        sq=t*t;	
run;

symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot;
plot price*t=1 price*t=2/overlay;
title 'Time plot of oil price';
run;

proc arima data=TS7.example74;
identify var=price esacf scan minic
stationarity=(adf=(0,1,2,3,4,5,6));
run;
identify var=price(1) center esacf scan minic
stationarity=(adf=(0,1,2,3,4,5,6));
run;
estimate q=4 noconstant method=ml;
title 'Model selection';
run;
estimate q=(1 4) noconstant method=ml;
title 'Model selection';
run;

proc autoreg data=TS7.example74;
 model price=t sq/nlag=6 dwprob dw=8 backstep method=ml;
 output out=resdat4 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a trend';
run;


ods graphics off;
ods html close;
ods listing;





