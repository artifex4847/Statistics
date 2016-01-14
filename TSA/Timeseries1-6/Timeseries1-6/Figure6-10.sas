
ods listing close;
ods html;  
ods graphics on; 
libname TS6 'c:\Library_timeseries';

Data TS6.figure610;
infile 'C:\Data_CC\larain.dat';
input rainfall @@;
t=_N_-1;
if _N_<2 then delete;
year=intnx('year','1jan1878'd, _N_-1);
format year year4.;
run;

symbol1 i=join c=blue v=circle;
symbol2 i=r c=red v=none;

Proc gplot data=TS6.figure610; 
      plot rainfall * year rainfall * year/overlay;
      title;
run;


Proc gplot data=TS6.figure610; 
      plot rainfall * year;
      title 'Time plot of LA rainfall data(1878-1992)';
run;

Proc arima data=TS6.figure610;
identify var=rainfall scan esacf minic stationarity=(adf=6);
run;
identify var=rainfall(1) scan esacf minic stationarity=(adf=6);
run;

ods graphics off;
ods html close;
ods listing;





