function [EleSizeDesired,ElementsToBeRefined]=...
    DefineDesiredEleSize(CtrlVar,MUA,x,y,EleSizeDesired,ElementsToBeRefined,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF,NodalErrorIndicators)

switch lower(CtrlVar.MeshRefinementMethod)
    
    case 'explicit:global'
        
        AGlen=[]; n=3 ;
        EleSizeIndicator=DesiredEleSizesBasedOnMeasVelocity(CtrlVar,MUA,s,b,S,B,rho,rhow,AGlen,n,GF);
        
        EleSizeDesired=min(EleSizeDesired,EleSizeIndicator);
        
        EleSizeIndicator=EleSizeDesired;
        EleSizeIndicator(GF.node<0.1)=CtrlVar.MeshSizeIceShelves;
        
        EleSizeDesired=min(EleSizeDesired,EleSizeIndicator);
        
        %EleSizeIndicator(s<3000)=CtrlVar.MeshSizeMax/2;
        %EleSizeIndicator(s<2000)=CtrlVar.MeshSizeMax/4;
        EleSizeIndicator(s<1500)=CtrlVar.MeshSizeMax/5;
        %EleSizeIndicator(s<1000)=CtrlVar.MeshSizeMax/10;
        EleSizeDesired=min(EleSizeDesired,EleSizeIndicator);
        
        xmin=-1727e3   ; xmax=-1100e3 ; ymin=-600e3 ; ymax=-20.e3;
        ind=x< xmax & x>xmin & y>ymin & y< ymax ;
        EleSizeDesired(~ind)=CtrlVar.MeshSizeMax;
        
end

end
