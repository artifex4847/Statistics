ods html; 
ods listing close; 
ods graphics on; 
libname TS3 'c:\Library_timeseries';

Data figure21;
do month=1 to 200;
y=normal(0);
output;        
end;
run;

Proc gplot data=figure21; 
 symbol i=spline v=circle h=1.5; 
 plot y * month;
 title 'A simulated realization of WN N(0,1)';
 run;

proc autoreg data=figure21;
      model y = month/dw=4 dwprob normal;
	  title;
	  run;
quit;

Proc univariate data=figure21 normal;
    var y;
    histogram y/normal;
    probplot y/normal(mu=0 sigma=1 color=red l=3 w=2);
    qqplot y/normal(mu=0 sigma=1 color=red l=3 w=2);
	title;
run;
  /*
proc standard data=figure21 out=two mean=0;
        var y;
        run;
*/

data count;
   keep runs n1 n2 n;
   set figure21 nobs=nobs end=last;
   retain runs 0 n1 0;
      prevpos=(lag(y) GE 0);
        currpos=(y GE 0 );
      
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
set count;
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

  


