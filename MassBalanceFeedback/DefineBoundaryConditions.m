function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)


x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

% find nodes along boundary 
xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));

nodesd=find(abs(x-xd)<1e-5); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
nodesu=find(abs(x-xu)<1e-5); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
nodesl=find(abs(y-yl)<1e-5); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
nodesr=find(abs(y-yr)<1e-5); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);

BCs.ubFixedNode=[nodesu;nodesd;nodesl;nodesr]; 
BCs.ubFixedValue=BCs.ubFixedNode*0;
BCs.vbFixedNode=[nodesu;nodesd;nodesl;nodesr]; 
BCs.vbFixedValue=BCs.vbFixedNode*0;

end