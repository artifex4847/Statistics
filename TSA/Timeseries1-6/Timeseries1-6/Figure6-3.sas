ods html; 
ods listing close; 
ods graphics on; 
libname TS6 'c:\Library_timeseries';
/*option mprint nosymbolgen nomlogic;*/

%macro sampleACF_MA1(n=,m=);
  array mr1{&m};
   %do i=1 %to &m;

     data one;
	   e1=0;
       %do t=1 %to &n;
       e=normal(0);
       y=e+0.7*e1;
	   e1=e;
       output;
       %end;
     run;

     proc standard data=one out=two mean=0 std=1;
     var y;
     run;

     data three;
     set two;
     r1=y*lag(y);
     run;

	 proc means data=three noprint;
	 var r1;
	 output out=four&i mean=mr1&i;
	 run;
%end;

data five;
%do s=1 %to &m;
 set four&s;
 mr1=mr1&s;
 output;
 drop mr1&s _type_ _freq_;
 %end;
 run;

Proc univariate data=five normal;
 histogram mr1/normal;
 run;

%mend sampleACF_MA1; 

%sampleACF_MA1(n=200,m=200);
run;

ods graphics off;
ods html close;
ods listing;


/*
rand('lognormal')
rand('T',3)
rand('Cauchy')
rand('normal')
*/
