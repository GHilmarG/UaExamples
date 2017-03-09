
n=1 ; m=3;
n=1 ; m=1;
n=3 ; m=3; 

hmean=1000; alpha=0.001; g=9.81/1000 ; rho=900;
SlipRatio=10; ud=1 ;
taub=rho*g*hmean*sin(alpha);

AGlen=ud/(2*taub^n*hmean/(n+1));
ub=SlipRatio*ud;
C=ub/taub^m;

fprintf(' A=%-g \t C=%-g \t n=%-i \t m=%-i \n ',AGlen,C,n,m)
AGlen
C
