
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
		 logprice=log(price);
run;

symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;


proc gplot;
plot logprice*date=1 logprice*date=2/overlay;
title 'Time plot of log(oil price)';
run;

proc arima data=TS7.example74;
identify var=logprice(1) center stationarity=(adf=(0,1,2,3,4));
run;
estimate q=1 noconstant method=ml;
run;
outlier;
run;
forecast out=results;
run;

Proc print data=results;
run;

Data residuals;
set results;
sresidual=residual/0.081895;
run;

Proc univariate data=residuals normal;
var sresidual;
histogram sresidual/normal;
probplot sresidual/normal(mu=0 sigma=1 color=red l=1 w=2);
qqplot sresidual/normal(mu=0 sigma=1 color=red l=1 w=2);
title;
run; 

data runcount;
   keep runs n1 n2 n;
   set residuals nobs=nobs end=last;
   retain runs 0 n1 0;
      prevpos=(lag(sresidual) GE 0);
        currpos=(sresidual GE 0 );
      
        if currpos and prevpos then n1+1;
        else if currpos and ^prevpos then do;
           runs+1;
           n1+1;
           end;
        else if ^currpos and prevpos then runs+1;
        if last then do;
          n2=nobs-n1;
          n=nobs;
          output;
        end;
        run;

data waldwolf;
label z='Wald-Wolfowitz Z' pvalue='Pr > |Z|';
set runcount;
mu =(2*n1*n2)/(n1+n2)+ 1;
sigmasq=((2*n1*n2)*(2*n1*n2-n))/
    ((n**2)*(n-1));
        sigma=sqrt(sigmasq);
        drop sigmasq;
        if n GE 50 then Z=(runs - mu)/sigma;
        else if runs-mu LT 0 then Z = (runs-mu+0.5)/sigma;
          else Z = (runs-mu-0.5)/sigma;
        pvalue=2*(1-probnorm(abs(Z)));
        run;
      title  'Runs test for independence';
      title2 'H0: The data are independence';
      proc print data=waldwolf label noobs;
        var runs mu z pvalue;
        format pvalue pvalue.;
        run;


ods graphics off;
ods html close;
ods listing;





