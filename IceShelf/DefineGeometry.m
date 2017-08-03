
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);


b=zeros(MUA.Nnodes,1) ; 
S=zeros(MUA.Nnodes,1); 
B=zeros(MUA.Nnodes,1)-2000 ; % Set the ice-base to sea level and the water to be 2000m deep.

alpha = 0.0;  % zero slope of the coordinate system


s = InitialIceShelfSurfaceGeometry(UserVar,x,y);





end
