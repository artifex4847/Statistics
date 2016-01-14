ods html; 
ods listing close; 
ods graphics on; 
libname TS6 'c:\Library_timeseries';
/*option mprint nosymbolgen nomlogic;*/

%macro sampleACF_WN(n=,m=);
  array mr1{&m} mr10{&m};

%do i=1 %to &m;

     data one;
       %do t=1 %to &n;
       y=rand('NORMAL'); 
       output;
       %end;
     run;

     proc standard data=one out=two mean=0 std=1;
     var y;
     run;

     data three;
     set two;
     r1=y*lag(y);
	 r10=y*lag10(y);
     run;

	 proc means data=three noprint;
	 var r1 r10;
	 output out=four&i mean=mr1&i mr10&i;
	 run;
%end;

data five;
%do s=1 %to &m;
 set four&s;
 mr1=mr1&s;
 mr10=mr10&s;
 output;
 drop mr1&s mr10&s _type_ _freq_;
 %end;
 run;

Proc univariate data=five normal;
 histogram mr1/normal;
 histogram mr10/normal;
 run;

%mend sampleACF_WN; 

%sampleACF_WN(n=1000,m=500);
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
