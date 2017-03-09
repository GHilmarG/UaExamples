function    [ufixednode,ufixedvalue,vfixednode,vfixedvalue,utiedA,utiedB,vtiedA,vtiedB,hfixednode,hfixedvalue,htiedA,htiedB]=...
                DefineBCs(UserVar,CtrlVar,MUA,time,s,b,h,S,B,ub,vb,ud,vd,GF)
            

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);



% find nodes along boundary for which Dirichlet boundary conditions apply


xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));

nodesd=find(abs(x-xd)<1e-5); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
nodesu=find(abs(x-xu)<1e-5); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
nodesl=find(abs(y-yl)<1e-5); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
nodesr=find(abs(y-yr)<1e-5); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);


% fixing nodes up, left and right 
utiedA=[]; utiedB=[]; vtiedA=[]; vtiedB=[];
vfixednode=[nodesu;nodesl;nodesr];  vfixedvalue=[nodesu*0;nodesl*0;nodesr*0];
ufixednode=[nodesu];  ufixedvalue=[nodesu*0];
hfixednode=[];  hfixedvalue=[];
htiedA=[]; htiedB=[];


[vfixednode,ind]=unique(vfixednode);  vfixedvalue=vfixedvalue(ind);
[ufixednode,ind]=unique(ufixednode);  ufixedvalue=ufixedvalue(ind);


end
