function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,ubFixedValue,b,h,S,B,ub,vb,ud,vd,GF)
%%
% BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)
%
% BC is a matlab object with the following fields 
%
% BCs = 
% 
%   BoundaryConditions with properties:
% 
%              ubFixedNode: []
%             ubFixedValue: []
%              vbFixedNode: []
%             vbFixedValue: []
%              ubTiedNodeA: []
%              ubTiedNodeB: []
%              vbTiedNodeA: []
%              vbTiedNodeB: []
%      ubvbFixedNormalNode: []
%     ubvbFixedNormalValue: []
%              udFixedNode: []
%             udFixedValue: []
%              vdFixedNode: []
%             vdFixedValue: []
%              udTiedNodeA: []
%              udTiedNodeB: []
%              vdTiedNodeA: []
%              vdTiedNodeB: []
%      udvdFixedNormalNode: []
%     udvdFixedNormalValue: []
%               hFixedNode: []
%              hFixedValue: []
%               hTiedNodeA: []
%               hTiedNodeB: []
%                 hPosNode: []
%                hPosValue: []
%       
%
% see also BoundaryConditions.m
% 
% Examples:
%
%  To set velocities at all grounded nodes along the boundary to zero:
%
%   GroundedBoundaryNodes=MUA.Boundary.Nodes(GF.node(MUA.Boundary.Nodes)>0.5);
%   BCs.vbFixedNode=GroundedBoundaryNodes; 
%   BCs.ubFixedNode=GroundedBoundaryNodes; 
%   BCs.ubFixedValue=BCs.ubFixedNode*0;
%   BCs.vbFixedValue=BCs.vbFixedNode*0;
%
% 
%%

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);


% find nodes along boundary 
dx=10;

Iu=x(MUA.Boundary.Nodes)<(min(x)+dx);   nodesu=MUA.Boundary.Nodes(Iu);
Id=x(MUA.Boundary.Nodes)<(max(x)-dx);   nodesd=MUA.Boundary.Nodes(Id);

Il=y(MUA.Boundary.Nodes)>(max(y)-dx);   nodesl=MUA.Boundary.Nodes(Il);
Ir=y(MUA.Boundary.Nodes)<(min(y)+dx);   nodesr=MUA.Boundary.Nodes(Ir);

Ic=x(MUA.Boundary.Nodes)>(min(x)+dx) &  x(MUA.Boundary.Nodes)<(max(x)-dx) &  y(MUA.Boundary.Nodes)>(min(y)+dx) &  y(MUA.Boundary.Nodes)<(max(y)-dx);
nodesc=MUA.Boundary.Nodes(Ic);

BCs.ubFixedNode=[nodesu;nodesc] ; 
BCs.ubFixedValue=[nodesu*0+100;nodesc*0] ;
BCs.vbFixedNode=[nodesu; nodesl; nodesr ; nodesc] ; 
BCs.vbFixedValue=BCs.vbFixedNode*0;

BCs.hFixedNode = nodesu ;
BCs.hFixedValue = InitialIceShelfSurfaceGeometry(UserVar,x(nodesu),y(nodesu));





