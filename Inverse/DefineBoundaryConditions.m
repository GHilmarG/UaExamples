% function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)

function BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)


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

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));
nodesd=find(abs(x-xd)<1e-5); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
nodesu=find(abs(x-xu)<1e-5); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
nodesl=find(abs(y-yl)<1e-5); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
nodesr=find(abs(y-yr)<1e-5); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);

switch lower(UserVar.RunType)
    
    case 'icestream'
        
        % periodic boundary conditions
        % find nodes along boundary
        
        % 
        % BCs.ubTiedNodeA=[nodesu;nodesl]; BCs.ubTiedNodeB=[nodesd;nodesr];
        % BCs.vbTiedNodeA=[nodesu;nodesl]; BCs.vbTiedNodeB=[nodesd;nodesr];
        % BCs.hTiedNodeA=[nodesu;nodesl]; BCs.hTiedNodeB=[nodesd;nodesr];

        BCs.ubTiedNodeA=nodesu; BCs.ubTiedNodeB=nodesd;
        BCs.vbTiedNodeA=nodesu; BCs.vbTiedNodeB=nodesd;
        BCs.hTiedNodeA=[nodesu;nodesl]; BCs.hTiedNodeB=[nodesd;nodesr];
        
        BCs.vbFixedNode=[nodesl;nodesr] ;   BCs.vbFixedValue=BCs.vbFixedNode*0;
        



    case 'iceshelf'
        
        BCs.ubFixedNode=nodesu;  BCs.ubFixedValue=BCs.ubFixedNode*0;
        BCs.vbFixedNode=[nodesu;nodesl;nodesr];  BCs.vbFixedValue=BCs.vbFixedNode*0;
        
    otherwise

            error(' which case')
end



end