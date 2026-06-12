function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


rho=900+zeros(MUA.Nnodes,1) ; rhow=1030; g=9.81/1000;



hmean=1000;


B=zeros(MUA.Nnodes,1);
S=B*0-1e10;

dB=UserVar.ampl_b*hmean*exp(-F.x.^2./UserVar.sigma_bx^2-F.y.^2./UserVar.sigma_by^2);
dB=dB-mean(dB(:)) ;



B=B+dB ;
b=B;
s=hmean ;

end




