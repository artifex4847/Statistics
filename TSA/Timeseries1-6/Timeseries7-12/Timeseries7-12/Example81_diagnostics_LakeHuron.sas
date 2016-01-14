
ods listing close;
ods html;  
ods graphics on; 
libname TS8 'c:\Library_timeseries';

Data TS8.example82;
infile 'C:\Data_BD\lake.tsm';
input elevation @@;
year=intnx('year','1jan1875'd, _N_-1);
format year year4.;
t=year(year);
elevation1=lag(elevation);
x=elevation-50.5109+0.0216*t; 
run;

data residuals_HL;
set TS8.example82;
e=x-1.0048*lag(x)+0.2913*lag2(x);
sresidual=e/sqrt(0.47605);
output;
run;

proc print data=residuals_HL;
run;

symbol1 i=join c=black v=circle h=1;
symbol2 i=r c=red v=none;

proc gplot data=residuals_HL;
plot sresidual*t=1 sresidual*t=2/overlay;
title 'Time plot of sresiduals of Lake Huron data(1875-1972)';
run;
/*
proc arima data=TS8.example82;
identify var=x nlag=30 stationarity=(adf=(0,1,2,3,4));
run;
estimate p=2 noconstant method=ml;
title 'Model selection';
run;
outlier;
run;
forecast out=results_LH;
run;

Proc print data=results_LH;
run;

Data residuals;
set results_LH;
if residual='.' then delete;
sresidual=residual/0.685601;
run;
*/

Proc univariate data=residuals_HL normal;
var sresidual;
histogram sresidual/normal;
probplot sresidual/normal(mu=0 sigma=1 color=red l=1 w=2);
qqplot sresidual/normal(mu=0 sigma=1 color=red l=1 w=2);
title;
run; 

data runcount;
   keep runs n1 n2 n;
   set residuals_HL nobs=nobs end=last;
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





