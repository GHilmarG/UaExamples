function [UserVar,RunInfo,F1,l1,BCs1]=uvhPrescibed(UserVar,RunInfo,CtrlVar,MUA,F0,F1,l1,BCs1)


% get around the circul in 1000 years

r=sqrt(F1.x.*F1.x+F1.y.*F1.y);
theta=atan2(F1.y,F1.x);
R=1000e3; 

T=1000 ; 
speedMax=2*pi*R/T ;
%speedMax=1000;


F1.ub=-speedMax*(r/R).*sin(theta);
F1.vb= speedMax*(r/R).*cos(theta);



%  min(sqrt(2*MUA.EleAreas))/speedMax  CFT





end