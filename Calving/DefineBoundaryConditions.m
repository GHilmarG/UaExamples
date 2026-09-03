


function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)

%BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)
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
%
%%


xd=max(F.x(:)) ; xu=min(F.x(:)); yl=max(F.y(:)) ; yr=min(F.y(:));
nodesd=find(abs(F.x-xd)<1e-5); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
nodesu=find(abs(F.x-xu)<1e-5); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
nodesl=find(abs(F.y-yl)<1e-5); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
nodesr=find(abs(F.y-yr)<1e-5); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);

BCs.ubFixedNode=nodesu ;
BCs.ubFixedValue=BCs.ubFixedNode*0;
BCs.vbFixedNode=[nodesu;nodesl;nodesr] ;
BCs.vbFixedValue=BCs.vbFixedNode*0;

if contains(UserVar.RunType,"-1dAnalyticalIceShelf-") || contains(UserVar.RunType,"-1dIceShelf-") 
    BCs.ubFixedValue=BCs.ubFixedNode*0+300;
    BCs.hFixedNode=nodesu ;
    BCs.hFixedValue=BCs.hFixedNode*0+1000;
end

if CtrlVar.LevelSetMethod
    BCs.LSFFixedNode=nodesu ;
    BCs.LSFFixedValue=200e3+BCs.LSFFixedNode*0;
end


end