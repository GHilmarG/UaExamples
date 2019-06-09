
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
	
	
	hmean=1000;
	b=zeros(MUA.Nnodes,1) ; S=zeros(MUA.Nnodes,1); B=zeros(MUA.Nnodes,1)-2000 ;
	s=hmean+b;
	
	alpha=0.0;
	
	
end

