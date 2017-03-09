function [ufixednode,ufixedvalue,vfixednode,vfixedvalue,utiedA,utiedB,vtiedA,vtiedB,hfixednode,hfixedvalue,htiedA,htiedB]=...
                DefineBCs(UserVar,CtrlVar,MUA,time,s,b,h,S,B,ub,vb,ud,vd,GF)
            
        
    x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2);
    
    % periodic BCs
    
    
    
    nodesd=find(abs(x-min(x))<1000*eps); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
    nodesu=find(abs(x-max(x))<1000*eps); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
    nodesl=find(abs(y-min(y))<1000*eps); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
    nodesr=find(abs(y-max(y))<1000*eps); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);
    
    
    utiedA=[] ; utiedB=[];
    vtiedA=[] ; vtiedB=[];
    vfixednode=[nodesd;nodesl;nodesr];  vfixedvalue=vfixednode*0;
    ufixednode=nodesd;  ufixedvalue=ufixednode*0;
    
    
    htiedA=[] ; htiedB=[];
    hfixednode=[];  hfixedvalue=[];
    
    
    
    
end