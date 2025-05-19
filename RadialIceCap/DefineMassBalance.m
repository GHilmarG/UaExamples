function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,F)


%%
%
% Defines mass balance along upper and lower ice surfaces.
%
%   [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
%
%   [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,F);
%
%   [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,CtrlVar.time,s,b,h,S,B,rho,rhow,GF);
%
%   [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F);
%
%   as        mass balance along upper surface 
%   ab        mass balance along lower ice surface
%   dasdh     upper surface mass balance gradient with respect to ice thickness (optional)
%   dabdh     lower surface mass balance gradient with respect to ice thickness (optional)
%  
% dasdh and dabdh only need to be specified if the implicit mass-balance feedback option is
% being used. To use the implicit mass-balance feedback option you must set
%
%   CtrlVar.MassBalanceGeometryFeedback=3;
%
% in DefineInitialInputs.m. Otherwise, the default value of 
%
%   CtrlVar.MassBalanceGeometryFeedback=0;
%
% is used, which does not include the implicit mass-balance feedback.
%
%
% IMPORTANT: In Ua the mass balance, as returned by this m-file, is multiplied internally by the local ice density. 
%
% The units of as and ab are the same units as those of velocity (something like m/yr or m/day).
%
% IMPORTANT: Often surface mass balance is provided my climate models as mass flux and in the units kg/(m^2 yr).  This is as
% if we prescribe the value of the product of density and accumulation rate, ie rho a, which has the units kg/(m^2 yr). In Ua
% this translation to mass flux is done internally, i.e. the rho is included in the mass conservation equation. The surface
% mass balance (as and ab) prescribed here as an input to Ua MUST BE IN THE UNITS distance/time, e.g. m/yr.
%
% If you have external data sets providing the mass flux in the units kg/(m^2 yr) you must divide those values here by the
% density, and this density must be the same density as is given in DefineGeometryAndDensities.m
%
% Also, if an external data sets provides the surface mass balance in the units of water equivalent, you must modify this
% value by the ratio between the density of water and the density of ice that you prescribe in DefineGeometryAndDensities.m,
% for example as 1000/rho, assuming rho is given in the units kg/m^3.
%
% For example, if you use a constant density for ice of 920 kg/m^3 and the surface mass balance is given as 1 m/yr of water
% equivalent (ie 1000 kg/(m^2 yr) ), the surface mass balance you need here is 1000/920 m/yr.
%
%
%
% As in all other calls:
%
%  F.s       : is upper ice surface
%  F.b       : lower ice surface
%  F.B       : bedrock
%  F.S       : ocean surface
%  F.rhow    : ocean density (scalar variable)
%  F.rho     : ice density (nodal variable)
%  F.g       : gravitational acceleration
%  F.x       : x nodal coordinates 
%  F.y       : y nodal coordinates 
%  F.GF      : The nodal grounded/floating mask (has other subfields)
%
%
%
% These fields need to be returned at the nodal coordinates. The nodal
% x and y coordinates are stored in MUA.coordinates, and also in F as F.x and F.y
%
%
% *Examples* : 
%
% *To set upper surface mass balance to zero, and melt along the lower ice
% surface to 10 over all ice shelves:* 
%
%   as=zeros(MUA.Nnodes,1);
%   ab=-(1-F.GF.node)*10 
%
%
% *To set upper surface mass balance as a function of local surface elevation and
% prescribe mass-balance feedback for the upper surface:* 
%
%   as=0.1*F.h+F.b;
%   dasdh=zeros(MUA.Nnodes,1)+0.1;
%   ab=F.s*0;
%   dabdh=zeros(MUA.Nnodes,1);
%
% Note: To use the implicit mass-balance feedback option you must set
%
%   CtrlVar.MassBalanceGeometryFeedback=3;
%
% in DefineInitialInputs.m. Otherwise, the default value of 
%
%   CtrlVar.MassBalanceGeometryFeedback=0;
%
% is used, which does not include the implicit mass-balance feedback.
%
% *To add basal melt due to sliding as a mass-balance term:* 
%
%   [tbx,tby,tb,beta2] = CalcBasalTraction(CtrlVar,MUA,F.ub,F.vb,F.C,F.m,F.GF);
%   L=333.44 ;                                        % Enthalpy of fusion = L = [J/gram = kJ/kg]  Make sure that the units are correct.
%   F.ab=-(tbx.*F.ub+tby.*F.vb)./(F.rho.*L);          % Ablation (Melt) is always negative, accumulation is positive
%
% 
%
%%



as=0.5;
ab=0; 




end

