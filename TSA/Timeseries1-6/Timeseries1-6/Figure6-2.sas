ods html; 
ods listing close; 
ods graphics on; 
libname TS6 'c:\Library_timeseries';
/*option mprint nosymbolgen nomlogic;*/

%macro sampleACF_AR1(n=,m=);
  array mr1{&m};
   %do i=1 %to &m;

     data one;
	   y=0;
       %do t=1 %to &n;
       y=0.7*y+rand('NORMAL'); 
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

Proc univariate data=five;
 histogram mr1/normal;
 run;

%mend sampleACF_AR1; 

%sampleACF_AR1(n=200,m=500);
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
