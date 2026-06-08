function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)
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

xd=max(F.x(:)) ; xu=min(F.x(:)); yl=max(F.y(:)) ; yr=min(F.y(:));


%
% Find nodes along boundary:
% Here we are using the fact that all nodes along the boundary are in the list:
%
%   MUA.Boundary.Nodes
%
% And we only limit the search to those nodes.
%
L=min(sqrt(MUA.EleAreas)/1000); % set a distance tolerance which is a fraction of smallest element size

nodesd=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,1)-xd)<L) ;
nodesu=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,1)-xu)<L) ;
nodesl=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,2)-yl)<L);
nodesr=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,2)-yr)<L);


BCs.ubTiedNodeA=[nodesu;nodesl];
BCs.ubTiedNodeB=[nodesd;nodesr];

BCs.vbTiedNodeA=[nodesu;nodesl];
BCs.vbTiedNodeB=[nodesd;nodesr];

% There is a subtle issue with the nodal links as defined above. There is a redundancy in the definition of the corner nodes.
% For example, the upper-left node is linked to both the upper-right and the lower-left nodes. Then the upper-right node is
% then linked to the lower-right node, and the lower-right to the lower-left.
%
% Corner node links:
%
%  ul <-> ur
%  ul <-> dl
%  ur <-> lr
%  dl <-> dr (this is now redundant)
%
% The solution is to get rid of the dl <-> dr link

% ul=intersect(nodesu,nodesl) ;
% dl=intersect(nodesd,nodesl) ;
% dr=intersect(nodesd,nodesr) ;
% ur=intersect(nodesu,nodesr) ;
% 
% nodesd=setdiff(nodesd,[dr;dl]);
% nodesu=setdiff(nodesu,[ur;ul]);
% 
% BCs.ubTiedNodeA=[nodesu;nodesl];
% BCs.ubTiedNodeB=[nodesd;nodesr];
% 
% BCs.vbTiedNodeA=[nodesu;nodesl];
% BCs.vbTiedNodeB=[nodesd;nodesr];

end