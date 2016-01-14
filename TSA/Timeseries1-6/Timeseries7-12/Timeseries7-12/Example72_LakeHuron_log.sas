
ods listing close;
ods html;  
ods graphics on; 
libname TS7 'c:\Library_timeseries';

Data TS7.example72;
infile 'C:\Data_BD\lake.tsm';
input elevation @@;
year=intnx('year','1jan1875'd, _N_-1);
format year year4.;
t=year(year);
logtran=log(elevation);
run;

symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot data=TS7.example72;
plot logtran*t=1 logtran*t=2/overlay;
title 'Time plot of log(elevation) of Lake Huron (1875-1972)';
run;

proc arima data=TS7.example72;
identify var=logtran esacf scan minic
stationarity=(adf=(0,1,2,3,4));
run;
identify var=logtran(1) esacf center scan minic
stationarity=(adf=(0,1,2,3,4));
run;
estimate p=(1 3 4) noconstant method=ml;
title 'Model selection';
run;

proc autoreg data=TS7.example72;
 model logtran=t/nlag=6 dwprob dw=8 backstep method=ml;
 output out=resdat3 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a trend';
run;

data resck;
set resdat3;
title2 'The residual data set';

/*
Proc univariate data=resck normal;
var resid2;
histogram resid2/normal;
qqplot resid2/normal(mu=0 sigma=1 color=red l=1 w=2);
probplot resid2/normal(mu=0 sigma=1 color=red l=2 w=2);
title;
run;
*/

data together;
set resdat3;
if t > 1973 then forecast=.;
if t > 1973 then ucl=.;
if t > 1973 then lcl=.;
run;

data anno;
 input t 1-4 text $ 5-58;
 function='label'; angle = 90 ; xsys='2'; ysys='1';
 x=t; logtran=1963; position='B';
 cards;

axis1 label=(a=90 'the Lake Huron log(data)');
symbol1 i=join c=blue v=;
symbol2 i=join c=red v=F;
symbol3 i=join c=black line=1;
symbol4 i=join c=green line=20;
symbol5 i=join c=green line=20;

proc gplot data=together;
 plot (logtran forecast ytrend lcl ucl) * t/overlay 
 vaxis=axis1 href=50 annotate=anno;
 where t >1875 & t < 1973;

title 'Forecast of the Lake Huron data';
footnote1 'Star=actual data, F=forecast, Solid=trend';
 footnote2 'Dotted lines=forecast interval limits';
 run;



ods graphics off;
ods html close;
ods listing;





