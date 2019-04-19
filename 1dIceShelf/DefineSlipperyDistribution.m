function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

    

	
	%m=3 ;  C=1/20^m+zeros(Nnodes,1); % m=3 , 1 m/a and basal shear stress of 20 kPa
    m=3 ; C=1/20^m+zeros(MUA.Nnodes,1); C=C(:);
    
	%C=C.*(1+10*Hi(y,x,0,0,1e4,1e4,1));
		
	%sx=25e3 ; sy=25e3; 
	%C=C.*(1+10*exp(-(x.*x/sx^2+y.*y./sy^2)));
        
    %d=50e3; K=5; W=10e3;
    %C=C.*(K*(atan((y+d)/W)+atan((-y+d)/W))/(pi+1)+1);
    

    
    
    
end