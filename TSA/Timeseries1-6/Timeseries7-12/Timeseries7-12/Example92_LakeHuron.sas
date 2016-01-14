
ods listing close;
ods html;  
ods graphics on; 
libname TS9 'c:\Library_timeseries';

Data TS9.example92;
infile 'C:\Data_BD\lake.tsm';
input elevation @@;
year=intnx('year','1jan1875'd, _N_-1);
format year year4.;
t=year(year);
elevation1=lag(elevation);
run;

symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot data=TS9.example92;
plot elevation*year=1 elevation*year=2/overlay;
title 'Time plot of elevation of Lake Huron (1875-1972)';
run;

proc arima data=TS9.example92;
identify var=elevation(1) scan esacf minic stationarity=(adf=(0,1,2,3,4));
run;
estimate p=2 noconstant method=ml; 
title 'Model selection';
run;
outlier;
run;
forecast lead=24 alpha=0.05 
id=year interval=year back=0 
out=results;
run;

symbol1 i=join c=blue v=circle h=1;
symbol2 i=join c=red  v=circle h=1;
symbol3 i=spline c=green v= h=;
symbol4 i=spline c=green v= h=;

proc gplot data=results;
plot elevation*year=1 forecast*year=2
l95*year=3 u95*year=4/overlay;
title 'Forecast of elevation of Lake Huron';
run;


 data b; 
      elevation = .; 
      do t = 1973 to 1997; output; end; 
run;

data bb; 
merge b TS9.example92;
by t; 
run;

proc autoreg data=bb;
 model elevation=t/nlag=6 dwprob dw=8 backstep method=ml;
 output out=resdat3 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a linear trend';
run;

axis1 label=(a=90 'Huron data from 1875 to 1972');

symbol1 i=join c=blue v=;
symbol2 i=join c=red v=F;
symbol3 i=join c=black line=1;
symbol4 i=join c=green line=20;
symbol5 i=join c=green line=20;


proc gplot data=resdat3;
 plot (elevation forecast ytrend lcl ucl) * t/overlay 
 vaxis=axis1 href=1950;
 where t>1875 & t <1997;

title 'Huron data from 1875 to 1972';
footnote1 'Star=actual data, F=forecast, Solid=trend';
 footnote2 'Dotted lines=forecast interval limits';
 run;









ods graphics off;
ods html close;
ods listing;





