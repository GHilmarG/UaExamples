
function  [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)


%%
%
% User input m-file to define A and n in the Glenn-Steinemann flow law
%
%   [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)
% 
%   [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
%
% Note: Use
%
%   [AGlen,B]=AGlenVersusTemp(T)
%
% to get A in the units kPa^{-3} yr^{-1} for some temperature T (degrees Celsius) 
%
%% 



n=3 ; AGlen=AGlenVersusTemp(-25); % A in the units kPa^{-3} yr^{-1}

end

