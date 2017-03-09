function [ufixednode,ufixedvalue,vfixednode,vfixedvalue,utiedA,utiedB,vtiedA,vtiedB,hfixednode,hfixedvalue,htiedA,htiedB]=...
    DefineBCs(Experiment,coordinates,connectivity,Boundary,CtrlVar,u,v,s,b,S,B)

x=coordinates(:,1); y=coordinates(:,2);



% find nodes along boundary for which Dirichlet boundary conditions apply


xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));

nodesd=find(abs(x-xd)<1e-5); [~,ind]=sort(coordinates(nodesd,2)); nodesd=nodesd(ind);
nodesu=find(abs(x-xu)<1e-5); [~,ind]=sort(coordinates(nodesu,2)); nodesu=nodesu(ind);
nodesl=find(abs(y-yl)<1e-5); [~,ind]=sort(coordinates(nodesl,1)); nodesl=nodesl(ind);
nodesr=find(abs(y-yr)<1e-5); [~,ind]=sort(coordinates(nodesr,1)); nodesr=nodesr(ind);


% fixing nodes up, left and right 
utiedA=[]; utiedB=[]; vtiedA=[]; vtiedB=[];
vfixednode=[nodesu;nodesl;nodesr];  vfixedvalue=[nodesu*0;nodesl*0;nodesr*0];
ufixednode=[nodesu];  ufixedvalue=[nodesu*0+1];
hfixednode=[];  hfixedvalue=[];
htiedA=[]; htiedB=[];


[vfixednode,ind]=unique(vfixednode);  vfixedvalue=vfixedvalue(ind);
[ufixednode,ind]=unique(ufixednode);  ufixedvalue=ufixedvalue(ind);


end
