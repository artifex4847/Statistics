ods html; 
ods listing close; 
ods graphics on; 

Data example10_sale;
         infile 'c:\Data_CC\beersales.dat';
         input beersales @@;
         if _N_<2 then delete;
       date = intnx( 'month', '1jan1975'd, _N_-2); 
         format date monyy.; 
	     char = date; 
         format char monname1.;  
	     month=month(date);
         t=_N_;
		 sq=t*t;
         x1=cos(2*3.14159*t/12);
         x2=sin(2*3.14159*t/12);	
run;
Data example10_sale_1;
set example10_sale;
if _N_<61 then delete;
run;

symbol1 i=spline c= v=circle h=1.5;
symbol2 i=r c=red v= h=1;

Proc gplot data=example10_sale_1;  
      plot beersales * date=1 beersales * date=2/overlay;
      title 'Monthly US beersales from 1980 to 1990';
   run;
    
Proc arima data=example10_sale_1;	
  identify var=beersales(12) stationarity=(adf=(0,1,2,3,4,5)) nlag=50;
run;
  estimate q=(12 24) method=ml;
run; 
  outlier;
run;
  forecast lead=24 id=date interval=month back=0 out=out;
run;

Proc print data=out;
run;

symbol1 i=spline c=blue v=circle h=0.5;
symbol2 i=joint c=red  v= h=1;
symbol3 i=spline c=green v= h=1;
symbol4 i=spline c=green v= h=1;

Proc gplot data=out;
plot beersales*date=1 
     forecast*date=2 
     l95*date=3
	 u95*date=4/overlay;
title 'Monthly US beersales from 1980 to 1990';
run;



data b5; 
      beersales=.;
      do t = 194 to 217;
       sq=t*t; 
	   x1=cos(2*3.14159*t/12);
       x2=sin(2*3.14159*t/12);	
      output; end; 
run;

data bb5; 
merge b5 example10_sale_1;;
by t; 
run;


proc autoreg data=bb5;
 model beersales=x1 x2 sq/ nlag=49 backstep method=ml;
 output out=resdat105 r=resid2 ucl=ucl lcl=lcl p=forecast pm=ytrend;
 title 'With a consine and sine trend';
run;

axis1 label=(a=90 'Monthly US beersales from 1980 to 1992');
symbol1 i=join c=blue v=;
symbol2 i=join c=red v=F;
symbol3 i=join c=black line=1;
symbol4 i=join c=green line=20;
symbol5 i=join c=green line=20;


proc gplot data=resdat105;
 plot (beersales forecast ytrend lcl ucl) * t/overlay 
 vaxis=axis1 href=193;
 where t>61 & t <218;

title 'Monthly US beersales from 1980 to 1992';
footnote1 'Star=actual data, F=forecast, Solid=trend';
 footnote2 'Dotted lines=forecast interval limits';
 run;

ods graphics off;
ods html close;
ods listing;


