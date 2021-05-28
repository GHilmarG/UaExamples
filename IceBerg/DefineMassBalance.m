function  [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

% s          : upper glacier surface elevation
% b          : lower glacier surface elevation
% S          : ocean surface elevation
% B          : bedrock elevation
% (ub,vb,wb) : sliding velocity components
% (ud,vd,wd) : deformational  velocity components
% rho        : ice density (defined at nodes and does not have to be spatially uniform)
% rhow       : ocean density (a scalar)
% AGlen      : rate factor of Glen's flow law  (either a nodal or an element variable)
% n          : stress exponent of the Glen's flow law
% C          : basal slipperiness ((either a nodal or an element variable)
% m          : stress exponent of the basal sliding law (a scalar)
% as, ab     : mass balance distribution over the upper (as) and lower (ab) glacier surfaces.
%              The mass balance is given in units distance/time, and should be
%              in same units as the velocity.
% alpha       : Slope of the coordinate system with respect to gravity.
% g           : The gravitational acceleration.
% GF          : a floating/grounded mask. This is a structure with the two
%               fields: node and ele. This are 1 if a node/element is grounded, 0 if
%               node/element is afloat.

as=0 ;
ab=0;
dasdh=0;
dabdh=0;


end