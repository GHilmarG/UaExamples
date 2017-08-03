function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
      
    
	n=3;	
    x=MUA.coordinates(:,1);
    AGlen=1.0e-9+x*0 ; 
    
%     sx=10e3 ;  AGlen=AGlen.*(1+9*exp(-(x.*x/sx^2)));  % Weird Glen mess!?
   
    
end

