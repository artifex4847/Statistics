ods html; 
ods listing close; 
ods graphics on; 
libname TS1 'c:\Library_timeseries';

proc reg data=TS1.example11_1;
model temperatureV=t;
output out=example34runs r=residuals student=sresiduals;
run;

/*The following data step computes the total number of 
runs, the number of positive values (n1), 
and the number of negative values (n2). 
*/

data runcount;
   keep runs n1 n2 n;
   set example34runs nobs=nobs end=last;
   retain runs 0 n1 0;
      prevpos=(lag(sresiduals) GE 0);
        currpos=(sresiduals GE 0 );
      
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
/*These steps compute and display the Wald-Wolfowitz 
(or runs) test statistic and its p-value. 
*/

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
