function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)


alpha=0;
S=zeros(MUA.Nnodes,1);
B=zeros(MUA.Nnodes,1)-1e10;

h=300 ;
s=S;
b=s-h; 



end



