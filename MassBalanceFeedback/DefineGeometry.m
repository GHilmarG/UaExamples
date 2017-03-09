
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
% FieldsToBeDefined='sbSB' ;

alpha=0;
x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

B=zeros(MUA.Nnodes,1);
S=zeros(MUA.Nnodes,1);
b=B;

h=zeros(MUA.Nnodes,1)+10;
%I=abs(x)<10e3 & abs(y)<10e3;
%h(I)=100;

s=b+h;


end
