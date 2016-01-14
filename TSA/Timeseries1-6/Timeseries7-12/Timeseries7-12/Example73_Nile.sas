
ods listing close;
ods html;  
ods graphics on; 
libname TS7 'c:\Library_timeseries';

Data TS7.example73;
infile 'C:\Data_BD\Nile.tsm';
input waterlevel @@;
year=intnx('year','1jan1622'd, _N_-1);
format year year4.;
t=year(year)-1000;
waterlevel1=lag(waterlevel);
run;

symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot;
plot waterlevel*t=1 waterlevel*t=2/overlay;
title 'Time plot of waterlevel of Nile river (662-871)';
run;

proc gplot;
symbol1 i= c=black v=circle h=2;
plot waterlevel1*waterlevel;
title 'Scatter plot of (Y(t-1),Yt)';
run;

proc arima data=TS7.example73;
identify var=waterlevel(1) esacf center scan minic
stationarity=(adf=(0,1,2,3,4,5,6));
run;
estimate q=2 noconstant method=cls;
title 'Model selection with cls';
run;
estimate q=2 noconstant method=ml;
title 'Model selection with Ml';
run;
estimate q=2 noconstant method=uls;
title 'Model selection with uls';
run;

proc autoreg data=TS7.example73;
 model waterlevel=/nlag=6 dwprob dw=8 backstep method=ml;
 output out=resdat4 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a trend';
run;

ods graphics off;
ods html close;
ods listing;





