function [UserVar,ElementsToBeDeactivated]=...
    DefineElementsToDeactivate(UserVar,RunInfo,CtrlVar,MUA,xEle,yEle,ElementsToBeDeactivated,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF)

%%  Manually deactivate elements within a mesh.   
%
% This file is called within each run step if CtrlVar.ManuallyDeactivateElements=true
%  
%
%   [UserVar,ElementsToBeDeactivated]=...
%       DefineElementsToDeactivate(UserVar,RunInfo,CtrlVar,MUA,xEle,yEle,ElementsToBeDeactivated,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF)
%
% *Example:*  To deactivate all elements outside of the region bounded by
% BoundaryCoordinats in run-step 2:
%
% 
%   if CtrlVar.CurrentRunStepNumber==2
%
%       BoundaryCoordinates=[0 0 ; 10e3 0 ; 10e3 20e3 ; -5e3 15e3 ] ;    
%       In=inpoly([xEle yEle],BoundaryCoordinates);
%       ElementsToBeDeactivated=~In;
%     
%     
%       figure
%       PlotMuaMesh(CtrlVar,MUA,ElementsToBeDeactivated,'r')
%       hold on
%       PlotMuaMesh(CtrlVar,MUA,~ElementsToBeDeactivated,'k')
%  
%   end
% 
% 


fprintf(' DefineElementsToDeactivate \n')

if CtrlVar.time > 2
    
    if UserVar.InitialGeometry=="-MismipPlus-"
        GF=IceSheetIceShelves(CtrlVar,MUA,GF);
        ElementsToBeDeactivated=GF.ElementsDownstreamOfGroundingLines & (MUA.xEle>500e3) ;

    else  % flow-line case 
        ElementsToBeDeactivated=GF.ElementsDownstreamOfGroundingLines & (MUA.xEle>500e3) ;
    end
    
end









end